provider "aws" {
    version = "~> 2.0"
    region  = "${var.region}" //"us-east-1"
    profile = "${var.profile}"//"dev" //comment this out if not required
}