#create application load balancer

resource "aws_lb" "demo-alb" {
  name               = "demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.pubsn01.id, aws_subnet.pubsn02.id]


#create security group for load balancer

resource "aws_security_group" "alb-sg" {
  name = "alb-sg"
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

#setup listener and routing

 resource "aws_lb_listener" "alb_front_end" {

   default_action {
    	type             = "forward"
    	target_group_arn = "arn:aws:elasticloadbalancing:ap-south-1:931795461097:targetgroup/demo-target-grp/25ea99b54a5e44a5"
     }

    load_balancer_arn = aws_lb.demo-alb.arn
    port              = "80"
    protocol          = "HTTP"
  
}

