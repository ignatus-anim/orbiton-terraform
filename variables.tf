# General
variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

# VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
}

# EC2
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name to SSH into EC2 instances"
  type        = string
}

variable "ec2_ami_id" {
  description = "AMI ID to use for EC2 instances"
  type        = string
}

# Security Group
variable "allowed_ips" {
  description = "List of IPs allowed to access resources (e.g., SSH)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# EKS
variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "eks_node_instance_type" {
  description = "Instance type for EKS worker nodes"
  type        = string
  default     = "t3.small"
}

variable "eks_node_desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "eks_node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "eks_node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

# Tags
variable "common_tags" {
  description = "A map of common tags to apply to all resources"
  type        = map(string)
}
