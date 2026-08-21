# Project Decisions

This lab is intentionally small. I wanted it to show Terraform security thinking without turning into a full AWS landing zone.

## Validation-first workflow

The default workflow runs `terraform fmt`, `terraform init -backend=false`, `terraform validate`, and Checkov. It does not run `terraform apply` because I wanted the repo to be safe to review without AWS credentials.

## AWS-managed encryption

Some resources use AWS-managed encryption instead of a customer-managed KMS key. That is a tradeoff for this learning lab: it keeps the Terraform easier to read and avoids adding key-policy complexity before there is a real deployment plan.

## Simple root-level Terraform

I kept the Terraform files at the root instead of creating modules. Modules would make sense if this baseline was reused across accounts or environments, but for a portfolio lab they would mostly add navigation overhead.

## Placeholder values

The sample account ID, VPC ID, bucket name, and trusted CIDR are safe placeholders. A real deployment would need a local `terraform.tfvars` file, a reviewed plan, and cost awareness before applying anything.
