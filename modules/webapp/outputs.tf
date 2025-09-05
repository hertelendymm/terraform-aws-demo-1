output "private_ip_addresses" {
    description = "A list of the private IP addresses of the web app instances."
    # This uses a splat expression (*) to collect the private_ip from all created instances.
    value       = aws_instance.webapp[*].private_ip
}

output "load_balancer_dns_name" {
    description = "The public DNS name of the Network Load Balancer."
    value       = aws_lb.webapp_nlb.dns_name
}

