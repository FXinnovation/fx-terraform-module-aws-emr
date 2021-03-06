resource "random_string" "this" {
  length  = 8
  upper   = false
  special = false
}

module "s3_log_bucket" {
  source        = "github.com/FXinnovation/fx-terraform-module-aws-bucket-s3.git?ref=4.0.0"
  name          = "${random_string.this.result}-emr-fx-test-log"
  force_destroy = true
}

module "vpc" {
  source = "github.com/FXinnovation/fx-mirror-terraform-module-aws-vpc.git?ref=v3.7.0"

  name                     = random_string.this.result
  cidr                     = "10.0.0.0/16"
  azs                      = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
  private_subnets          = ["10.0.1.0/24"]
  public_subnets           = ["10.0.101.0/24"]
  enable_nat_gateway       = true
  enable_dns_hostnames     = true
  enable_dns_support       = true
  enable_dhcp_options      = true
  dhcp_options_domain_name = "ca-central-1.compute.internal"
}

module "emr_cluster" {
  source = "../../"

  prefix                                         = format("%s-emr-test", random_string.this.result)
  master_allowed_security_groups                 = []
  slave_allowed_security_groups                  = []
  region                                         = "ca-central-1"
  vpc_id                                         = module.vpc.vpc_id
  subnet_ids                                     = tolist(module.vpc.private_subnets)
  route_table_id                                 = tolist(module.vpc.private_route_table_ids)[0]
  subnet_type                                    = "private"
  ebs_root_volume_size                           = 10
  visible_to_all_users                           = true
  release_label                                  = "emr-5.25.0"
  applications                                   = ["spark"]
  configurations_json                            = ""
  core_instance_group_instance_type              = "m5.xlarge"
  core_instance_group_instance_count             = 2
  core_instance_group_ebs_size                   = 10
  core_instance_group_ebs_type                   = "gp2"
  core_instance_group_ebs_volumes_per_instance   = 1
  master_instance_group_instance_type            = "m5.xlarge"
  master_instance_group_instance_count           = 1
  master_instance_group_ebs_size                 = 10
  master_instance_group_ebs_type                 = "gp2"
  master_instance_group_ebs_volumes_per_instance = 1
  create_task_instance_group                     = false
  log_uri                                        = format("s3n://%s/", module.s3_log_bucket.id)
}
