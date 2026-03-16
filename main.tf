module "vpc" {
  source             = "./module/vpc"  
  vpc_cidr           = var.vpc_cidr           
  organization_prefix = var.organization_prefix 
  enable_dns_support  = var.enable_dns_support  
  enable_dns_hostnames = var.enable_dns_hostnames
  public_subnets      = var.public_subnets
  app_subnets         = var.app_subnets
  db_subnets          = var.db_subnets
  create_nat_gateway  = var.create_nat_gateway
}
