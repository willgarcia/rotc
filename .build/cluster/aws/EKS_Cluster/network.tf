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
  map_public_ip_on_launch = "true"

  tags = {
    Name = "servicemesh_subnet_1_public"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "servicemesh_subnet_2" {
  vpc_id     = "${aws_vpc.servicemesh_vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.availability_zone_2}"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "servicemesh_subnet_2_public"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_internet_gateway" "servicemesh_igw" {
    vpc_id = "${aws_vpc.servicemesh_vpc.id}"
    tags = {
        Name = "servicemesh_igw"
    }
}

resource "aws_route_table" "servicemesh_public_crt" {
    vpc_id = "${aws_vpc.servicemesh_vpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.servicemesh_igw.id}" 
    }
    
    tags = {
        Name = "servicemesh_public_crt"
    }
}

resource "aws_route_table_association" "servicemesh_crta_public_subnet_1"{
    subnet_id = "${aws_subnet.servicemesh_subnet_1.id}"
    route_table_id = "${aws_route_table.servicemesh_public_crt.id}"
}

resource "aws_route_table_association" "servicemesh_crta_public_subnet_2"{
    subnet_id = "${aws_subnet.servicemesh_subnet_2.id}"
    route_table_id = "${aws_route_table.servicemesh_public_crt.id}"
}