variable "default_role" {
  default = "oidc-opg-shared-infrastructure-shared-development"
  type    = string
}

variable "accounts" {
  type = map(
    object({
      account_id    = string
      is_production = number
    })
  )
}
