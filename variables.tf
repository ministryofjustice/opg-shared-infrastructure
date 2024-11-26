variable "default_role" {
  default = "shared-ci"
  type    = string
}

variable "management_role" {
  default = "shared-ci"
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
