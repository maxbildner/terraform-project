## Terraform, Summary Notes
https://www.youtube.com/watch?v=l5k1ai_GBDE

- What is Terraform?
  - allows you to automate and manage your cloud infrastructure (ex. AWS) and services that run on the infrastructure (Ex. Create, and configure Lambda, AWS S3, …)
    - <ins>**Declarative**</ins> language = define what end result you want, and terraform will execute
    - <ins>**Imperative**</ins> language = how to get what you want
  - Can deploy applications

- <ins>**Providers**</ins> Ex. AWS, Microsoft Azure, Kubernetes, …

- <ins>**Resources**</ins> Ex. AWS DynamoDB table, AWS Lambda Function, EC2 Server Instance, S3 Bucket, ...

- Terraform <ins>**Core**</ins>
  - Where you define what resources need to be created and the state of the application
  - **Core 2 Inputs**
    - <ins>**Configuration file ( .tf )**</ins>
      - User writes this
      - Define what needs to be created (ex. AWS Lambda function)
      - 1. Define provider (ex AWS)
      - 2. define resource you want (ex. EC2 instance)
    - <ins>**State**</ins>
      - Current state of setup of infrastructure (ex. There’s only 1 server)
  - Core will then use providers to get from the current state to the desired state/configuration

- Terraform Basic Commands
  - <ins>**refresh**</ins>
    - Query infrastructure provider to get current state of application
  - <ins>**plan**</ins>
    - Create an execution plan to get to the desired state (like a preview of what’s going to happen)
  - <ins>**apply**</ins>
    - Execute the plan
  - <ins>**destroy**</ins>
    - Deletes the resources/infrastructure


## Steps to create a basic terraform project (ex. setting up an AWS EC2 instance)
1) **secure aws access key ID and secret key**
    - create a .tfvars file and add the access and secret key values
    - make sure to add this file to git ignore!!!! extremely important you don't want it publicly exposed
    - create a variables.tf file and declare the acess and secret keys
2) **define a PROVIDER:**
    - <ins>**provider**</ins> = plugin that allows us to talk to a specific set of APIs (ex. AWS, Azure, Github, ...)
    ```
    provider "aws" {
      # version = "-> 3.27"   # optional
      region = "us-east-1"
      access_key = "${var.aws_access_key}"
      secret_key = "${var.aws_secret_key}"
    }
    ```
3) **Create a RESOURCE (ex. aws EC2 server, S3 bucket, ...)**
    - Syntax: 
        resource `"<provider name>_<resource type>" "<name>" { <config options> }`
    - `<name>` = name that we can reference within terraform. AWS will not be aware of this name
    - see docs for more information: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
    - Ex. create EC2 Instance called "potato"
    ```
    resource "aws_instance" "potato" {
      # in this example we need to select an AMI (Amazon Machine Image)
      # AMI = template needed to launch an EC2 instance. (like a blueprint that defines operating system, software, ...)
      ami = "ami-0e472ba40eb589f49" # ubuntu OS
      instance_type = "t2.micro" # free server

      # optional
      - info about resource (ex. name) so you can find it easier on the aws console
      tags = {
        Name = "ubuntu" # this will show up in the aws console! (unlike <name> above #2)
      }
    }
    ```
4) <ins>terraform command **INIT**:</ins>
    - will look at all .tf files, and will look at all the providers and download the necessary plugs to interact with providers
    ```
      terraform init
    ```
5) <ins>terraform command **PLAN**:</ins>
    - Create an execution plan to get to the desired state (like a preview of what’s going to happen)
    - Optional. If this command not run, when you run apply terraform will automatically create a plan and ask you to approve it
    - looking at the plan, notice each line if there's plus + or minus -:
      + = creating a resource
      - = deleting a resource
      ~ = updating an existing resource
    ```
      terraform plan
    ```
5) <ins>terraform command **APPLY**:</ins>
    - executes plan
    - re-running apply will NOT change anything because the current state and the desired state are the same!
    ```
      terraform apply
    ```
6) <ins>terraform command **DESTROY**:</ins>
    - by default, deletes all the resources/infrastructure in the current working directory/workspace
    - Dangerous/not needed. Just delete the resource in the .tf file and run terraform apply
    ```
      terraform destroy
    ```
7) <ins>CLOUD</ins>
    - storing and accessing data over the internet instead of from a server at home/office
    - cloud computing is the delivery of different services through the Internet, 
      including data storage, servers, databases, networking, and software.
8) <ins>PUBLIC vs PRIVATE CLOUDS</ins>
    - PRIVATE = ex. reserved table at a restaurant 
    - PUBLIC = ex. whole resatuarant 
9) <ins>VPC (VIRTUAL PRIVATE CLOUD)</ins>
    - private cloud within a public cloud
    - EC2 = server/computer(s)
    - VPC = wires connecting servers, that impact how EC2/other services are connected/communicating
    - like a mini private data center
    - VPC is tha parent and can contain many EC2 instances
    ```
      resource "aws_vpc" "first-vpc" {
        cidr_block = "10.0.0.0/16"
        # 11) CIDR BLOCK 
        # = cidr_block = IPv4 CIDR block
        # - (Classless Inter-Domain Routing). Set of IP rules for allocating IP addresses and routing

        tags = {
          Name = "production"
        }
      }
    ```
10) <ins>VPC SUBNET</ins>
    - key component of a VPC
    - a range of IP addresses in the VPC
    ```
    resource "aws_subnet" "subnet-1" {
      # vpc_id = "${aws_vpc.first-vpc.id}"  # syntax lets us reference resources/properties
      vpc_id = aws_vpc.first-vpc.id  # same as above?
      cidr_block = "10.0.1.0/24"

      tags = {
        Name = "prod-subnet"
      }
    }
    ```


## NEW NOTES
- 9/7/22
  - TERRAFORM dynamodb table item <ins>**attribute**</ins>
    - <ins>**Attribute**</ins> = key in dynamo table item
    - When creating a dynamo table in terraform, you don’t define all the item attributes
    - **You only define terraform attributes that are**:
        - **Hash Key or Range Key or**
        - **LSI or GSI (Global Secondary Index)**
    - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
- Ex. 
  ```
  resource "aws_dynamodb_table" “users” {
    name         = "user_projects"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = “user_name”

    attribute {
      name = “user_name”
      type = "S"
    }

    attribute {
      name = “id”
      type = “S”
    }

    attribute {
      name = “email”
      type = "S"
    }

    global_secondary_index {
      name            = "id_index"
      hash_key        = "id"
      projection_type = "ALL"
    }

    global_secondary_index {
      name            = “email_index"
      hash_key        = “email”
      projection_type = "ALL"
    }
  }
  ```

- 5/18/22
  - <ins>**a change on the package does NOT automatically trigger redeployment on all that depend on it!!!!**</ins>
  - I should redeploy an AWS Lambda Function (if I modified a package that, that Lambda function uses). Redployment can be triggered by updating the package.json version (ex. from 1.0.1 -> 1.0.2)
    - See March 20-21 bug in bug log for more information


## QUESTIONS
  - regarding running these commands (ex. terraform apply)- running it in a nested folder will not 
    run other .tf files in sibling folders?
  - since terraform is declarative, order of defining resource doesn't matter right?
    YES order doesn't matter!
  - pros/cons ubuntu server?
  - what's going on under the hood when we declare {var.aws_secret_access_key}? in 2  provider above
  - .terraform folder?
    - created when we ran "terraform init"
    - has the dependencies/plugs from aws provider api
  - what's this terraform.lock.hcl file? and terraform.tfstate?
    - .tfstate = current state of infrastructure. Don't modify that file!!!
    - .lock.hcl = ?
  - still don't understand what a CIDR block is
  - VPC Subnet?