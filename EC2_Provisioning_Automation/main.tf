provider "aws" {
    region = "eu-west-3" 
}

# Variables

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}

variable "env_prefix" {}

# VPC
resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags= {
        Name: "${var.env_prefix}-vpc"
    }
}
# Subnet
resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}

#route table
resource "aws_route_table" "myapp-route-tabl" {
   vpc_id = aws_vpc.myapp-vpc.id
    #gateway
    route {
        cidr_block= "0.0.0.0/0"
        gateway_id= aws_internet_gateway.myapp-i-gateway.id
    }
    tags = {
      "Name" = "${var.env_prefix}-rtb"
    }
   
}
# Gateway
resource "aws_internet_gateway" "myapp-i-gateway" {
    vpc_id = aws_vpc.myapp-vpc.id
  
}