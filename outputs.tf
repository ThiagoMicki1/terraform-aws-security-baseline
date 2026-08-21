output "cloudtrail_name" {
  description = "Name of the baseline CloudTrail trail."
  value       = aws_cloudtrail.baseline.name
}

output "cloudtrail_log_bucket" {
  description = "S3 bucket intended for CloudTrail and AWS Config logs."
  value       = aws_s3_bucket.security_logs.id
}

output "guardduty_detector_id" {
  description = "GuardDuty detector ID after future deployment."
  value       = aws_guardduty_detector.baseline.id
}

output "restricted_security_group_id" {
  description = "Example security group ID after future deployment."
  value       = aws_security_group.restricted_admin_example.id
}
