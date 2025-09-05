resource "aws_key_pair" "max-bastion-key" {
    key_name   = "max-bastion-key"
    public_key = file(var.my_public_key_path)
}

module "vpc" {
    source = "./modules/vpc"
    aws_region= var.aws_region
    project_name = var.project_name
}

module "bastion" {
    source = "./modules/bastion_host"
    count = var.do_i_want_bastion ? 1 : 0
    # count = var.number_of_bastions

    # Here, we pass outputs from the VPC module as inputs to the bastion module.
    # This is how modules are linked together.
    project_name     = var.project_name
    vpc_id           = module.vpc.vpc_id
    public_subnet_id = module.vpc.public_subnet_id
    key_name         = aws_key_pair.max-bastion-key.key_name
    aws_region       = var.aws_region
}

# Call the webapp module to create the EC2 instances and Load Balancer.
module "webapp" {
    source = "./modules/webapp"

    # Pass in values from root variables and the outputs of other modules.
    project_name      = var.project_name
    vpc_id            = module.vpc.vpc_id
    vpc_cidr_block    = module.vpc.vpc_cidr_block      # From the VPC module's new output
    public_subnet_id  = module.vpc.public_subnet_id  # For the Load Balancer
    private_subnet_id = module.vpc.private_subnet_id # For the EC2 instances
    key_name          = aws_key_pair.max-bastion-key.key_name
    instance_count    = var.webapp_instance_count

    # Pass the bastion's security group ID to allow SSH access.
    # The [0] is necessary because the bastion is created with 'count', making it a list.
    bastion_sg_id = module.bastion_host[0].security_group_id
}



# module "bastion_host" {
#     source = "./modules/bastion_host"
#     count = var.do_i_want_bastion ? 1 : 0
#     subnet_id = module.vpc.public_subnet_id
# }

# resource "aws_instance" "ec2" {
#     # ... other configuration ...
#     ami      = "ami-0c55b159cbfafe1f0"
#     instance_type = "t2.micro"

#     key_name = aws_key_pair.main.key_name
# }
