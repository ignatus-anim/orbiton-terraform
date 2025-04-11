# In your modules/vpc/outputs.tf
output "public_subnet_ids" {
  value = aws_subnet.public[*].id  # adjust this to your resource names
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id  # adjust this to your resource names
}

output "vpc_id" {
  value = aws_vpc.this.id  # Assuming 'aws_vpc.this' is the name of your VPC resource
}
