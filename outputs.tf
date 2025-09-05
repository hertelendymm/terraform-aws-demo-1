# output "bastion_SSH" {
#     value = "ssh -i ./keys/bastion ubuntu@${module.bastion_host[0].public_ip_address}"
# }

output "webapp_load_balancer_dns" {
    description = "The public DNS name of the web application's load balancer. Paste this into your browser."
    value       = module.webapp.load_balancer_dns_name
}

output "bastion_public_ip" {
    description = "The public IP of the bastion host. Use this to connect via SSH."
    # This expression safely returns the IP if the bastion exists, or a message if it doesn't.
    value = var.do_i_want_bastion ? module.bastion_host[0].public_ip : "Bastion host was not created."
}