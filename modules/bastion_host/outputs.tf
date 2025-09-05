output "public_ip" {
    description = "The public IP address of the bastion host."
    value       = aws_instance.bastion_host.public_ip
}

output "security_group_id" {
    description = "The ID of the bastion's security group."
    value       = aws_security_group.bastion_sg.id
}

