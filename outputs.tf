output "kubeconfig" {
  value       = module.eks.kubeconfig
  description = "EKS Kubeconfig"
}

output "config-map" {
  value       = module.eks.config-map-aws-auth
  description = "K8S config map to authorize"
}

output "jx_params" {
  value = "--provider=eks --gitops --no-tiller --vault --aws-dynamodb-region=${var.aws-region} --aws-dynamodb-table=${aws_dynamodb_table.vault-data.name} --aws-kms-=${var.aws-region} --aws-kms-key-id=${aws_kms_key.bank_vault.key_id} --aws-s3-region=${var.aws-region}  --aws-s3-bucket=${aws_s3_bucket.vault-unseal.id} --aws-access-key-id=${aws_iam_access_key.vault.id} --aws-secret-access-key=${aws_iam_access_key.vault.secret}"
  description = "Output KMS key id, S3 bucket name and secret name in the form of jx install options"
}
