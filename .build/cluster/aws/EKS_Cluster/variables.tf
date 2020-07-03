variable "region" {
  type = string
}

variable "availability_zone_1" {
  type = string
}

variable "availability_zone_2" {
  type = string
}

variable "profile" {
  type = string
  default = "dev"
}

variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}


variable "cluster_role_arn" {
  type = string
}

variable "cluster_node_role_arn" {
  type = string
}

