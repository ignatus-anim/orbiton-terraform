variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "root_volume_size" {
  type    = number
  default = 20
  
}
