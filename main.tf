terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "prod_vpc" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "prod_subnet1" {
    vpc_id     = aws_vpc.prod_vpc.id
    cidr_block = "10.0.7.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "prod_subnet2" {
    vpc_id     = aws_vpc.prod_vpc.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "prod_subnet3"  {
    vpc_id     = aws_vpc.prod_vpc.id
    cidr_block = "10.0.5.0/24"
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.prod_vpc.id
}

resource "aws_route_table" "prod_route_table" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_igw.id
  }
}

resource "aws_route_table_association" "prod_subnet1_association" {
  subnet_id      = aws_subnet.prod_subnet1.id
  route_table_id = aws_route_table.prod_route_table.id
}

resource "aws_route_table_association" "prod_subnet2_association" {
  subnet_id      = aws_subnet.prod_subnet2.id
  route_table_id = aws_route_table.prod_route_table.id
}

resource "aws_route_table_association" "prod_subnet3_association" {
  subnet_id      = aws_subnet.prod_subnet3.id
  route_table_id = aws_route_table.prod_route_table.id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "prod_eks_cluster"
  cluster_version = "1.27"

  cluster_endpoint_public_access = true

  vpc_id                   = aws_vpc.prod_vpc.id
  subnet_ids               = [aws_subnet.prod_subnet1.id, aws_subnet.prod_subnet2.id, aws_subnet.prod_subnet3.id]
  control_plane_subnet_ids = [aws_subnet.prod_subnet1.id, aws_subnet.prod_subnet2.id, aws_subnet.prod_subnet3.id]

  eks_managed_node_groups = {
    green = {
      min_size       = 1
      max_size       = 1
      desired_size   = 1
      instance_types = ["t3.medium"]
    }
  }
}

resource "aws_ecr_repository" "microservice_a" {
  name = "microservice-a"
}

resource "aws_ecr_repository" "microservice_b" {
  name = "microservice-b"
}

output "ecr_repository_url_microservice_a" {
  value = aws_ecr_repository.microservice_a.repository_url
}

output "ecr_repository_url_microservice_b" {
  value = aws_ecr_repository.microservice_b.repository_url
}