locals {
  waf_blocking_enabled = terraform.workspace == "development" ? true : false
}

resource "aws_wafv2_web_acl" "shared" {
  name        = "shared-${terraform.workspace}-web-acl"
  description = "Managed Rules Shared ${terraform.workspace}"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    dynamic "override_action" {
      for_each = local.waf_blocking_enabled ? [1] : []
      content {
        none {}
      }
    }

    dynamic "override_action" {
      for_each = local.waf_blocking_enabled ? [] : [1]
      content {
        count {}
      }
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "SizeRestrictions_BODY"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    dynamic "override_action" {
      for_each = local.waf_blocking_enabled ? [1] : []
      content {
        none {}
      }
    }

    dynamic "override_action" {
      for_each = local.waf_blocking_enabled ? [] : [1]
      content {
        count {}
      }
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesLinuxRuleSet"
    priority = 6

    dynamic "override_action" {
      for_each = local.waf_blocking_enabled ? [1] : []
      content {
        none {}
      }
    }

    dynamic "override_action" {
      for_each = local.waf_blocking_enabled ? [] : [1]
      content {
        count {}
      }
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesLinuxRuleSet"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 4

    dynamic "override_action" {
      for_each = local.waf_blocking_enabled ? [1] : []
      content {
        none {}
      }
    }

    dynamic "override_action" {
      for_each = local.waf_blocking_enabled ? [] : [1]
      content {
        count {}
      }
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesUnixRuleSet"
    priority = 7

    dynamic "override_action" {
      for_each = local.waf_blocking_enabled ? [1] : []
      content {
        none {}
      }
    }

    dynamic "override_action" {
      for_each = local.waf_blocking_enabled ? [] : [1]
      content {
        count {}
      }
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesUnixRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesUnixRuleSet"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "AWS-AWSManagedRulesWordPressRuleSet"
    priority = 8

    dynamic "override_action" {
      for_each = local.waf_blocking_enabled ? [1] : []
      content {
        none {}
      }
    }

    dynamic "override_action" {
      for_each = local.waf_blocking_enabled ? [] : [1]
      content {
        count {}
      }
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesWordPressRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesWordPressRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "shared-${terraform.workspace}-web-acl"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "shared" {
  log_destination_configs = [aws_cloudwatch_log_group.waf_shared.arn]
  resource_arn            = aws_wafv2_web_acl.shared.arn
}
