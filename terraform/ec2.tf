
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["mongo0", "mongos1", "mongo2"])

  name = "kunjan-${each.key}"

  ami                    = "ami-0530ca8899fac469f"
  instance_type          = "t3a.small"
  key_name               = "kunjankeyaws"
  monitoring             = true
  vpc_security_group_ids = [resource.aws_security_group.kunjan-sg-mongo.id]
  subnet_id              = module.vpc.private_subnets[0]
  
  user_data = filebase64("mongo_install.sh")
  
  tags = {
    Terraform   = "true"
    Environment = "dev"
    owner = "kunjan"
  }
}

module "ec2_instance_bastion"   {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "kunjan-bastion"

  ami                    = "ami-0530ca8899fac469f"
  instance_type          = "t3a.micro"
  key_name               = "kunjankeyaws"
  monitoring             = true
  vpc_security_group_ids = [resource.aws_security_group.kunjan-sg-bastion.id]
  subnet_id              = module.vpc.public_subnets[0]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
