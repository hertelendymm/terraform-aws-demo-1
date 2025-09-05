# A security group is like a virtual firewall for your instance.
# This one allows SSH traffic only from your specified IP address.
resource "aws_security_group" "bastion_sg" {
    name        = "${var.project_name}-bastion-sg"
    description = "Allow SSH inbound traffic from a specific IP"
    vpc_id      = var.vpc_id

    ingress {
        description = "SSH from anywhere (0.0.0.0/0)"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        # This now allows SSH access from ANY IP address.
        # WARNING: This is not recommended for production environments.
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}-bastion-sg"
    }
}

# ... rest of the file is the same ...
# This is the actual EC2 instance for the bastion host.
resource "aws_instance" "bastion_host" {
    ami           = "ami-046c2381f11878233"
    instance_type = "t2.micro" # t2.micro is free-tier eligible

    # We place it in the public subnet so it can have a public IP.
    subnet_id = var.public_subnet_id

    # This tells the instance to get a public IP address automatically.
    associate_public_ip_address = true

    # Attach the security group we just created.
    vpc_security_group_ids = [aws_security_group.bastion_sg.id]

    # Use the SSH key we uploaded from the root module.
    key_name = var.key_name


    tags = {
        Name = "${var.project_name}-bastion-host"
    }
}

