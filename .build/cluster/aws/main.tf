provider "aws" {
    version = "~> 2.0"
    region  = var.region //"us-east-1"
    profile = "dev" //"dev" //comment this out if not required
}

terraform {
  backend "s3" {
    bucket         = "servicemesh-bucket-1"
    key            = "servicemesh-terraform-state"
    region         = "us-east-1"
    profile        = "dev"
  }
}

module "cluters_network" {
    source = "./cluster_network"

    cluster_names = ["servicemesh_eks_cluster", "servicemesh_eks_cluster_2"]
}

module "cluster_roles" {
    source = "./cluster_roles"
}

module "eks_cluster" {
    source = "./EKS_Cluster"

    cluster_name = "servicemesh_eks_cluster"
    subnet_ids      = [module.cluters_network.subnet_1_id, module.cluters_network.subnet_2_id]

    region = var.region
    availability_zone_1 = "us-east-1a"
    availability_zone_2 = "us-east-1b"

    cluster_role_arn = module.cluster_roles.cluster_role_arn
    cluster_node_role_arn = module.cluster_roles.cluster_node_role_arn
}

# module "eks_cluster_2" {
#     source = "./EKS_Cluster"

#     cluster_name = "servicemesh_eks_cluster_2"
#     subnet_ids      = [module.cluters_network.subnet_1_id, module.cluters_network.subnet_2_id]

#     region = var.region
#     availability_zone_1 = "us-east-1a"
#     availability_zone_2 = "us-east-1b"

#     cluster_role_arn = module.cluster_roles.cluster_role_arn
#     cluster_node_role_arn = module.cluster_roles.cluster_node_role_arn
# }

output "endpoint_cluster_1" {
  value = module.eks_cluster.endpoint
}

# output "endpoint_cluster_2" {
#   value = module.eks_cluster_2.endpoint
# }

output "kubeconfig_certificate_authority_data_cluster_1" {
  value = module.eks_cluster.kubeconfig_certificate_authority_data
}

# output "kubeconfig_certificate_authority_data_cluster_2" {
#   value = module.eks_cluster_2.kubeconfig_certificate_authority_data
# }