variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "common_tags" {
  type = map(string)
}


variable "key_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}



variable "cluster_name" {
  type = string
}

variable "node_group_instance_type" {
  type    = string
  default = "t3.small"
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "max_capacity" {
  type    = number
  default = 3
}

variable "min_capacity" {
  type    = number
  default = 1
}

variable "node_group_name" {
  type = string
  
}

variable "container_image" {
  type        = string
  description = "Docker image for the application"
}

variable "container_port" {
  type        = number
  description = "Container port for the application"
  default     = 3000
}
