# learning-terraform

This repository contains a set of basic Terraform configurations, each organised into a separate folder. Each folder has an associated workflow which is used to validate the configurations. The workflow will generate a plan upon creating a PR and automatically add it as a comment to the PR. Merging changes into the main branch will proceed to apply any planned changes. Finally, all resources will be destroyed since this is just for learning.

# Setup

Install a pre-commit git hook that will protect the main branch as well as prevent credentials from accidentally being leaked in a commit.

```shell
./scripts/setup-githooks.sh
```

# Contents

## create-ec2

Terraform configurations for creating an EC2 instance using the AWS provider and an S3 backend for storing state. The `create-ec2.yml` workflow will plan, apply, and destroy resources upon merging changes into main.

## create-github-repo

Terraform configurations for creating a Github repository using the Github provider and an S3 backend for storing state. The `create-github-repo.yml` workflow will plan, apply, and destroy resources upon merging changes into main.
