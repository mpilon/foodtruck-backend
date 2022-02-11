terraform {
  required_version = ">=1.1.5"
  backend "s3" {
    bucket         = "ftfp-tf-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aws-locks"
    encrypt        = true
  }
}
#  required_providers {
#    aws = {
#      source  = "hashicorp/aws"
#      version = "~> 3.0"
#      region = var.aws_region
#    }
#  }


provider "aws" {
  version = "~> 3.0"
  region = var.aws_region  
}


module "prod-base-network" {
  source                                      = "cn-terraform/networking/aws"
  version                                     = "2.0.12"
  name_prefix                                 = "${var.env}"
  vpc_cidr_block                              = "192.168.0.0/16"
  availability_zones                          = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  public_subnets_cidrs_per_availability_zone  = ["192.168.0.0/19", "192.168.32.0/19", "192.168.64.0/19", "192.168.96.0/19"]
  private_subnets_cidrs_per_availability_zone = ["192.168.128.0/19", "192.168.160.0/19", "192.168.192.0/19", "192.168.224.0/19"]
}

module "prod-ftfp-task" {
  source              = "cn-terraform/ecs-fargate/aws"
  version             = "2.0.28"
  name_prefix         = "${var.env}-ftfp"
  vpc_id              = module.prod-base-network.vpc_id
  container_image     = var.ecr_image
  container_name      = "${var.env}-ftfp-api-container"
  log_configuration   = {
    logDriver = "awslogs"
    options = {
      awslogs-group =  "foodtruck-api" ## parameterize app name
      awslogs-region = "us-east-1"
      awslogs-create-group = "true"
      awslogs-stream-prefix = "${var.env}-ftfp"
    }
  }
  port_mappings       = [{
                          containerPort  = 5000
                          hostPort       = 5000
                          protocol       = "tcp"
                       }]
  lb_http_ports       = {
                          default_http = {
                               listener_port     = 5000
                               target_group_port = 5000
                          }
  }
  lb_https_ports      = {}
  public_subnets_ids  = module.prod-base-network.public_subnets_ids
  private_subnets_ids = module.prod-base-network.private_subnets_ids
}


resource "aws_eip" "prod-ftfp-eip-1" {
  vpc      = true
}

resource "aws_eip" "prod-ftfp-eip-2" {
  vpc      = true
}

resource "aws_nat_gateway" "prod-ftfp-nat-1" {
  connectivity_type = "public"
  subnet_id         = module.prod-base-network.private_subnets_ids[0]
  allocation_id     = aws_eip.prod-ftfp-eip-1.id
}
resource "aws_nat_gateway" "prod-ftfp-nat-2" {
  connectivity_type = "public"
  subnet_id         = module.prod-base-network.private_subnets_ids[1]
  allocation_id     = aws_eip.prod-ftfp-eip-2.id
}
