resource "aws_security_group" "test-SG" {
  vpc_id      = aws_vpc.testvpc.id
  name        = "test_SG"
  description = "Security Group For testvpc"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.MYIP]
  }
  tags = {
    Name = "allow-ssh"
  }
}
