terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                      = "us-west-2"
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  # s3_use_path_style           = true

  endpoints {
    apigateway     = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    es             = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    route53        = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    s3             = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
    ec2            = "http://localhost:4566"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway = false  # NAT gateway is not free
  enable_vpn_gateway = false

  tags = {
    project     = "project-alpha",
    environment = "dev"
  }
}

module "app_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "3.17.0"

  name        = "web-sg-project-alpha-dev"
  description = "Security group for web-servers with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.public_subnets_cidr_blocks

  tags = {
    project     = "project-alpha",
    environment = "dev"
  }
}

module "lb_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "3.17.0"

  name        = "lb-sg-project-alpha-dev"
  description = "Security group for load balancer with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    project     = "project-alpha",
    environment = "dev"
  }
}

resource "random_string" "lb_id" {
  length  = 3
  special = false
}

## ELB mocking not available on free tier of LocalStack. Set output variable directly.
# module "elb_http" {
#   source  = "terraform-aws-modules/elb/aws"
#   version = "2.4.0"

#   # Ensure load balancer name is unique
#   name = "lb-${random_string.lb_id.result}-project-alpha-dev"

#   internal = false

#   security_groups = [module.lb_security_group.this_security_group_id]
#   subnets         = module.vpc.public_subnets

#   number_of_instances = length(module.ec2_instances.instance_ids)
#   instances           = module.ec2_instances.instance_ids

#   listener = [{
#     instance_port     = "80"
#     instance_protocol = "HTTP"
#     lb_port           = "80"
#     lb_protocol       = "HTTP"
#   }]

#   health_check = {
#     target              = "HTTP:80/index.html"
#     interval            = 10
#     healthy_threshold   = 3
#     unhealthy_threshold = 10
#     timeout             = 5
#   }

#   tags = {
#     project     = "project-alpha",
#     environment = "dev"
#   }
# }

module "ec2_instances" {
  source = "./modules/aws-instance"

  instance_count     = 2
  instance_type      = "t2.micro"
  subnet_ids         = module.vpc.private_subnets[*]
  security_group_ids = [module.app_security_group.this_security_group_id]

  tags = {
    project     = "project-alpha",
    environment = "dev"
  }
}
