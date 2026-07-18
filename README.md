# Terraform + LocalStack Practice Project

A beginner-friendly guide to understand **Terraform** and **LocalStack** from zero.

The goal of this project is to learn how Terraform works without using a real AWS account.

---

# What is Terraform?

Terraform is an **Infrastructure as Code (IaC)** tool.

Instead of creating cloud resources manually from a website, you write code that describes what you want.

Example:

```hcl
resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}
```

Terraform reads this code and creates the infrastructure for you.

---

# Terraform Workflow

## 1. terraform init

```bash
terraform init
```

Initializes the Terraform project and downloads the required providers.

Workflow:

```
terraform init
        |
        ↓
Download providers
        |
        ↓
Prepare Terraform
```

---

## 2. terraform fmt

```bash
terraform fmt
```

Formats Terraform files automatically.

It:
- Fixes spacing
- Aligns code
- Improves readability

It does not create or modify infrastructure.

---

## 3. terraform plan

```bash
terraform plan
```

Shows what Terraform will do before applying changes.

Example:

```
+ Create EC2 instance
~ Update resource
- Delete resource
```

Important:

`terraform plan` only shows changes. It does not create anything.

---

## 4. terraform apply

```bash
terraform apply
```

Creates or updates the infrastructure.

Complete workflow:

```
terraform init
        ↓
terraform fmt
        ↓
terraform plan
        ↓
terraform apply
```

---

# What is LocalStack?

LocalStack is a tool that simulates AWS services locally.

Instead of creating resources on real AWS, LocalStack creates fake AWS resources on your computer.

Example:

```
Terraform
    |
    ↓
AWS Provider
    |
    ↓
LocalStack
    |
    ↓
Fake AWS Resources
```

It is useful for:
- Learning AWS
- Testing Terraform
- Practicing without paying for AWS

---

# Running LocalStack

Start LocalStack:

```bash
localstack start -d
```

Check if it is running:

```bash
curl http://localhost:4566/_localstack/health
```

---

# Terraform Provider

The provider tells Terraform which platform it should communicate with.

Example:

```hcl
provider "aws" {
  region = "us-east-1"

  access_key = "test"
  secret_key = "test"

  endpoints {
    ec2 = "http://localhost:4566"
  }
}
```

Here Terraform uses the AWS provider but connects to LocalStack instead of AWS.

---

# What is an AMI?

AMI means **Amazon Machine Image**.

Think of it as a template of a computer.

It contains:
- Operating system
- Basic configuration
- Software

Example:

```hcl
resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}
```

When creating an EC2 instance:

- AMI → Operating system
- Instance type → CPU/RAM size

---

# AMI with LocalStack

In real AWS, an AMI points to a real operating system image.

LocalStack does not create real virtual machines, so the AMI is only a placeholder.

Example:

```hcl
ami = "ami-12345678"
```

LocalStack accepts it for testing.

---

# What is EC2?

EC2 (Elastic Compute Cloud) is a virtual machine/server in AWS.

Example:

```hcl
resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}
```

This creates a virtual server.

---

# What is S3?

S3 means **Simple Storage Service**.

It is used to store files.

Examples:
- Images
- Backups
- Videos
- Documents

Think of it as Google Drive for applications.

Structure:

```
S3
 |
 └── Bucket
       |
       ├── image.png
       ├── backup.zip
       └── file.txt
```

---

# What is a VPC?

VPC (Virtual Private Cloud) is your own private network in the cloud.

Think of it as a home network for cloud servers.

Example:

```
AWS Cloud
   |
   └── VPC
          |
          ├── EC2 Server
          └── Database
```

Terraform example:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

---

# What is a Subnet?

A subnet is a smaller network inside a VPC.

Example:

```
VPC
 |
 └── Subnet
       |
       └── EC2 Instance
```

Example:

```hcl
resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.1.0/24"
}
```

---

# What is an Elastic IP?

Elastic IP (EIP) is a fixed public IP address.

Normally:

```
EC2 restart
     |
     ↓
New public IP
```

With Elastic IP:

```
EC2 restart
     |
     ↓
Same public IP
```

---

# Terraform State

`terraform.tfstate` is Terraform's memory.

It stores information about resources Terraform manages.

It contains:

- Resource IDs
- Resource names
- Configuration
- Current state

Example:

```
terraform.tfstate

aws_instance.example
aws_vpc.main
aws_subnet.main
```

View it:

```bash
cat terraform.tfstate
```

Or:

```bash
terraform state list
```

---

# Terraform Variables

Variables allow you to avoid hardcoding values.

Example:

variables.tf:

```hcl
variable "instance_type" {
  default = "t2.micro"
}
```

Use it:

```hcl
resource "aws_instance" "example" {
  instance_type = var.instance_type
}
```

Now you can change values easily.

---

# Terraform Outputs

Outputs display useful information after deployment.

Example:

```hcl
output "instance_id" {
  value = aws_instance.example.id
}
```

After:

```bash
terraform apply
```

Terraform shows:

```
instance_id = i-123456
```

---

# Project Structure

```
terraform-localstack-project

├── main.tf
├── variables.tf
├── outputs.tf
├── README.md
└── .gitignore
```

---

# Push Project to GitHub

## 1. Initialize Git

```bash
git init
```

---

## 2. Add files

```bash
git add .
```

---

## 3. Commit

```bash
git commit -m "Add Terraform LocalStack beginner project"
```

---

## 4. Create repository on GitHub

Create an empty repository.

Example:

```
terraform-localstack-project
```

---

## 5. Connect GitHub repository

```bash
git remote add origin https://github.com/YOUR_USERNAME/terraform-localstack-project.git
```

---

## 6. Push

```bash
git branch -M main
git push -u origin main
```

---

# Final Result

You learned:

✅ Terraform basics  
✅ LocalStack  
✅ AWS Provider  
✅ EC2  
✅ S3  
✅ VPC  
✅ Subnets  
✅ Elastic IP  
✅ Terraform State  
✅ Variables  
✅ Outputs  
✅ GitHub workflow  

