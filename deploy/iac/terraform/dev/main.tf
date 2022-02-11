terraform {
  required_version = ">=0.12.13"
  backend "s3" {
    bucket         = "ftfp-tf-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aws-locks"
    encrypt        = true
  }
}


module "dev-base-network" {
  source                                      = "cn-terraform/networking/aws"
  version                                     = "2.0.12"
  name_prefix                                 = "${var.env}"
  vpc_cidr_block                              = "192.168.0.0/16"
  availability_zones                          = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  public_subnets_cidrs_per_availability_zone  = ["192.168.0.0/19", "192.168.32.0/19", "192.168.64.0/19", "192.168.96.0/19"]
  private_subnets_cidrs_per_availability_zone = ["192.168.128.0/19", "192.168.160.0/19", "192.168.192.0/19", "192.168.224.0/19"]
}

module "dev-ftfp-task" {
  source              = "cn-terraform/ecs-fargate/aws"
  name_prefix         = "${var.env}-ftfp"
  vpc_id              = module.dev-base-network.vpc_id
  container_image     = var.ecr_image
  container_name      = "dev-ftfp-reliability-interview-container"
  log_configuration   = {
    logDriver = "awslogs"
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
  public_subnets_ids  = module.dev-base-network.public_subnets_ids
  private_subnets_ids = module.dev-base-network.private_subnets_ids
}
