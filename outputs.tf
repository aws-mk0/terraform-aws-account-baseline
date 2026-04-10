output "iam_password_policy_expire_passwords" {
  description = "Whether IAM password expiration is enabled"
  value       = aws_iam_account_password_policy.strict.expire_passwords
}

output "s3_public_access_block_enabled" {
  description = "Whether account-level S3 public access block is enabled"
  value       = var.enable_s3_public_access_block
}

output "ebs_default_encryption_enabled" {
  description = "Whether default EBS encryption is enabled"
  value       = var.enable_ebs_default_encryption
}
