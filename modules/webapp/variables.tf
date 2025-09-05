variable "project_name" {
    description = "The name of the project."
    type        = string
}

variable "vpc_id" {
    description = "The ID of the VPC."
    type        = string
}

variable "vpc_cidr_block" {
    description = "The CIDR block of the VPC for security group rules."
    type        = string
}

variable "public_subnet_id" {
    description = "The ID of the public subnet for the load balancer."
    type        = string
}

variable "private_subnet_id" {
    description = "The ID of the private subnet where web servers will be placed."
    type        = string
}

variable "key_name" {
    description = "The name of the SSH key to use for the instances."
    type        = string
}

variable "bastion_sg_id" {
    description = "The ID of the bastion host's security group for SSH access."
    type        = string
}

variable "instance_count" {
    description = "The number of web app instances to create."
    type        = number
    default     = 2
}

variable "instance_type" {
    description = "The EC2 instance type for the web servers."
    type        = string
    default     = "t2.micro"
}