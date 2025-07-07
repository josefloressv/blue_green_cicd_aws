variable "tags" {
  type = map(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "create_http_listener" {
  type    = bool
  default = true
}

variable "create_https_listener" {
  type    = bool
  default = false
}

variable "certificate_arn" {
  type    = string
  default = ""
}

variable "security_groups" {
  type = list(string)
}