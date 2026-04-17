# CLAUDE.md — terraform-aws-account-baseline

## What This Repo Is

This is a **shared Terraform module** that defines the standard AWS account baseline. It is the single module that enforces organizational security and compliance defaults across all accounts. It is consumed by `aft-global-customizations` via a versioned GitHub source reference.

## How It Fits Into the AFT Pipeline

```
aft-global-customizations
  └── module "account_baseline" {
        source = "github.com/aws-mk0/terraform-aws-account-baseline?ref=v1.1.0"
      }
        → Applied to every AFT-managed account
```

This module does not run on its own — it is called as a module by `aft-global-customizations`.

## File Structure

Standard Terraform module layout:

```
├── main.tf              # Core resources (tags, IAM policy, S3 block, security defaults)
├── variables.tf         # Input variables with sensible defaults
├── outputs.tf           # Output values for consumers
├── versions.tf          # Required provider and Terraform version constraints
└── README.md
```

## What This Module Covers

- **IAM password policy** enforcement (never-expire passwords per NIST 800-63B, strong complexity requirements)
- **IMDSv2 enforcement** via `aws_ec2_instance_metadata_defaults` (prevents SSRF-based metadata credential theft)
- **S3 public access block** at the account level
- **Default EBS encryption** (all new volumes encrypted automatically)

## Versioning

- Current version: **v1.1.0**
- Versioned via **git tags** (e.g., `v1.1.0`)
- Consumers reference specific versions: `?ref=v1.1.0`
- Follow semantic versioning: breaking changes = major bump, new features = minor, fixes = patch
- Always tag a release after merging changes to `main`

## Interim Setup Note

This module is currently sourced directly from GitHub. It will eventually migrate to **HCP Terraform private registry**. When that happens, only the `source` line in consumers changes — the module logic itself stays the same. Write the module with this migration in mind (standard structure, clean interfaces).

## Guard Rails

- **NEVER push directly to `main`** — always open a pull request for review
- **NEVER remove security controls** without explicit approval — these exist for compliance
- **NEVER make breaking changes without a major version bump** — consumers pin to specific versions
- **Always tag a release** after merging to `main` so consumers can reference the new version
- Test changes locally with `terraform validate` and `terraform plan` before opening a PR
- Treat every change as production-impacting — the sandpit may become permanent

## Coding Standards

- Use consistent formatting with `terraform fmt`
- Follow standard Terraform module conventions: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`
- All variables should have descriptions and sensible defaults where appropriate
- All outputs should have descriptions
- Keep the module focused — only account-level baseline concerns belong here
