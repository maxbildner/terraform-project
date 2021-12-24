# Below are the basic steps to create a terraform project (ex. setting up an AWS EC2 instance)

# 1) secure aws access key ID and secret key
#    - create a .tfvars file and add the access and secret key values
#    - make sure to add this file to git ignore!!!! extremely important you don't want it publicly exposed
#    - create a variables.tf file and declare the acess and secret keys


# 2) define a PROVIDER:
# - provider = plugin that allows us to talk to a specific set of APIs (ex. AWS, Azure, Github, ...)
provider "aws" {
  # version = "-> 3.27"   # optional
  region = "us-east-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}


# 2) Create a RESOURCE (ex. aws EC2 server, S3 bucket, ...)
# - Syntax: 
#   resource "<provider name>_<resource type>" "<name>" { <config options> }
# - <name> = name that we can reference within terraform. AWS will not be aware of this name
# - see docs for more information: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# resource "aws_instance" "potato" {

#   # 3) in this example we need to select an AMI (Amazon Machine Image)
#   # AMI = template needed to launch an EC2 instance. (like a blueprint that defines operating system, software, ...)
#   ami = "ami-0e472ba40eb589f49" # ubuntu OS
#   instance_type = "t2.micro" # free server

#   # 4) TAGS (optional)
#   # - info about resource (ex. name) so you can find it easier on the aws console
#   tags = {
#     Name = "ubuntu" # this will show up in the aws console! (unlike <name> above #2)
#   }
# }


# 5) terraform command INIT:
#   terraform init
#   - will look at all .tf files, and will look at all the providers and download the necessary plugs to interact with providers


# 6) terraform command PLAN:
#   terraform plan
#   - Create an execution plan to get to the desired state (like a preview of what’s going to happen)
#   - Optional. If this command not run, when you run apply terraform will automatically create a plan and ask you to approve it
#   - looking at the plan, notice each line if there's plus + or minus -:
#     + = creating a resource
#     - = deleting a resource
#     ~ = updating an existing resource


# 7) terraform command APPLY:
#   terraform apply
#   - executes plan
#   - re-running apply will NOT change anything because the current state and the desired state are the same!


# MISC NOTES
# 8) terraform command DESTROY:
#   terraform destroy
# - by default, deletes all the resources/infrastructure in the current working directory/workspace
# - Dangerous/not needed. Just delete the resource in the .tf file and run terraform apply

# 9) CLOUD
# - storing and accessing data over the internet instead of from a server at home/office
# - cloud computing is the delivery of different services through the Internet, 
#   including data storage, servers, databases, networking, and software.

# 10) PUBLIC vs PRIVATE CLOUDS
# PUBLIC = ex. whole resatuarant 
# PRIVATE = ex. reserved table at a restaurant 

# 10) VPC (VIRTUAL PRIVATE CLOUD)
# - private cloud within a public cloud
# - EC2 = server/computer(s)
# - VPC = wires connecting servers, that impact how EC2/other services are connected/communicating
# - like a mini private data center
# - VPC is tha parent and can contain many EC2 instances
resource "aws_vpc" "first-vpc" {
  cidr_block = "10.0.0.0/16"
  # 11) CIDR BLOCK 
  # = cidr_block = IPv4 CIDR block
  # - (Classless Inter-Domain Routing). Set of IP rules for allocating IP addresses and routing

  tags = {
    Name = "production"
  }
}

# 12) VPC SUBNET
# - key component of a VPC
# - a range of IP addresses in the VPC
resource "aws_subnet" "subnet-1" {
  # vpc_id = "${aws_vpc.first-vpc.id}"  # syntax lets us reference resources/properties
  vpc_id = aws_vpc.first-vpc.id  # same as above?
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-subnet"
  }
}


# QUESTIONS
# - regarding running these commands (ex. terraform apply)- running it in a nested folder will not 
#   run other .tf files in sibling folders?
# - since terraform is declarative, order of defining resource doesn't matter right?
#   YES order doesn't matter!
# - pros/cons ubuntu server?
# - what's going on under the hood when we declare {var.aws_secret_access_key}? in #2 provider above
# - .terraform folder?
#   - created when we ran "terraform init"
#   - has the dependencies/plugs from aws provider api
# - what's this terraform.lock.hcl file? and terraform.tfstate?
#   - .tfstate = current state of infrastructure. Don't modify that file!!!
#   - .lock.hcl = ?
# - still don't understand what a CIDR block is
# - VPC Subnet?


# SAMPLE PROJECT
# 1. Create VPC
# 2. Create Internet Gateway
#   - this is wo we can assign a public IP address, so anyone can reach it
# 3. Create Custom Route Table (optional)
# 4. Create a Subnet
# 5. Associate subnet with Route Table
# 6. Create Security Group to allow port 22, 80, 443
#   - determines what kind of traffic is allowed to get to you EC2 instances
#   - port 22 so we can ssh to it
# 7. Create a network interface with an IP in the subnet that was created in step 4
# 8. Assign an elastic IP to the network interface created in step 7
# 9. Create Ubuntu server and install/enable Apache2 
