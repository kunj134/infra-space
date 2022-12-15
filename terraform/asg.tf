# ASG
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "kunjan-asg-node"

  min_size                  = 1
  max_size                  = 5
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = ["subnet-0001cecf11c4deaf0", "subnet-08122d8b0aa29c518"]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Launch template
  launch_template_name        = "kunjan-lt-node"
  launch_template_description = "Launch template example"
  update_default_version      = true

  image_id          = "ami-0846bcd22fb499119"
  instance_type     = "t3a.small"
  key_name          = "kunjankeyaws"
  ebs_optimized     = true
  enable_monitoring = true

  tags = {
    env = "dev"
    owner = "kunjan"
  }
}

# Scaling Policy
resource "aws_autoscaling_policy" "asg-policy" {
  count                     = 1
  name                      = "asg-cpu-policy"
  autoscaling_group_name    = module.asg.autoscaling_group_name
  estimated_instance_warmup = 60
  policy_type               = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}
