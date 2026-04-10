# terraform-aws-account-baseline

Shared Terraform module that defines the standard security baseline for every AWS account.

## Background

This module is the **security foundation** for all AWS accounts in the organization. It is called by [`aft-global-customizations`](https://github.com/aws-mk0/aft-global-customizations), which means every account provisioned through AFT automatically gets this baseline applied.

```
aft-global-customizations
    │
    └── calls this module
            │
            ├── IAM password policy (CIS-aligned)
            ├── Account-level S3 public access block
            └── Default EBS encryption
```

## What It Does

| Resource | What | Key Settings |
|---|---|---|
| `aws_iam_account_password_policy` | Enforces strong passwords for IAM users | 14 char min, uppercase + lowercase + numbers + symbols required, 90-day rotation, 24 password reuse prevention |
| `aws_s3_account_public_access_block` | Prevents any S3 bucket from being made public | All 4 block settings enabled (block public ACLs, block public policy, ignore public ACLs, restrict public buckets) |
| `aws_ebs_encryption_by_default` | Encrypts all new EBS volumes automatically | Uses AWS-managed key |

## What It Does NOT Do

- **Tagging** — `default_tags` are a provider-level config, not a module concern. Tags are set in `aft-global-customizations` (universal `managed_by=AFT` tag) and `aft-account-customizations` (per-account `app`, `owner`, `developer`, `environment` tags).
- **GuardDuty, SecurityHub, Config rules** — these are Phase 3 (Security Baselines), not part of the initial baseline module.
- **Networking** — VPCs, security groups, NACLs are workload-specific and handled separately.

## Usage

Reference this module from `aft-global-customizations/terraform/main.tf`:

```hcl
module "account_baseline" {
  source = "github.com/aws-mk0/terraform-aws-account-baseline?ref=v1.0.0"
}
```

Always pin to a specific version tag (`?ref=v1.0.0`). Never reference `main` directly.

### Input Variables

All variables have sensible defaults. Override only if needed:

| Variable | Type | Default | Description |
|---|---|---|---|
| `iam_minimum_password_length` | number | `14` | Minimum IAM password length |
| `iam_max_password_age` | number | `90` | Days before password rotation required |
| `iam_password_reuse_prevention` | number | `24` | Number of previous passwords blocked |
| `enable_s3_public_access_block` | bool | `true` | Enable account-level S3 public access block |
| `enable_ebs_default_encryption` | bool | `true` | Enable default EBS volume encryption |

### Outputs

| Output | Description |
|---|---|
| `iam_password_policy_expire_passwords` | Whether IAM password expiration is enabled |
| `s3_public_access_block_enabled` | Whether S3 public access block is enabled |
| `ebs_default_encryption_enabled` | Whether EBS default encryption is enabled |

## Module Structure

```
terraform-aws-account-baseline/
├── main.tf          # Resource definitions (IAM policy, S3 block, EBS encryption)
├── variables.tf     # Input variables with defaults
├── outputs.tf       # Output values
├── versions.tf      # Terraform >= 1.5.0, AWS provider >= 5.0
└── README.md
```

## Versioning

This module uses **git tags** for versioning (e.g., `v1.0.0`). When making changes:

1. Edit the module code
2. Commit and push to `main`
3. Create a new tag: `git tag v1.1.0 && git push origin --tags`
4. Update the version reference in `aft-global-customizations` to point to the new tag

> **Future:** When HCP Terraform is available, this module will be published to the HCP private registry. The module code stays the same — only the `source` line in consumers changes.

## References

- [CIS AWS Foundations Benchmark](https://docs.aws.amazon.com/securityhub/latest/userguide/cis-aws-foundations-benchmark.html)
- [AFT Overview](https://docs.aws.amazon.com/controltower/latest/userguide/aft-overview.html)
- [Terraform Module Sources — GitHub](https://developer.hashicorp.com/terraform/language/modules/sources#github)
