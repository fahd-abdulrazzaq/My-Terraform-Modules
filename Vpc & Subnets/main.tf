/* Creates VPC */

resource "aws_vpc" "bigvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    "Name" = "bigvpc"
  }
}

/* Create a Subnet for VPC */

resource "aws_subnet" "bigsubnetpri" {
  availability_zone = var.ZONE1
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.bigvpc.id


  tags = {
    "Name" = "bigsubnet"
  }
}

/* Creates VPC Security group */

resource "aws_security_group" "bigsg" {
  name        = "bigsg"
  description = "Security group for big VPC"
  vpc_id      = aws_vpc.bigvpc.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }


  tags = {
    "Name" = "bigsg"
  }
}

/* Launches Instance into Private Subnet */

resource "aws_instance" "biginst" {
  instance_type           = "t2.micro"
  ami                     = var.AMIS
  subnet_id               = aws_subnet.bigsubnetpri.id
  security_groups         = [aws_security_group.bigsg.id]
  key_name                = "vagrantkey-1"
  disable_api_termination = false


  tags = {
    "Name" = "biginst"
  }
}

/*  Creates Public Subnet in VPC */

resource "aws_subnet" "bigsubnetpub" {
  availability_zone = var.ZONE1
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.bigvpc.id


  tags = {
    "Name" = "bigsubnetpub"
  }
}

/* Creates an Internet Gateway For Public Subnet */

resource "aws_internet_gateway" "biggw" {
  vpc_id = aws_vpc.bigvpc.id
  tags = {
    "Name" = "biggw"
  }
}

/*Creates and Assigns Route Table To Internet Gateway */

resource "aws_route_table" "biggwrt" {
  vpc_id = aws_vpc.bigvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.biggw.id
  }
}

resource "aws_route_table_association" "biggwrtassn" {
  subnet_id      = aws_subnet.bigsubnetpub.id
  route_table_id = aws_route_table.biggwrt.id
}

/* Creates Elastic IP Which Will Be Assigned To NAT Gateway */

resource "aws_eip" "nateip" {
  vpc = true
}

/* Creates NAT Gateway And Allocates Previously Created EIP */

resource "aws_nat_gateway" "bignatgw" {
  allocation_id = aws_eip.nateip.id
  subnet_id     = aws_subnet.bigsubnetpub.id


  tags = {
    "Name" = "bignatgw"
  }
}

/* Creates NAT Gateway Route Table */

resource "aws_route_table" "natgwrt" {
  vpc_id = aws_vpc.bigvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.bignatgw.id
  }
}

/* Links Route Table To Private Subnet */

resource "aws_route_table_association" "bigsubnetpriassn" {
  subnet_id      = aws_subnet.bigsubnetpri.id
  route_table_id = aws_route_table.natgwrt.id
}

/* Deploys EC2 Instance Into Public Subnet */

resource "aws_instance" "biginstpub" {
  instance_type           = "t2.micro"
  ami                     = var.AMIS
  subnet_id               = aws_subnet.bigsubnetpub.id
  security_groups         = [aws_security_group.bigsg.id]
  key_name                = "vagrantkey-1"
  disable_api_termination = false

  tags = {
    "Name" = "biginstpub"
  }
}

resource "aws_eip" "biginstpubeip" {
  instance = aws_instance.biginstpub.id
  vpc      = true
}


/* OUTPUTS */

output "biginst_ip" {
  value = aws_instance.biginst.private_ip
}

output "natgw_public_ip" {
  value = aws_eip.nateip.public_ip
}

output "biginstpub_ip" {
  value = aws_eip.biginstpubeip.public_ip
}


