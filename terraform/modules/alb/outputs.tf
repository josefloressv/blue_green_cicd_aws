output "alb_http_listener_arn" {
  value = length(aws_lb_listener.http) > 0 ? aws_lb_listener.http[0].arn : null
}

output "alb_https_listener_arn" {
  value = length(aws_lb_listener.https) > 0 ? aws_lb_listener.https[0].arn : null
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "alb_zone_id" {
  value = aws_lb.main.zone_id
}