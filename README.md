# terraform-aws-account-baseline

Shared Terraform module defining the standard AWS account baseline.

## Purpose

This module provides the standard baseline configuration applied to every AWS account in the organization. It is referenced by [`aft-global-customizations`](https://github.com/aws-mk0/aft-global-customizations) as part of the [AFT](https://docs.aws.amazon.com/controltower/latest/userguide/aft-overview.html) pipeline.

## What It Covers

- **Mandatory tags** via `default_tags`
- **IAM password policy** enforcement
- **S3 public access block** (account-level)
- **Security defaults** (baseline hardening)

## Usage

```hcl
module "account_baseline" {
  source = "github.com/aws-mk0/terraform-aws-account-baseline?ref=v1.0.0"
}
```

## Module Structure

```
terraform-aws-account-baseline/
├── main.tf              # Core resources
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── versions.tf          # Required provider versions
└── README.md
```

## Versioning

This module is versioned via git tags (e.g., `v1.0.0`). Always reference a specific version in your module source to ensure reproducible builds.

## References

- [AFT Overview](https://docs.aws.amazon.com/controltower/latest/userguide/aft-overview.html)
- [AFT Terraform Module](https://github.com/aws-ia/terraform-aws-control_tower_account_factory)
- [Terraform Module Sources — GitHub](https://developer.hashicorp.com/terraform/language/modules/sources#github)
