resource "aws_autoscaling_group" "demo-asg" {
  name                      = "demo-asg"
  launch_configuration      = aws_launch_configuration.asg_config.name
  vpc_zone_identifier       = [aws_subnet.pvtsn01.id, aws_subnet.pvtsn02.id]
  target_group_arns         = ["arn:aws:elasticloadbalancing:ap-south-1:931795461097:targetgroup/demo-target-grp/25ea99b54a5e44a5"]

  health_check_type         = "ELB"
  health_check_grace_period = 300
  desired_capacity          = 2
  max_size                  = 5
  min_size                  = 2
}
