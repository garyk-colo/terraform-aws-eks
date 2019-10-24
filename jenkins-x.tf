
variable "region" {
    default ="us-west-2"
}

provider "aws" {
    region  = "${var.aws-region}"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
}

variable "bucket_domain" {
    default = "jx-colosseumusa"
    type        = string
    description = "Suffix for S3 bucket used for vault unseal operation"
}

# Create S3 bucket for KMS
resource "aws_s3_bucket" "vault-unseal" {
    bucket = "vault-unseal.${var.aws-region}.${var.bucket_domain}"
    acl    = "private"

    versioning {
        enabled = false
    }
}

# Create KMS key
resource "aws_kms_key" "bank_vault" {
    description = "KMS Key for bank vault unseal"
}

# Create DynamoDB table
resource "aws_dynamodb_table" "vault-data" {
    name           = "vault-data"
    read_capacity  = 2
    write_capacity = 2
    hash_key       = "Path"
    range_key      = "Key"
    attribute {
        name = "Path"
        type = "S"
    }

    attribute {
        name = "Key"
        type = "S"
    }
}

# Create service account for vault. Should the policy
resource "aws_iam_user" "vault" {
  name = "vault_${var.aws-region}"
}

data "aws_iam_policy_document" "vault" {
    statement {
        sid = "DynamoDB"
        effect = "Allow"
        actions = [
            "dynamodb:DescribeLimits",
            "dynamodb:DescribeTimeToLive",
            "dynamodb:ListTagsOfResource",
            "dynamodb:DescribeReservedCapacityOfferings",
            "dynamodb:DescribeReservedCapacity",
            "dynamodb:ListTables",
            "dynamodb:BatchGetItem",
            "dynamodb:BatchWriteItem",
            "dynamodb:CreateTable",
            "dynamodb:DeleteItem",
            "dynamodb:GetItem",
            "dynamodb:GetRecords",
            "dynamodb:PutItem",
            "dynamodb:Query",
            "dynamodb:UpdateItem",
            "dynamodb:Scan",
            "dynamodb:DescribeTable"
        ]
        resources = ["${aws_dynamodb_table.vault-data.arn}"]
    }
    statement {
        sid = "S3"
        effect = "Allow"
        actions = [
                "s3:PutObject",
                "s3:GetObject"
        ]
        resources = ["${aws_s3_bucket.vault-unseal.arn}/*"]
    }
    statement {
        sid = "S3List"
        effect = "Allow"
        actions = [
            "s3:ListBucket"
        ]
        resources = ["${aws_s3_bucket.vault-unseal.arn}"]
    }
    statement {
        sid = "KMS"
        effect = "Allow"
        actions = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:DescribeKey"
        ]
        resources = ["${aws_kms_key.bank_vault.arn}"]
    }
}

resource "aws_iam_user_policy" "vault" {
    name = "vault_${var.aws-region}"
    user = "${aws_iam_user.vault.name}"

    policy = "${data.aws_iam_policy_document.vault.json}"
}

resource "aws_iam_access_key" "vault" {
    user = "${aws_iam_user.vault.name}"
}
