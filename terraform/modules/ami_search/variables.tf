variable "image_platform" {
  description = "The operating system platform of the AMI"
  type        = string
  validation {
    condition     = var.image_platform == "linux" || var.image_platform == "windows"
    error_message = "The image_platform must be either 'linux' or 'windows'"
  }
}

variable "image_architecture" {
  description = "The architecture of the AMI, must be either 'arm64' or 'amd64'"
  type        = string
  validation {
    condition     = var.image_architecture == "arm64" || var.image_architecture == "amd64"
    error_message = "The image_architecture must be either 'arm64' or 'amd64'"
  }
}

variable "image_date" {
  description = "The date of the AMI in the format YYYY-MM"
  type        = string
  validation {
    condition     = can(regex("^\\d{4}-\\d{2}$", var.image_date))
    error_message = "The image_date must be in the format YYYY-MM"
  }
}