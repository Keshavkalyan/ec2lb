resource "aws_instance" "web" {
  count         = 2
  ami           = "ami-0437df53acb2bbbfd"  # Amazon Linux 2 (eu-north-1)
  instance_type = "t3.micro"
  subnet_id     = data.aws_subnets.default.ids[count.index]
  vpc_security_group_ids = [aws_security_group.helloworld12.id]
  key_name      = "demokeypair"  # Optional, use if you created this key pair
  user_data     = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "Hello from EC2 instance $(hostname)" > /var/www/html/index.html
                EOF

  tags = {
    Name = "WebInstance-${count.index + 1}"
  }
}
