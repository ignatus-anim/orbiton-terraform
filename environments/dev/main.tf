module "vpc" {
  source = "../../modules/vpc"
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones

  tags = var.common_tags
}


module "ec2" {
  source = "../../modules/ec2"

  project_name       = var.project_name
  environment        = var.environment
  instance_type      = var.instance_type
  key_name           = var.key_name
  subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_id  = module.security_group.ec2-sg_id
  tags               = var.common_tags
}


module "security_group" {
  source = "../../modules/security_group"
  vpc_id             = module.vpc.vpc_id
  project_name       = var.project_name
  environment        = var.environment

}

module "eks" {
  source              = "../../modules/eks"
  cluster_name        = "${var.project_name}-${var.environment}-eks"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids  # Changed from public to private
  public_subnet_ids   = module.vpc.public_subnet_ids
  environment         = var.environment
  tags                = var.common_tags
  region              = var.region
  project_name        = var.project_name
  
  cluster_security_group_id = module.security_group.eks_cluster_sg_id
  node_security_group_id    = module.security_group.eks_nodes_sg_id
  node_group_instance_type = var.node_group_instance_type
  desired_capacity         = var.desired_capacity
  min_capacity            = var.min_capacity
  max_capacity            = var.max_capacity
  node_group_name         = var.node_group_name
}

module "kubernetes_deployment" {
  source = "../../modules/kubernetes"
  
  project_name    = var.project_name
  environment     = var.environment
  container_image = var.container_image
  container_port  = var.container_port
  replicas        = 2  # You can make this configurable via variables

  depends_on = [module.eks]
}
