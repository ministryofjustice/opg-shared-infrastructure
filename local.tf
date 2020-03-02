locals {
  mandatory_moj_tags = {
    business-unit    = "OPG"
    application      = "opg-shared-infrastructure"
    environment-name = terraform.workspace
    is-production    = tostring(local.account.is_production)
    owner            = "opgteam@digital.justice.gov.uk"
  }
  optional_tags = {
    source-code            = "https://github.com/ministryofjustice/opg-shared-infrastructure"
    infrastructure-support = "opgteam@digital.justice.gov.uk"
  }

  environment = terraform.workspace
  account     = contains(keys(var.accounts), local.environment) ? var.accounts[local.environment] : var.accounts.development

  default_tags = merge(local.mandatory_moj_tags, local.optional_tags)
}

