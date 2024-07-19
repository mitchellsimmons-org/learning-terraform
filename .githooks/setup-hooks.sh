#!/bin/sh

# Set up Git hooks
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
ABS_SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)
ROOT_DIR=$(dirname "$ABS_SCRIPT_DIR")

echo $ROOT_DIR

mkdir -p "$ROOT_DIR/.git/hooks"
cp -r "$ROOT_DIR/.githooks/hooks" "$ROOT_DIR/.git"
chmod -R +x "$ROOT_DIR/.git/hooks"