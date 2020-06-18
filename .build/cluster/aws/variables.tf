variable "region" {
  type = string
  default = "us-east-1"
}

variable "availability_zone_1" {
  type = string
  default = "us-east-1a"
}

variable "availability_zone_2" {
  type = string
  default = "us-east-1b"
}

variable "profile" {
  type = string
  default = "dev"
}

variable "cluster_name" {
  type = string
  default = "servicemesh_eks_cluster"
}