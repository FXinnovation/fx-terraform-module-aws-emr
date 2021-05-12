provider "aws" {
  region     = "ca-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

module "emr_cluster" {
  source = "../../"

  master_allowed_security_groups                 = []
  slave_allowed_security_groups                  = []
  region                                         = "ca-central-1"
  security_group_vpc_id                          = data.aws_vpc.default.id
  subnet_id                                      = data.aws_subnet_ids.default.ids[0]
  route_table_id                                 = data.aws_vpc.default.main_route_table_id
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
