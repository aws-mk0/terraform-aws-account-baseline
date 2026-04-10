###############################################################################
# IAM Password Policy
###############################################################################

variable "iam_minimum_password_length" {
  description = "Minimum length for IAM user passwords"
  type        = number
  default     = 14
}

variable "iam_max_password_age" {
  description = "Maximum age in days before passwords must be rotated"
  type        = number
  default     = 90
}

variable "iam_password_reuse_prevention" {
  description = "Number of previous passwords that cannot be reused"
  type        = number
  default     = 24
}

###############################################################################
# S3
###############################################################################

variable "enable_s3_public_access_block" {
  description = "Enable account-level S3 public access block"
  type        = bool
  default     = true
}

###############################################################################
# EBS
###############################################################################

variable "enable_ebs_default_encryption" {
  description = "Enable default EBS volume encryption"
  type        = bool
  default     = true
}
