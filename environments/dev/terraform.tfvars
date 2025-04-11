vpc_cidr          = "10.0.0.0/16"
public_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets   = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones = ["eu-west-1a", "eu-west-1b"]

project_name = "orbiton"
environment  = "dev"
region       = "eu-west-1"


common_tags = {
  owner      = "igna"
  managed_by = "terraform"
}

instance_type = "t3.micro"
key_name      = "orbiton-keypair"
cluster_name  = "orbiton-cluster"

# Added EKS specific values
node_group_instance_type = "t3.small"
desired_capacity        = 2
max_capacity           = 3
min_capacity           = 1
