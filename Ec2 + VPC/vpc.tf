resource "aws_vpc" "testvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"

  tags = {
    Name = "testvpc"
  }
}

resource "aws_subnet" "testsub-pub" {
  vpc_id                  = aws_vpc.testvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.ZONE1
  map_public_ip_on_launch = "true"

  tags = {
    Name = "testsub-pub"
  }
}

resource "aws_subnet" "testsub-pub-2" {
  vpc_id                  = aws_vpc.testvpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.ZONE2
  map_public_ip_on_launch = "true"

  tags = {
    Name = "testsub-pub-2"
  }
}

resource "aws_subnet" "testsub-pub-3" {
  vpc_id                  = aws_vpc.testvpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = var.ZONE3
  map_public_ip_on_launch = "true"

  tags = {
    Name = "testsub-pub-3"
  }
}

resource "aws_subnet" "testsub-pri" {
  vpc_id                  = aws_vpc.testvpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = var.ZONE1
  map_public_ip_on_launch = "true"

  tags = {
    Name = "testsub-pri-1"
  }
}

resource "aws_subnet" "testsub-pri-2" {
  vpc_id                  = aws_vpc.testvpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = var.ZONE2
  map_public_ip_on_launch = "true"

  tags = {
    Name = "testsub-pri-2"
  }
}

resource "aws_subnet" "testsub-pri-3" {
  vpc_id                  = aws_vpc.testvpc.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = var.ZONE3
  map_public_ip_on_launch = "true"

  tags = {
    Name = "testsub-pri-3"
  }
}

resource "aws_internet_gateway" "testgw" {
  vpc_id = aws_vpc.testvpc.id
  tags = {
    Name = "test-IGW"
  }
}

resource "aws_route_table" "test-RT" {
  vpc_id = aws_vpc.testvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testgw.id
  }

  tags = {
    Name = "test-RT-pub"
  }
}

resource "aws_route_table_association" "test-pub-assnt" {
  subnet_id      = aws_subnet.testsub-pub.id
  route_table_id = aws_route_table.test-RT.id
}

resource "aws_route_table_association" "test-pub-b-assnt" {
  subnet_id      = aws_subnet.testsub-pub-2.id
  route_table_id = aws_route_table.test-RT.id
}

resource "aws_route_table_association" "test-pub-c-assnt" {
  subnet_id      = aws_subnet.testsub-pub-3.id
  route_table_id = aws_route_table.test-RT.id
}





