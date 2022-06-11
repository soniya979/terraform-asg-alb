# terraform-asg-alb

- create vpc with two Azs for HA
- Each Azs has public and private subnets
- create target group and application load balancer(ALB)
- create launch configurations
- create Auto scalling group where instances create into private subnets

Ref: 
https://crishantha.medium.com/production-level-load-balancing-using-aws-alb-with-auto-scaling-ccacf0a0f92
