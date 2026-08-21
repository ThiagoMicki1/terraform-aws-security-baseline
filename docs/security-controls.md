# Security Controls

This is a portfolio learning lab, not a complete production landing zone. The Terraform defines a small AWS security baseline that can be validated without AWS credentials.

## CloudTrail

CloudTrail records AWS API activity. The trail is configured as multi-region, includes global service events, and enables log file validation.

Protects against: missing audit visibility during investigations.

## CloudWatch Log Group

CloudTrail also sends events to a CloudWatch log group with 365-day retention.

Protects against: short log retention and lack of near-real-time log access.

Tradeoff: this lab uses AWS-managed CloudWatch encryption instead of a customer-managed KMS key to keep the example small.

## S3 Log Bucket

The S3 bucket stores CloudTrail and AWS Config logs. It has public access blocked, server-side encryption enabled, versioning enabled, and a lifecycle rule for old noncurrent versions.

Protects against: public log exposure, accidental overwrite, and unencrypted log storage.

Tradeoff: this lab uses AWS-managed S3 encryption. A production baseline should consider a customer-managed KMS key with a reviewed key policy.

Tradeoff: cross-region replication and bucket event notifications are documented future improvements, not part of this small safe-validation lab.

## GuardDuty

GuardDuty is enabled as a managed threat detection service.

Protects against: missing managed detection for suspicious AWS activity, such as credential misuse or unusual API behavior.

Cost note: GuardDuty can create cost after trial periods or at scale.

Tradeoff: this lab enables a single-account detector. A real organization should design GuardDuty across accounts and regions.

## IAM Password Policy

The account password policy requires length, complexity, rotation, and password reuse prevention.

Protects against: weak IAM user passwords.

## Least-Privilege Example Role

The example IAM role can read only the baseline log bucket metadata and CloudWatch log streams for the CloudTrail log group.

Protects against: broad permissions becoming the default example.

## Restricted Security Group

The example security group allows inbound HTTPS only from a trusted documentation CIDR, not `0.0.0.0/0`.

Protects against: accidental public inbound exposure.

Tradeoff: the security group is intentionally unattached because this repo does not create EC2 instances or application infrastructure.

## AWS Config

AWS Config records resource configuration history and delivers snapshots to the log bucket.

Protects against: not knowing when resource configuration changed.

Cost note: AWS Config can create meaningful cost because it records configuration items.
