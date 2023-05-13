
resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "dev"
  }

}
resource "aws_security_group" "devsg" {
  vpc_id = aws_vpc.dev.id




  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_subnet" "devsubpub" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "devsub1"
  }

}

resource "aws_subnet" "devsubpri" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "devsub2"
  }
}



resource "aws_instance" "plugggy" {
  ami                         = var.AMIS
  instance_type               = "t2.micro"
  key_name                    = "vagrantkey-1"
  subnet_id                   = aws_subnet.devsubpub.id
  vpc_security_group_ids      = [aws_security_group.devsg.id]
  associate_public_ip_address = true




  tags = {
    Name = "plugggy"
  }

}
