###############################################################################
# IAM Account Password Policy
# Strong password requirements for IAM users (defense-in-depth).
# Primary access is via SSO — IAM users should be rare/blocked by SCP.
# Passwords never expire (NIST 800-63B). MFA enforced via SCP at OU level.
###############################################################################

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = var.iam_minimum_password_length
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = var.iam_max_password_age
  password_reuse_prevention      = var.iam_password_reuse_prevention
  hard_expiry                    = false
}

###############################################################################
# IMDSv2 Enforcement
# Require IMDSv2 (token-based) for all EC2 instances in this account.
# Prevents SSRF attacks from accessing instance metadata.
###############################################################################

resource "aws_ec2_instance_metadata_defaults" "imdsv2" {
  http_tokens                 = "required"
  http_put_response_hop_limit = 2
}

###############################################################################
# Account-Level S3 Public Access Block
# Prevents any S3 bucket in the account from being made public.
###############################################################################

resource "aws_s3_account_public_access_block" "block" {
  count = var.enable_s3_public_access_block ? 1 : 0

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

###############################################################################
# Default EBS Encryption
# All new EBS volumes are encrypted by default (AWS-managed key).
###############################################################################

resource "aws_ebs_encryption_by_default" "enabled" {
  count   = var.enable_ebs_default_encryption ? 1 : 0
  enabled = true
}
