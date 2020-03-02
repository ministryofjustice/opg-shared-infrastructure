locals {
  mandatory_moj_tags = {
    business-unit    = "OPG"
    application      = "opg-shared-infrastructure"
    environment-name = terraform.workspace
    owner            = "Sean Privett: sean.privett@digital.justice.gov.uk"
  }

  optional_tags = {
    infrastructure-support = "OPG Webops: opgteam@digital.justice.gov.uk"
  }

  is_production = {
    "development" = "false"
    "production"  = "true"
  }

  default_tags = merge(local.mandatory_moj_tags, local.optional_tags)
}

