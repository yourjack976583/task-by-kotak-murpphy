module "vpc" {
  source         = "./vpc"
  name           = "jxkute"
  vpc_cidr       = "192.168.0.0/16"
  public_subnet  = ["192.168.1.0/24", "192.168.2.0/24"]
  private_subnet = ["192.168.3.0/24", "192.168.4.0/24"]
}

module "eks" {
  source        = "./eks"
  cluster_name  = "ot-microservice-cluster"
  subnet_ids    = module.vpc.private_subnet_id
  instance_type = "t3.medium"
  desired_size  = 1
  max_size      = 5
  min_size      = 1
  node_group_subnet_id = module.vpc.private_subnet_id
}
