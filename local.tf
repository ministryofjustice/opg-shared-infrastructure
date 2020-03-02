locals {
  mandatory_moj_tags = {
    # The capitalized names are required by Salt
    business-unit    = "OPG"
    application      = "opg-shared-infrastructure"
    environment-name = local.environment
    Environment      = local.environment
    owner            = "OPGOPS opgteam@digital.justice.gov.uk"
    Project          = "core"
    is-production    = tostring(local.account.is_production)
    Stack            = local.environment
    source-code      = "https://github.com/ministryofjustice/opg-shared-infrastructure"
  }

  optional_tags = {
    infrastructure-support = "OPG Webops: opgteam@digital.justice.gov.uk"
  }

  environment = terraform.workspace
  account     = contains(keys(var.accounts), local.environment) ? var.accounts[local.environment] : var.accounts.development

  default_tags = merge(local.mandatory_moj_tags, local.optional_tags)
}

