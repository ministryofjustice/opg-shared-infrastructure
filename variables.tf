variable "default_role" {
  default = "ci"
}

variable "management_role" {
  default = "ci"
}

variable "accounts" {
  type = map(
    object({
      account_id    = string
      is_production = number
    })
  )
}

