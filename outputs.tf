output "public_dns_name" {
  description = "Public DNS names of the load balancer for this project"
  value       = "lb-${random_string.lb_id.result}-project-alpha-dev.elb.amazonaws.com"
}
