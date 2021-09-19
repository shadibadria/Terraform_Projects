#cidr_block=["10.0.0.0/16","10.0.50.0/24"] # list

#vpc_cidr_block = "10.0.0.0/16" # normal var

cidr_block = [ 
    {cidr_block = "10.0.0.0/16", name="dev-vpc"},
    {cidr_block = "10.0.10.0/24", name="dev-subnet"},


 ]