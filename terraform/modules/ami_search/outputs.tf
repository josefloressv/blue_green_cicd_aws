
output "id" {
  value = data.aws_ami.search.id
}

output "name" {
  value = data.aws_ami.search.name
}

output "creation_date" {
  value = data.aws_ami.search.creation_date
}

output "deprecation_time" {
  value = data.aws_ami.search.deprecation_time
}

output "platform_details" {
  value = data.aws_ami.search.platform_details
}

output "architecture" {
  value = data.aws_ami.search.architecture
}

output "image_type" {
  value = data.aws_ami.search.image_type
}
