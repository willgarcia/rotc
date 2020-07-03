resource "aws_eks_cluster" "servicemesh_eks_cluster" {
  name     = "${var.cluster_name}"
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
    endpoint_private_access = "true"
  }

  tags = {
    Name = "servicemesh_eks_cluster"
  }
}