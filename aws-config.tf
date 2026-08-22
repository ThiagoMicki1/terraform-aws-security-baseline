resource "aws_iam_role" "config" {
  name = "${var.project_name}-aws-config"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "config" {
  role       = aws_iam_role.config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_config_configuration_recorder" "baseline" {
  name     = local.config_recorder_name
  role_arn = aws_iam_role.config.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "baseline" {
  name           = local.config_recorder_name
  s3_bucket_name = aws_s3_bucket.security_logs.id
  s3_key_prefix  = "aws-config"

  depends_on = [aws_config_configuration_recorder.baseline]
}

resource "aws_config_configuration_recorder_status" "baseline" {
  name       = aws_config_configuration_recorder.baseline.name
  is_enabled = true

  depends_on = [aws_config_delivery_channel.baseline]
}

resource "aws_config_config_rule" "s3_public_read_prohibited" {
  name = "${var.project_name}-s3-public-read-prohibited"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }

  depends_on = [aws_config_configuration_recorder_status.baseline]
}

resource "aws_config_config_rule" "iam_user_mfa_enabled" {
  name = "${var.project_name}-iam-user-mfa-enabled"

  source {
    owner             = "AWS"
    source_identifier = "IAM_USER_MFA_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder_status.baseline]
}
