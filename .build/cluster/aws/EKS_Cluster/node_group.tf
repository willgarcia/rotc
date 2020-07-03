resource "aws_eks_node_group" "servicemesh_eks_node_group" {
  cluster_name    = "${aws_eks_cluster.servicemesh_eks_cluster.name}"
  node_group_name = "${aws_eks_cluster.servicemesh_eks_cluster.name}_group"
  node_role_arn   = var.cluster_node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
}