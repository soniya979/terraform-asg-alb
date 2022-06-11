#create Launch configuration

resource "aws_launch_configuration" "asg_config" {
  name          = "asg_config"
  image_id      = "ami-079b5e5b3971bd10d"
  instance_type = "t2.micro"
  key_name      = "asg-key-pair"
  security_groups = [aws_security_group.lc-ec2-sg.id]

  #lifecycle {
   # create_before_destroy = true
  #}
}

#EC2-Security group

resource "aws_security_group" "lc-ec2-sg" {
  name = "lc-ec2-sg"
  vpc_id = aws_vpc.mumbaivpc01.id

  # Inbound Rules
  # HTTP access from anywhere

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access from anywhere

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Outbound Rules
  # Internet access to anywhere

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
