provider "aws" {
    region = "eu-west-3" 
}

# Variables

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {}
variable "public_key_location" {}

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

# Security group

resource "aws_security_group" "myapp-sg" {
    name = "myapp-sg"
    vpc_id = aws_vpc.myapp-vpc.id
    #traffic ingoing (SSH)
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        #cidr_blocks = [ "${var.my_ip}" ]
        cidr_blocks = [ "0.0.0.0/0" ]


    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    #outgoing traffic 
    egress {
        from_port = 0 
        to_port = 0
        protocol = "-1" # any protocol
        cidr_blocks = []
    }
    tags = {
        Name = "${var.env_prefix}-sg"
    }
}

# EC2 

# image
data "aws_ami" "latest-amazon-Linux-image" {
    most_recent = true
    owners = [ "amazon" ] 
    filter {
      name = "name"  
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}


# key pair automation

resource "aws_key_pair" "ssh-key" {
    key_name = "server-key"
    public_key = "${file(var.public_key_location)}"
  
}
# ec2 config
resource "aws_instance" "myapp-server" {
    ami = data.aws_ami.latest-amazon-Linux-image.id
    instance_type = var.instance_type

    subnet_id = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true 
    key_name = aws_key_pair.ssh-key.key_name
   

    tags = {
        Name ="${var.env_prefix}-server"
    }

}

# Outputs 

output "aws_ami_id" {
    value = data.aws_ami.latest-amazon-Linux-image.id
  
}
output "ec2_public_ip" {
    value = aws_instance.myapp-server.public_ip
  
}