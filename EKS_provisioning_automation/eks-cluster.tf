

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.20.0"
  
  cluster_name = "myapp-eks-cluster"
  cluster_version = "1.17"

  subnets = module.myapp-vpc.private_subnets
  vpc_id = module.myapp-vpc.vpc_id
  tags = {
      enviroment = "development"
      application = "myapp"   
  }
  
  # worker nodes

  worker_groups = [
      {
          instance_type = "t2.small"
          name = "worker-group-1"
          asg_desired_capacity = 3
      }
  ]

}
