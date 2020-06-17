resource "aws_eks_node_group" "servicemesh_eks_node_group" {
  cluster_name    = "${aws_eks_cluster.servicemesh_eks_cluster.name}"
  node_group_name = "servicemesh_eks_node_group"
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = ["${aws_subnet.servicemesh_subnet_1.id}", "${aws_subnet.servicemesh_subnet_2.id}"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}