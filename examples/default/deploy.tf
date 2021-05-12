provider "aws" {
  region     = "ca-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "random_string" "this" {
  length  = 8
  upper   = false
  special = false
}

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "2.70.0"
  name                 = random_string.this.result
  cidr                 = "10.0.0.0/16"
  azs                  = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_dhcp_options  = true

}

module "emr_cluster" {
  source = "../../"

  master_allowed_security_groups                 = []
  slave_allowed_security_groups                  = []
  region                                         = "ca-central-1"
  security_group_vpc_id                          = module.vpc.vpc_id
  subnet_id                                      = tolist(module.vpc.private_subnets)[0]
  route_table_id                                 = module.vpc.vpc_main_route_table_id
  subnet_type                                    = "private"
  ebs_root_volume_size                           = 10
  visible_to_all_users                           = true
  release_label                                  = "emr-5.25.0"
  applications                                   = ["spark"]
  configurations_json                            = ""
  core_instance_group_instance_type              = "m5.xlarge"
  core_instance_group_instance_count             = 1
  core_instance_group_ebs_size                   = 10
  core_instance_group_ebs_type                   = "gp2"
  core_instance_group_ebs_volumes_per_instance   = 1
  master_instance_group_instance_type            = "m5.xlarge"
  master_instance_group_instance_count           = 1
  master_instance_group_ebs_size                 = 10
  master_instance_group_ebs_type                 = "gp2"
  master_instance_group_ebs_volumes_per_instance = 1
  create_task_instance_group                     = false
  log_uri                                        = "s3://test"
}
