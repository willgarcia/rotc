variable "cluster_name" {
  type = string
  default = "servicemesh_eks_cluster"
}

variable "availability_zone_1" {
  type = string
  default = "us-east-1a"
}

variable "availability_zone_2" {
  type = string
  default = "us-east-1b"
}

resource "aws_s3_bucket" "servicemesh_bucket" {
  bucket = "servicemesh-bucket-1"
  acl    = "private"
}

resource "aws_vpc" "servicemesh_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "servicemesh_vpc"
  }
}

resource "aws_subnet" "servicemesh_subnet_1" {
  vpc_id     = "${aws_vpc.servicemesh_vpc.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "${var.availability_zone_1}"

  tags = {
    Name = "servicemesh_subnet_1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "servicemesh_subnet_2" {
  vpc_id     = "${aws_vpc.servicemesh_vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.availability_zone_2}"

  tags = {
    Name = "servicemesh_subnet_2"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_eks_cluster" "servicemesh_eks_cluster" {
  name     = "${var.cluster_name}"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = ["${aws_subnet.servicemesh_subnet_1.id}", "${aws_subnet.servicemesh_subnet_2.id}"]
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

output "endpoint" {
  value = "${aws_eks_cluster.servicemesh_eks_cluster.endpoint}"
}

output "kubeconfig-certificate-authority-data" {
  value = "${aws_eks_cluster.servicemesh_eks_cluster.certificate_authority.0.data}"
}