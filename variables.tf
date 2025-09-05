variable "aws_region" {
    type = string
}

variable "project_name" {
    type = string
}

# variable "aws_profile" {
#     type = string
# }

# variable "number_of_bastions" {
#     description = "The number of bastions to be created."
#     type = number
# }

variable "do_i_want_bastion" {
    type = bool
}

variable "my_public_key_path" {
    description = "Path to the public SSH key to be used for EC2 instances."
    type        = string
    default     = "./keys/max-bastion-key.pub"
}