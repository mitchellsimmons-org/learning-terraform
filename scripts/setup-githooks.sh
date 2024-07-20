#!/bin/bash
set -euo pipefail

copy-githooks() {
    SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
    ABS_SCRIPT_DIR=$(cd "${SCRIPT_DIR}" && pwd)
    ROOT_DIR=$(dirname "${ABS_SCRIPT_DIR}")

    mkdir -p "${ROOT_DIR}/.git/hooks"
    cp -r "${ROOT_DIR}/scripts/githooks"/* "${ROOT_DIR}/.git/hooks"
    chmod +x "${ROOT_DIR}"/.git/hooks/*
}

get-os() {
    OS=$(uname -s)
    case $OS in
        Linux*)     echo "linux";;
        Darwin*)    echo "darwin";;
        CYGWIN*)    echo "windows";;
        MINGW*)     echo "windows";;
        MSYS*)      echo "windows";;
        *)          
        echo "Unsupported OS"
        exit 1
        ;;
    esac
}

get-file-suffix() {
    ARCHITECTURE=$(uname -m)
    case $ARCHITECTURE in
        x86_64)     echo "${OS}_x64";;
        arm64*)     echo "${OS}_arm64";;
        *)          
        echo "Unsupported architecture"
        exit 1
        ;;
    esac
}

download-gitleaks() {
    GITLEAKS_API_URL="https://api.github.com/repos/gitleaks/gitleaks/releases/latest"
    GITLEAKS_VERSION=$(curl -s "${GITLEAKS_API_URL}" | jq -r '.tag_name')
    STRIPPED_GITLEAKS_VERSION=$(echo "${GITLEAKS_VERSION}" | sed 's/^v//')
    GITLEAKS_DOWNLOAD_URL="https://github.com/gitleaks/gitleaks/releases/download/${GITLEAKS_VERSION}"
    OS=$(get-os)
    FILE_SUFFIX=$(get-file-suffix)

    if [[ $OS = "windows" ]]; then
        FILE_NAME="gitleaks_${STRIPPED_GITLEAKS_VERSION}_${FILE_SUFFIX}.zip"
    else
        FILE_NAME="gitleaks_${STRIPPED_GITLEAKS_VERSION}_${FILE_SUFFIX}.tar.gz"
    fi

    FILE_PATH="${TEMP_DIR}/${FILE_NAME}"
    echo $FILE_PATH
    curl --location --silent "${GITLEAKS_DOWNLOAD_URL}/${FILE_NAME}" -o "${FILE_PATH}"
}

install-gitleaks() {
    mkdir -p "${INSTALL_DIR}"

    if [[ $OS = "windows" ]]; then
        unzip "${FILE_PATH}" -d "${INSTALL_DIR}"
    else
        tar -xzf "${FILE_PATH}" -C "${INSTALL_DIR}"
    fi
}

export-path() {
    if [ "${OS}" = "linux" ] || [ "${OS}" = "darwin" ]; then
        if ! echo "${PATH}" | grep -q "${INSTALL_DIR}"; then
            if [ "${OS}" = "linux" ]; then
                CONFIG_FILE="${HOME}/.bashrc"
            elif [ "$OS" = "darwin" ]; then
                CONFIG_FILE="${HOME}/.zshrc"
            fi

            echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$CONFIG_FILE"
            source "${CONFIG_FILE}"
        fi
    elif [ "$OS" = "windows" ]; then
        if ! echo "${PATH}" | grep -q "${INSTALL_DIR}"; then
            CONFIG_FILE="${HOME}/.bash_profile"
            echo "export PATH=\"\$PATH;$INSTALL_DIR\"" >> "$CONFIG_FILE"
            source "${CONFIG_FILE}"
        fi
    fi
}

cleanup() {
    rm -rf "${TEMP_DIR}"
}

main() {
    TEMP_DIR=$(mktemp -d)
    trap cleanup EXIT
    INSTALL_DIR="${HOME}/gitleaks"

    copy-githooks
    download-gitleaks
    install-gitleaks
    export-path
}

main