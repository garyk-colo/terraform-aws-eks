#
# Provider Configuration

variable "aws-region" {}

provider "aws" {
  region = var.aws-region
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"  
}

provider "http" {}
