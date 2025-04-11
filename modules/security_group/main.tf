# # EC2 Security Group
# resource "aws_security_group" "this" {
#   name   = "${var.project_name}-${var.environment}-sg"
#   vpc_id = var.vpc_id

#   ingress = [
#     {
#       from_port        = 22
#       to_port          = 22
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       description      = "SSH"
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       security_groups  = []
#       self            = false
#     },
#     {
#       from_port        = 443
#       to_port          = 443
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       description      = "HTTPS"
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       security_groups  = []
#       self            = false
#     },
#     {
#       from_port        = 4000
#       to_port          = 4000
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       description      = "Node.js App"
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       security_groups  = []
#       self            = false
#     }
#   ]
#   egress = [{
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     description      = "All"
#     ipv6_cidr_blocks = []
#     prefix_list_ids  = []
#     security_groups  = []
#     self            = false
#   }]
# }

# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name        = "${var.project_name}-${var.environment}-eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id
  
  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-eks-cluster-sg"
  }
}

# EKS Node Security Group
resource "aws_security_group" "eks_nodes" {
  name        = "${var.project_name}-${var.environment}-eks-nodes-sg"
  description = "Security group for EKS nodes"
  vpc_id      = var.vpc_id
  
  ingress{
    description = "Allow worker nodes to communicate with each other"
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [aws_security_group.eks_cluster.id]
    self = true
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-eks-nodes-sg"
  }
}

