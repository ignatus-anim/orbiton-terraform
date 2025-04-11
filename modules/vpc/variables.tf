variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet CIDRs"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet CIDRs"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones for subnets"
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
}
