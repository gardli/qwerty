data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}


module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "bastionInstance"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "ec2Key"
  vpc_security_group_ids = [module.vpc.default_security_group_id,aws_security_group.sg_bastionInstance.id]
  subnet_id              = element(module.vpc.public_subnets, 0)
  tags = {
    Terraform   = "true"
  }
}
