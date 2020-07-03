terraform {
  backend "s3" {
    bucket         = "servicemesh-bucket-1"
    key            = "servicemesh-terraform-state"
    region         = "us-east-1"
    profile        = "dev"
  }
}

module "eks_cluster" {
    source = "./EKS_Cluster"

    cluster_name = "servicemesh_eks_cluster"
}