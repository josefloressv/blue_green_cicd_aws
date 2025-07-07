resource "aws_launch_template" "main" {
  name_prefix = local.name_prefix
  description = "ASG template for ${local.name_prefix}"

  image_id      = var.lt_ami_id
  instance_type = var.lt_instance_type

  user_data = base64encode(templatefile("${path.module}/templates/${local.lt_template}", {
    cluster_name    = aws_ecs_cluster.main.name
    extra_user_data = var.lt_extra_user_data
  }))

  ebs_optimized = true
  dynamic "block_device_mappings" {
    for_each = var.use_default_block_device_mapping ? [] : [1]
    content {
      device_name = var.lt_block_device_name
      ebs {
        volume_type = "gp3"
        volume_size = var.lt_volume_size

        # Performance.
        iops       = 3000
        throughput = 125

        encrypted             = true
        delete_on_termination = true
      }
    }
  }

  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    name = aws_iam_instance_profile.lt.name
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = var.lt_security_groups
  }

  # EC2 detailed monitoring
  monitoring {
    enabled = true
  }

  #  Instance Metadata Service
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  hibernation_options {
    configured = false
  }

  # AWS Nitro Secure Enclave
  enclave_options {
    enabled = false
  }

  # EC2 Instance tags
  tag_specifications {
    resource_type = "instance"

    # Merge a "Name" tag into the list of tags passed-in.
    tags = merge(
      var.tags,
      {
        "Name" = "${local.name_prefix}"
      },
    )
  }

  # EBS Volume tags
  tag_specifications {
    resource_type = "volume"
    tags          = var.tags
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true

    ignore_changes = [
      tags,
      tag_specifications,
      description
    ]
  }

}