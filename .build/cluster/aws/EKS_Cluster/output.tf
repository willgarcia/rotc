output "endpoint" {
  value = "${aws_eks_cluster.servicemesh_eks_cluster.endpoint}"
}

output "kubeconfig_certificate_authority_data" {
  value = "${aws_eks_cluster.servicemesh_eks_cluster.certificate_authority.0.data}"
}