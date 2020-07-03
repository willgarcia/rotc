output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "cluster_node_role_arn" {
  value = aws_iam_role.eks_nodes_role.arn
}