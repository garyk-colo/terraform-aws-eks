#
# Provider Configuration

variable "aws-region" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}

provider "aws" {
  region = var.aws-region
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"  
}

provider "http" {}
