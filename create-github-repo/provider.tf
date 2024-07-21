terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.2.3"
    }
  }

  backend "s3" {}
}

provider "github" {}

provider "aws" {
  region = "ap-southeast-2"
}
