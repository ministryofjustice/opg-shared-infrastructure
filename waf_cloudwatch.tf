resource "aws_cloudwatch_query_definition" "blocked_requests" {
  name            = "AWS-WAF/blocked-requests-acl"
  log_group_names = [aws_cloudwatch_log_group.waf_shared.name]
  query_string    = <<EOF
fields action, terminatingRuleId, ruleGroupList.0.terminatingRule.ruleId, httpRequest.country, httpRequest.clientIp, httpRequest.uri
| filter action != 'ALLOW'
| stats count() by action, terminatingRuleId, ruleGroupList.0.terminatingRule.ruleId, httpRequest.country, httpRequest.clientIp, httpRequest.uri
EOF
}

resource "aws_cloudwatch_query_definition" "counted_requests" {
  name            = "AWS-WAF/counted-requests"
  log_group_names = [aws_cloudwatch_log_group.waf_shared.name]
  query_string    = <<EOF
fields action, terminatingRuleId, ruleGroupList.0.terminatingRule.ruleId, httpRequest.country, httpRequest.clientIp, httpRequest.uri
| filter nonTerminatingMatchingRules.0.action = "COUNT"
| stats count() by action, terminatingRuleId, ruleGroupList.0.terminatingRule.ruleId, httpRequest.country, httpRequest.clientIp, httpRequest.uri
EOF
}

resource "aws_cloudwatch_log_group" "waf_shared" {
  name              = "aws-waf-logs-shared-${terraform.workspace}"
  retention_in_days = 400
  kms_key_id        = aws_kms_key.waf_cloudwatch_log_encryption.arn
  tags = {
    "Name" = "aws-waf-logs"
  }
}

resource "aws_kms_key" "waf_cloudwatch_log_encryption" {
  description             = "AWS WAF Cloudwatch encryption Shared ${terraform.workspace}"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.waf_cloudwatch_log_encryption_kms.json
}

resource "aws_kms_alias" "waf_cloudwatch_log_encryption" {
  name          = "alias/waf_cloudwatch_log_encryption"
  target_key_id = aws_kms_key.waf_cloudwatch_log_encryption.key_id
}

data "aws_iam_policy_document" "waf_cloudwatch_log_encryption_kms" {
  statement {
    sid       = "Enable Root account permissions on Key"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }

  statement {
    sid       = "Allow Key to be used for Encryption"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    principals {
      type = "Service"
      identifiers = [
        "logs.eu-west-1.amazonaws.com",
        "events.amazonaws.com"
      ]
    }
  }

  statement {
    sid       = "Key Administrator"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/breakglass"]
    }
  }
}
