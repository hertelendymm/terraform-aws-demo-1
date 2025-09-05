
- **Set up the networking part of the Infrastructure.** (You are allowed to copy it from your existing code if you feel like you already mastered did this a thousand times.)
- **Try to think about terraform modules today. Make a VPC module.** (The VPC module contains every networking related resource.)
- **Automate the import of your SSH keys to AWS, you can start with one SSH key for now but later we will change this.** (You can pre-create an SSH key that you are going to use or you can automate this as well with Terraform, it's up to you.)
- **Make a bastion host module with terraform. The module creates an EC2 and related resouces and will use a public key you have already uploaded.** (Think about what kind of resources did we need for a bastion host and EC2 instances in general.)
- **Provide a boolean variable to your root terraform code and this should control if you should have a bastion host or don't. In the future you just have to change this value if you want to create a bastion host or delete it.** 
- **Make a webapp_1 module and the module receives a number a variable and it creates that many EC2 instances and returns their IP addresses as an output.** (These EC2 instances must allow traffic on port 22 and 8080 for SSH and HTTP traffic. Also provide an SSH key for these instances as a variable.)
- **Make an AWS Loadbalancer on the public subnet that will loadbalance toward your webservers in the private subnet.** (Check the documentation about Loadbalancers terraform values. There are multiple types of loadbalancers, for this reason use a NetworkLoadbalancer.)


- [**Optional**] **Make an EC2 instance in the public subnet and install and start an `Nginx` server on it that will loadbalance to your webservers.** You may have to do some research on how to write all of these configurations in an `nginx.conf` file so this task is optional.

- [**Optional**] **Make an S3 bucket and make IAM policies that enable access to specific folders within the bucket all from terraform.** This task doesn't have any practicel purpose as is, but the policies could be used together in other IAM services together later to allow access to this bucket. Considering that this is our first week using `terraform` it's still a good task.

- [**Optional**] **Make an S3 bucket and use it together with CloudFront to make a static website.** In order to complete this task, you may have to research a bit about how `CloudFront` works, but a task like this was actually given to a former student (now collage) as a homework from a company.