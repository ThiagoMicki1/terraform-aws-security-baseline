resource "aws_guardduty_detector" "baseline" {
  # checkov:skip=CKV2_AWS_3:Single-account portfolio lab; organization-wide GuardDuty is a future improvement.
  enable = true
}

resource "aws_iam_account_password_policy" "baseline" {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  require_uppercase_characters   = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 24
}

resource "aws_iam_role" "readonly_audit_example" {
  name = "${var.project_name}-readonly-audit-example"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "readonly_audit_example" {
  name = "${var.project_name}-readonly-audit-example"
  role = aws_iam_role.readonly_audit_example.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.security_logs.arn
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:FilterLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
      }
    ]
  })
}

resource "aws_security_group" "restricted_admin_example" {
  # checkov:skip=CKV2_AWS_5:This is an intentionally unattached security group pattern example.
  name        = "${var.project_name}-restricted-admin"
  description = "Example security group that avoids public inbound access"
  vpc_id      = var.example_vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "restricted_admin_https" {
  security_group_id = aws_security_group.restricted_admin_example.id
  description       = "Example admin HTTPS access from one trusted CIDR only"
  cidr_ipv4         = var.trusted_admin_cidr
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "restricted_private_https" {
  security_group_id = aws_security_group.restricted_admin_example.id
  description       = "Example private HTTPS egress only"
  cidr_ipv4         = "10.0.0.0/8"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}
