variable "default_role" {
  default = "shared-ci"
}

variable "management_role" {
  default = "shared-ci"
}

variable "accounts" {
  type = map(
    object({
      account_id    = string
      is_production = number
    })
  )
}
