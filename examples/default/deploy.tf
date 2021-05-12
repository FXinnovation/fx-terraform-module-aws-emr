provider "aws" {
  version    = "~> 2"
  region     = "ca-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}



module "emr_cluster" {
  source = "../../"

  master_allowed_security_groups = []
  slave_allowed_security_groups  = []
  security_group_vpc_id          = data.aws_vpc.default.id
  subnet_id                      = tolist(data.aws_subnet_ids.default.ids)
  #   route_table_id                                 = data.aws_subnet_ids.default.ids.private_route_table_ids[0]
  subnet_type                                    = "private"
  ebs_root_volume_size                           = "10Gib"
  visible_to_all_users                           = true
  release_label                                  = "5.2.1"
  applications                                   = var.applications
  configurations_json                            = var.configurations_json
  core_instance_group_instance_type              = var.core_instance_group_instance_type
  core_instance_group_instance_count             = var.core_instance_group_instance_count
  core_instance_group_ebs_size                   = var.core_instance_group_ebs_size
  core_instance_group_ebs_type                   = var.core_instance_group_ebs_type
  core_instance_group_ebs_volumes_per_instance   = var.core_instance_group_ebs_volumes_per_instance
  master_instance_group_instance_type            = var.master_instance_group_instance_type
  master_instance_group_instance_count           = var.master_instance_group_instance_count
  master_instance_group_ebs_size                 = var.master_instance_group_ebs_size
  master_instance_group_ebs_type                 = var.master_instance_group_ebs_type
  master_instance_group_ebs_volumes_per_instance = var.master_instance_group_ebs_volumes_per_instance
  create_task_instance_group                     = var.create_task_instance_group
  log_uri                                        = "s3://test"
}
