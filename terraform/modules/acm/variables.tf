variable "tags" {
  type = map(string)
}

variable "domain_name" {
  type = string
}

variable "subject_alternative_names" {
  type = list(string)
  default = []
}