variable "aws_region" {
    type = string
}

variable "project_name" {
    type = string
}

variable "do_i_want_bastion" {
    type = bool
}

variable "my_public_key_path" {
    description = "Path to the public SSH key to be used for EC2 instances."
    type        = string
    default     = "./keys/max-bastion-key.pub"
}

variable "webapp_instance_count" {
    description = "The number of web server instances to create."
    type        = number
}