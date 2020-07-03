resource "aws_eks_cluster" "servicemesh_eks_cluster" {
  name     = "${var.cluster_name}"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = ["${aws_subnet.servicemesh_subnet_1.id}", "${aws_subnet.servicemesh_subnet_2.id}"]
    endpoint_private_access = "true"
  }

  tags = {
    Name = "servicemesh_eks_cluster"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    "aws_iam_role_policy_attachment.AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.AmazonEKSServicePolicy",
  ]
}