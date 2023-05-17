resource "aws_instance" "test-svr" {
  ami                    = var.AMIS
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.testsub-pub.id
  vpc_security_group_ids = [aws_security_group.test-SG.id]
  tags = {
    Name = "test"
  }
}


output "PublicIP" {
  value = aws_instance.test-svr.public_ip
}
