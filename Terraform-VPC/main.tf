module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  subnets = [ "10.0.1.0/24", "10.0.2.0/24" ]
  name = "proj2"
}
module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}
module "ec2" {
  source = "./modules/ec2"
  sg-id = module.sg.sg-id
  subnet_ids = module.vpc.subnet_ids
}
module "alb" {
  source = "./modules/alb"
  alb_sg = module.sg.alb_sg
  subnets = module.vpc.subnet_ids
  vpc_id = module.vpc.vpc_id
  ec2 = module.ec2.ec2-id
}