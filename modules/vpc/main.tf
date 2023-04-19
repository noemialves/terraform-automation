provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public" {
  count = 2
  cidr_block = "10.0.${count.index.index + 1}.0/24"
  tags = {
    Name = "public-subnet-${count.index.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count = 2
  cidr_block = "10.0.${count.index.index + 3}.0/24"
  tags = {
    Name = "private-subnet-${count.index.index + 1}"
  }
}
