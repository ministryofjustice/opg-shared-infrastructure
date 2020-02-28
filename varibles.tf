variable "default_role" {
  default = "ci"
}

variable "management_role" {
  default = "ci"
}

variable "accounts" {
  type = map(string)

  default = {
    development = "679638075911"
    production  = "997462338508"
    management  = "311462405659"
  }
}

