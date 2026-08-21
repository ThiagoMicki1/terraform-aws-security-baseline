variable "project_name" {
  description = "Name prefix for the portfolio security baseline resources."
  type        = string
  default     = "terraform-aws-security-baseline"
}

variable "aws_region" {
  description = "AWS region for a future optional deployment."
  type        = string
  default     = "us-east-1"
}

variable "sample_account_id" {
  description = "Sample placeholder AWS account ID. Replace before any real deployment."
  type        = string
  default     = "123456789012"
}

variable "cloudtrail_bucket_name" {
  description = "Globally unique S3 bucket name for CloudTrail and AWS Config logs."
  type        = string
  default     = "sample-security-baseline-logs-123456789012"
}

variable "trusted_admin_cidr" {
  description = "Example trusted CIDR for the security group. Uses documentation IP space by default."
  type        = string
  default     = "203.0.113.10/32"
}

variable "example_vpc_id" {
  description = "Placeholder VPC ID for the security group example. Replace before deployment."
  type        = string
  default     = "vpc-00000000000000000"
}
