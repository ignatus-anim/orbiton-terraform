output "ec2-sg_id" {
  value = aws_security_group.this.id
  description = "The ID of the security group for EKS nodes"
}
