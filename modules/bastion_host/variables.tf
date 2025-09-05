variable "aws_region" {
    type = string
}

variable "project_name" {
    type = string
}

variable "vpc_id" {
    type = string
}


variable "public_subnet_id" {
    description = "The ID of the public subnet to place the bastion in."
    type        = string
}

variable "key_name" {
    description = "The name of the SSH key to associate with the bastion."
    type        = string
}

# variable "my_ip" {
#     description = "My IP address for SSH access."
#     type        = string
# }

