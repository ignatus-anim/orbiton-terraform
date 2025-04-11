# output "ec2-sg_id" {
#   value       = aws_security_group.this.id
#   description = "The ID of the security group for EC2"
# }

output "eks_cluster_sg_id" {
  value       = aws_security_group.eks_cluster.id
  description = "The ID of the security group for EKS cluster"
}

output "eks_nodes_sg_id" {
  value       = aws_security_group.eks_nodes.id
  description = "The ID of the security group for EKS nodes"
}
