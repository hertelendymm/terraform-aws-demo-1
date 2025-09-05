# This data source finds the latest Ubuntu 22.04 LTS AMI in the current region.
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical's AWS account ID
}

# Security group for the web servers.
resource "aws_security_group" "webapp_sg" {
    name        = "${var.project_name}-webapp-sg"
    description = "Allow HTTP and SSH traffic"
    vpc_id      = var.vpc_id

    # Ingress rule for HTTP traffic (port 8080) from within the VPC.
    ingress {
        description = "HTTP from within VPC"
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        # cidr_blocks = [var.vpc_cidr_block]
    }

    # Ingress rule for SSH, but only from the bastion host's security group.
    dynamic "ingress" {
    # If bastion_sg_id is null, for_each is an empty list, and nothing is created.
    # If it has a value, for_each is a list with one element, creating one rule.
    for_each = var.bastion_sg_id == null ? [] : [var.bastion_sg_id]
        content {
            description     = "SSH from Bastion SG"
            from_port       = 22
            to_port         = 22
            protocol        = "tcp"
            security_groups = [ingress.value] # Use the value from the for_each
        }   
    }
    # ingress {
    #     description     = "SSH from Bastion SG"
    #     from_port       = 22
    #     to_port         = 22
    #     protocol        = "tcp"
    #     security_groups = [var.bastion_sg_id]
    # }

    # Allow all outbound traffic.
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}-webapp-sg"
    }
}

# Create multiple EC2 instances based on the instance_count variable.
resource "aws_instance" "webapp" {
    count = var.instance_count

    ami           = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    subnet_id     = var.private_subnet_id

    vpc_security_group_ids = [aws_security_group.webapp_sg.id]
    key_name               = var.key_name

    user_data = <<-EOF
                #!/bin/bash
                apt-get update -y
                apt-get install -y python3-pip
                echo "<h1>Hello from Web Server $(hostname -I | cut -d' ' -f1) on Port 8080</h1>" > /home/ubuntu/index.html && \
                cd /home/ubuntu
                nohup python3 -m http.server 8080 &
                EOF

    tags = {
        Name = "${var.project_name}-webapp-${count.index + 1}"
    }
}

# --- Load Balancer Resources ---

# Create the Network Load Balancer in the public subnet.
resource "aws_lb" "webapp_nlb" {
    name               = "${var.project_name}-webapp-nlb"
    internal           = false
    load_balancer_type = "network"

    # Corrected from subnet_mappings to subnets
    # This expects a list of one or more subnet IDs.
    subnets = [var.public_subnet_id]
    enable_cross_zone_load_balancing = true
}

# A Target Group is a logical grouping of your EC2 instances.
resource "aws_lb_target_group" "webapp_tg" {
    name     = "${var.project_name}-webapp-tg"
    port     = 8080 # The port the instances are listening on.
    protocol = "TCP"
    vpc_id   = var.vpc_id
}

# This resource attaches each of our EC2 instances to the Target Group.
resource "aws_lb_target_group_attachment" "webapp_attachment" {
    count = var.instance_count

    target_group_arn = aws_lb_target_group.webapp_tg.arn
    target_id        = aws_instance.webapp[count.index].id
    port             = 8080
}

# The Listener checks for incoming connections on port 80 and forwards them to the Target Group.
resource "aws_lb_listener" "webapp_listener" {
    load_balancer_arn = aws_lb.webapp_nlb.arn
    port              = 80 # The public-facing port.
    protocol          = "TCP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.webapp_tg.arn
    }
}