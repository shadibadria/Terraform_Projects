provider "aws" {
    region = "eu-west-3"
    access_key = "AKIAZKYE56IDYXDJEQHV"
    secret_key = "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"
}

# Variables

variable "cidr_block" {
  description = " cidr blocks for vpc and subnet" 
  #default = "10.0.10.0/24" # if terraform can find value for the variable
  type = list(object({
      cidr_block = string
      name = string
  })) # variable type force use to use the correct type
}
# VPC
resource "aws_vpc" "development-vpc" {
    cidr_block = var.cidr_block[0].cidr_block
    tags= {
        Name: var.cidr_block[0].name
    }
}
# Subnet
resource "aws_subnet" "dev-subnet1" {
    vpc_id = aws_vpc.development-vpc.id
    #cidr_block = "10.0.0.0/16"
    cidr_block = var.cidr_block[1].cidr_block
    availability_zone = "eu-west-3a"
    tags = {
        Name: var.cidr_block[1].name
    }
}

# Output the id of the vpc and subnet
output "dev-vpc-id" {
    value = aws_vpc.development-vpc.id
}
output "dev-subnet-id" {
    value = aws_subnet.dev-subnet1.id
}