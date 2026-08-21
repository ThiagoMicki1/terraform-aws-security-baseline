# Terraform AWS Security Baseline

[![Terraform Security Baseline](https://github.com/ThiagoMicki1/terraform-aws-security-baseline/actions/workflows/terraform-security.yml/badge.svg)](https://github.com/ThiagoMicki1/terraform-aws-security-baseline/actions/workflows/terraform-security.yml)

An intermediate Terraform portfolio lab that defines a small AWS security baseline: CloudTrail, S3 log storage, GuardDuty, AWS Config, IAM password policy, a least-privilege role example, and a restricted security group example.

This is a learning lab. It is not a full production landing zone, and it does not deploy anything by default.

## Why I Built This

I built this project to practice AWS security baselines in Terraform without needing to touch a real AWS account. I wanted something realistic enough to discuss in interviews, but simple enough that I can explain every resource and every tradeoff.

## What This Project Does

- Defines foundational AWS security controls in Terraform
- Validates safely with `terraform init -backend=false` and `terraform validate`
- Runs Checkov IaC scanning
- Uses safe placeholder values only
- Avoids real AWS credentials, real account IDs, real ARNs, and automatic deployment

## Safe Validation Mode vs Future Deployment

Safe validation mode is the default. It does not need AWS credentials and does not create cloud resources.

Future deployment is optional. Before any real deployment, replace placeholder values in a local `terraform.tfvars`, review costs, run `terraform plan`, and only apply when you intentionally want AWS resources created.

Do not run `terraform apply` as part of the normal portfolio workflow.

## Included AWS Controls

| Control | Purpose |
| --- | --- |
| CloudTrail | Records AWS API activity for audit and investigations. |
| CloudWatch log group | Stores CloudTrail logs with retention for easier review. |
| S3 log bucket | Stores CloudTrail and AWS Config logs. |
| S3 block public access | Helps prevent public exposure of security logs. |
| S3 encryption | Encrypts log objects with AWS-managed encryption. |
| S3 versioning | Helps preserve log history if objects are changed. |
| GuardDuty | Enables managed AWS threat detection. |
| IAM password policy | Enforces stronger IAM user password settings. |
| Least-privilege role example | Shows scoped read-only access instead of broad admin access. |
| Restricted security group | Avoids inbound access from `0.0.0.0/0`. |
| AWS Config | Records resource configuration history. |

More detail: [docs/security-controls.md](docs/security-controls.md)

Design notes: [docs/decisions.md](docs/decisions.md)

## Folder Structure

```text
terraform-aws-security-baseline/
|-- .github/workflows/terraform-security.yml
|-- docs/decisions.md
|-- docs/security-controls.md
|-- reports/
|-- aws-config.tf
|-- locals.tf
|-- outputs.tf
|-- providers.tf
|-- s3-cloudtrail.tf
|-- security-controls.tf
|-- variables.tf
|-- versions.tf
|-- terraform.tfvars.example
|-- .checkov.yml
|-- .gitattributes
|-- .gitignore
`-- README.md
```

## Run Terraform Validation Safely

```bash
terraform fmt -recursive
terraform init -backend=false
terraform validate
```

This validates syntax and provider configuration. It does not deploy resources.

## Run Checkov

```bash
checkov -d . --config-file .checkov.yml
```

Checkov scans the Terraform for common cloud security misconfigurations.

## Placeholder Values

Use `terraform.tfvars.example` as a safe example only. For any future deployment:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Then replace sample values. `terraform.tfvars` is gitignored because real deployment values should not be committed casually.

## Cost Warning

This repo is free to validate locally, but future deployment can create AWS costs. GuardDuty, AWS Config, CloudTrail log delivery, CloudWatch Logs, and S3 storage can all have charges depending on usage and retention.

## Cleanup If Deployed Later

If you intentionally deploy later, clean up with:

```bash
terraform destroy
```

Then verify in the AWS Console that S3 buckets, CloudWatch log groups, GuardDuty, AWS Config, IAM roles, and security groups are removed or intentionally retained.

## What I Learned

- A baseline is mostly about visibility, least privilege, and safe defaults.
- Terraform validation is useful even before having AWS credentials.
- S3 log buckets need several controls working together: encryption, versioning, and public access blocking.
- Some secure choices, like customer-managed KMS keys, add policy complexity that should be understood before adding them.

## What I Struggled With

The main challenge was keeping the repo realistic without pretending it is production-ready. I chose AWS-managed encryption in a couple places because it keeps the lab readable and lower-complexity, but I documented where a production version should consider customer-managed KMS keys.

## Interview Talking Points

- Why I kept this validation-only and left deployment as an intentional future step.
- How CloudTrail, GuardDuty, AWS Config, and S3 log protection support detection and investigation.
- Where I would add customer-managed KMS keys, Config rules, or multi-account controls in a real environment.

## Future Improvements

- Add a customer-managed KMS key version after practicing key policies.
- Add a small set of AWS Config managed rules with a clearer cost estimate.
