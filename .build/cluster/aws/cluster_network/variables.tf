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

variable "cluster_names" {
  type = list(string)
  default = ["servicemesh_eks_cluster"]
}