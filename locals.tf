locals {
  cloudtrail_name          = "${var.project_name}-trail"
  cloudtrail_log_group     = "/aws/cloudtrail/${var.project_name}"
  config_recorder_name     = "${var.project_name}-config"
  cloudtrail_source_arn    = "arn:aws:cloudtrail:${var.aws_region}:${var.sample_account_id}:trail/${local.cloudtrail_name}"
  config_delivery_role_arn = "arn:aws:iam::${var.sample_account_id}:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig"
}
