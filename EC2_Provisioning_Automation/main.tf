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

# Gateway
resource "aws_internet_gateway" "myapp-i-gateway" {
    vpc_id = aws_vpc.myapp-vpc.id
  
}


#default route table

resource "aws_default_route_table" "main-rtb" {
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

    route {
        cidr_block= "0.0.0.0/0"
        gateway_id= aws_internet_gateway.myapp-i-gateway.id
    }
    
    tags = {
      "Name" = "${var.env_prefix}main-rtb"
    }
}
