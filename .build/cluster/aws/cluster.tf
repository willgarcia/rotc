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