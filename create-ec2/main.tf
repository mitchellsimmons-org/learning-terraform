resource "aws_instance" "myec2" {
  ami           = "ami-030a5acd7c996ef60"
  instance_type = "t2.micro"

  tags = {
    Name = "test"
  }
}
