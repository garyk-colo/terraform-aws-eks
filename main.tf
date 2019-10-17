# EKS Terraform module

module "eks" {
  source                   = "./modules/eks"
  aws-region               = "us-west-2"
  aws_access_key           = "${var.aws_access_key}"
  aws_secret_key           = "${var.aws_secret_key}"
  availability-zones       = ["us-west-2a", "us-west-2b", "us-west-2c"]
  cluster-name             = "colosseumusa-tf"
  k8s-version              = "1.14"
  node-instance-type       = "t3.medium"
  kublet-extra-args        = var.kublet-extra-args
  public-kublet-extra-args = var.public-kublet-extra-args
  root-block-size          = "40"
  desired-capacity         = "0"
  max-size                 = "5"
  min-size                 = "0"
  public-min-size          = "1" # setting to 0 will create the launch config etc, but no nodes will deploy"
  public-max-size          = "5"
  public-desired-capacity  = "3"
  vpc-subnet-cidr          = "10.0.0.0/16"
  private-subnet-cidr      = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
  public-subnet-cidr       = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]
  db-subnet-cidr           = ["10.0.192.0/21", "10.0.200.0/21", "10.0.208.0/21"]
  eks-cw-logging           = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  ec2-key-public-key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}
