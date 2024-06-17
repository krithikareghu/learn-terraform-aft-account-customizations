/**
  * # Network_Firewall Module
  * 
  * This is the readme of the aws network firewall module. This module can be used to create KMS key, network firewall, cloudwatch log group for network firewall alerts, flows and configure aws network firewall logging.
  *
  * The iam policy document is obtained from the data source.
  */

# Create a KMS key for CloudWatch Log encryption

resource "aws_kms_key" "log_key" {
  description             = "KMS Logs Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.policy_kms_logs_document.json
  tags = merge(var.tags_for_all, {
    Name      = "nfw-flow-logs"
    CreatedOn = formatdate("YYYY-DD-MM", timestamp())
  })
}


data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "policy_kms_logs_document" {
  statement {
    sid       = "Enable IAM User Permissions"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid = "Enable KMS to be used by CloudWatch Logs"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }
  }
}

# Create an AWS Network Firewall

resource "aws_networkfirewall_firewall" "inspection_vpc_network_firewall" {
  name                = "nfw-central-insp-${data.aws_region.current.name}"
  firewall_policy_arn = var.nfw_policy_arn
  vpc_id              = var.inspection_vpc_id

  dynamic "subnet_mapping" {
    for_each = var.inspection_subnet

    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = merge(var.tags_for_all, {
    Name      = "NetworkFirewall"
    CreatedOn = formatdate("YYYY-DD-MM", timestamp())
  })

}

# Create a Cloudwatch Log Group for AWS Network Firewall Alerts

resource "aws_cloudwatch_log_group" "network_firewall_alert_log_group" {
  name              = "/aws/network-firewall/alerts"
  kms_key_id        = aws_kms_key.log_key.arn
  retention_in_days = 7
  tags = merge(var.tags_for_all, {
    Name      = "network-firewall-alerts"
    CreatedOn = formatdate("YYYY-DD-MM", timestamp())
  })
  depends_on = [
    aws_kms_key.log_key
  ]
}

# Create a Cloudwatch Log Group for AWS Network Firewall Flows

resource "aws_cloudwatch_log_group" "network_firewall_flow_log_group" {
  name              = "/aws/network-firewall/flows"
  kms_key_id        = aws_kms_key.log_key.arn
  retention_in_days = 7
  tags = merge(var.tags_for_all, {
    Name      = "network-firewall-flows"
    CreatedOn = formatdate("YYYY-DD-MM", timestamp())
  })
  depends_on = [
    aws_kms_key.log_key
  ]
}

# Configure AWS Network Firewall logging

resource "aws_networkfirewall_logging_configuration" "network_firewall_alert_logging_configuration" {
  firewall_arn = aws_networkfirewall_firewall.inspection_vpc_network_firewall.arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.network_firewall_alert_log_group.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.network_firewall_flow_log_group.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "FLOW"
    }
  }
}
