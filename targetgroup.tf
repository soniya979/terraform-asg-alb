#create target group

 #basic configuration

resource "aws_lb_target_group" "demotargetgrp" {
  name     = "demo-target-grp"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  protocol_version = "HTTP1"
  vpc_id   = aws_vpc.mumbaivpc01.id


#Health check

  health_check {
    protocol = "HTTP"
    path = "/home/ec2-user/assgn3/index.html"
    
#advance setting
	  port = "traffic-port"
	  healthy_threshold = "3"
	  unhealthy_threshold = "3"
	  timeout = "5"
	  interval = "30"
	  matcher = "200"
  }
}

#register instances after creating auto-scalling group

resource "aws_alb_target_group_attachment" "trgreg1" {
  target_group_arn = "arn:aws:elasticloadbalancing:ap-south-1:931795461097:targetgroup/demo-target-grp/25ea99b54a5e44a5"
  port             = 80
  target_id        = "i-0d3cbe71dfeaece02"
}

resource "aws_alb_target_group_attachment" "trgreg2" {
  target_group_arn = "arn:aws:elasticloadbalancing:ap-south-1:931795461097:targetgroup/demo-target-grp/25ea99b54a5e44a5"
  port             = 80
  target_id        = "i-099cc408a848fbdaf"
}

