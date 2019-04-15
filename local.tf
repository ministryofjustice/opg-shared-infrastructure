locals {
  account = "${lookup(var.accounts, terraform.workspace)}"

  mandatory_moj_tags = {
    business-unit    = "OPG"
    application      = "opg-shared-infrastructure"
    environment-name = "${terraform.workspace}"
    owner            = "Sean Privett: sean.privett@digital.justice.gov.uk"
  }

  optional_tags = {
    infrastructure-support = "OPG Webops: opgteam@digital.justice.gov.uk"
  }

  default_tags = "${merge(local.mandatory_moj_tags,local.optional_tags)}"
}

variable "accounts" {
  type = "map"
}
