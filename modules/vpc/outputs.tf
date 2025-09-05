output "vpc_id" {
    description = "The ID of the main VPC."
    value       = aws_vpc.main.id
}

output "public_subnet_id" {
    value = aws_subnet.public.id
}

output "private_subnet_id" {
    value = aws_subnet.private.id
}

output "vpc_cidr_block" {
    description = "The CIDR block of the VPC."
    value       = aws_vpc.main.cidr_block
}
