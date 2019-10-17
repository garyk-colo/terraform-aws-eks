#
# Provider Configuration

variable "aws-region" {}

provider "aws" {
  region = var.aws-region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "http" {}
