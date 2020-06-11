resource "aws_s3_bucket" "b" {
  bucket = "sarah-bucket-1"
  acl    = "private"
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main_vpc"
  }
}

resource "aws_subnet" "main_subnet_1" {
  vpc_id     = "${aws_vpc.main_vpc.id}"
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "main_subnet_1"
  }
}

resource "aws_subnet" "main_subnet_2" {
  vpc_id     = "${aws_vpc.main_vpc.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "main_subnet_2"
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}