# Search for AMI ID
data "aws_ami" "search" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [local.name_pattern]
  }

  filter {
    name   = "architecture"
    values = [local.architecture]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
