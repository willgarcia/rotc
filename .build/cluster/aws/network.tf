resource "aws_vpc" "servicemesh_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

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

resource "aws_security_group" "servicemesh_sg" {
    name = "servicemesh_sg"
    vpc_id = "${aws_vpc.servicemesh_vpc.id}"
    description = "Allow incoming HTTP connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Do not do it in the production.
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "servicemesh_sg"
    }
}