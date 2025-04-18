variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "node_group_instance_type" {
  type = string
}

variable "desired_capacity" {
  type = number
}

variable "max_capacity" {
  type = number
}

variable "min_capacity" {
  type = number
}

variable "tags" {
  type = map(string)
}

variable "node_group_name" {
  type = string
  
}

variable "cluster_security_group_id" {
  type        = string
  description = "Security group ID for the EKS cluster"
}

variable "node_security_group_id" {
  type        = string
  description = "Security group ID for the EKS nodes"
}
