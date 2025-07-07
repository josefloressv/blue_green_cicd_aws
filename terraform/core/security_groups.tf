resource "aws_security_group" "asg" {
  vpc_id = module.net.vpc_id
  name   = "${local.name_prefix}-asg-default"

  ingress {
    description = "Allow HTTPS Inbound From ALB"
    from_port   = 1
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet1_cidr, var.public_subnet2_cidr]

  }
  egress {
    description = "Allow all for egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-asg-default"
  })
}

resource "aws_security_group" "alb" {
  vpc_id = module.net.vpc_id
  name   = "${local.name_prefix}-alb"

  ingress {
    description = "Allow HTTP Inbound From Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS Inbound From Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all for egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alb"
  })
}