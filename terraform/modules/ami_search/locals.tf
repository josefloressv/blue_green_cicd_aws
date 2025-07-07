locals {
  architecture = var.image_architecture == "amd64" ? "x86_64" : "arm64"
  platform     = var.image_platform == "linux" ? "Linux/UNIX" : "Windows"
  image_date   = var.image_platform == "linux" ? replace(var.image_date, "-", "") : replace(var.image_date, "-", ".")
  name_pattern = var.image_platform == "linux" ? "al2023-ami-ecs-hvm-2023.0.${local.image_date}*-kernel-6.1-arm64" : "Windows_Server-2022-English-Full-ECS_Optimized-${local.image_date}*"
}