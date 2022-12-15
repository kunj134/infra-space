module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "kunjan-alb"

  load_balancer_type = "application"

  vpc_id             = "vpc-0f5dc0322f0862677"
  subnets            = module.vpc.public_subnets
  security_groups    = [resource.aws_security_group.kunjan-sg-lb.id]
}
