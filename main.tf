locals {
  tags = {
    managed-by = "terraform"
    Terraform  = "True"
  }
  bootstrap_action = concat(
    [{
      path = "file:/bin/echo",
      name = "Dummy bootstrap action to prevent EMR cluster recreation when configuration_json has parameter javax.jdo.option.ConnectionPassword",
      args = [md5(jsonencode(var.configurations_json))]
    }],
    var.bootstrap_action
  )

  kerberos_attributes = {
    ad_domain_join_password              = var.kerberos_ad_domain_join_password
    ad_domain_join_user                  = var.kerberos_ad_domain_join_user
    cross_realm_trust_principal_password = var.kerberos_cross_realm_trust_principal_password
    kdc_admin_password                   = var.kerberos_kdc_admin_password
    realm                                = var.kerberos_realm
  }
}

######
# security groups
######

resource "aws_security_group" "managed_master" {
  count                  = var.use_existing_managed_master_security_group == false ? 1 : 0
  revoke_rules_on_delete = true
  vpc_id                 = var.vpc_id
  name                   = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.managed_master_security_group_name, count.index + 1) : format("%s%s", var.prefix, var.managed_master_security_group_name)
  description            = "${var.emr_cluster_name}-EmrManagedMasterSecurityGroup"
  tags = merge(
    var.tags,
    var.security_group_master_tags,
    {
      Name = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.managed_master_security_group_name, count.index + 1) : format("%s%s", var.prefix, var.managed_master_security_group_name)
    },
    local.tags,
  )

  # EMR will update "ingress" and "egress" so we ignore the changes here
  lifecycle {
    ignore_changes = [ingress, egress]
  }
}

resource "aws_security_group_rule" "managed_master_any_egress" {
  count = var.use_existing_managed_master_security_group == false ? 1 : 0

  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = element(concat(aws_security_group.managed_master.*.id, [""]), 0)
}

resource "aws_security_group" "managed_slave" {
  count = var.use_existing_managed_slave_security_group == false ? 1 : 0

  revoke_rules_on_delete = true
  vpc_id                 = var.vpc_id
  name                   = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.managed_slave_security_group_name, count.index + 1) : format("%s%s", var.prefix, var.managed_slave_security_group_name)
  description            = "${var.emr_cluster_name}-EmrManagedSlaveSecurityGroup"
  tags = merge(
    var.tags,
    var.security_group_slave_tags,
    {
      Name = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.managed_slave_security_group_name, count.index + 1) : format("%s%s", var.prefix, var.managed_slave_security_group_name)
    },
    local.tags,
  )

  # EMR will update "ingress" and "egress" so we ignore the changes here
  lifecycle {
    ignore_changes = [ingress, egress]
  }
}

resource "aws_security_group_rule" "managed_slave_any_egress" {
  count = var.use_existing_managed_slave_security_group == false ? 1 : 0

  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = element(concat(aws_security_group.managed_slave.*.id, [""]), 0)
}

resource "aws_security_group" "managed_service_access" {
  count = var.subnet_type == "private" && var.use_existing_service_access_security_group == false ? 1 : 0

  revoke_rules_on_delete = true
  vpc_id                 = var.vpc_id
  name                   = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.service_security_group_name, count.index + 1) : format("%s%s", var.prefix, var.service_security_group_name)
  description            = "${var.emr_cluster_name}-EmrManagedServiceAccessSecurityGroup"

  tags = merge(
    var.tags,
    var.security_group_managed_service_tags,
    {
      Name = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.service_security_group_name, count.index + 1) : format("%s%s", var.prefix, var.service_security_group_name)
    },
    local.tags,
  )

  # EMR will update "ingress" and "egress" so we ignore the changes here
  lifecycle {
    ignore_changes = [ingress, egress]
  }
}

resource "aws_security_group_rule" "managed_master_service_access_9443_ingress" {
  count = var.subnet_type == "private" && var.use_existing_service_access_security_group == false ? 1 : 0

  description              = "Allow ingress traffic from EmrManagedMasterSecurityGroup"
  type                     = "ingress"
  from_port                = 9443
  to_port                  = 9443
  protocol                 = "tcp"
  source_security_group_id = element(concat(aws_security_group.managed_master.*.id, [""]), 0)
  security_group_id        = element(concat(aws_security_group.managed_service_access.*.id, [""]), 0)
}

resource "aws_security_group_rule" "managed_service_access_any_egress" {
  count = var.subnet_type == "private" && var.use_existing_service_access_security_group == false ? 1 : 0

  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = element(concat(aws_security_group.managed_service_access.*.id, [""]), 0)
}

resource "aws_security_group" "master" {
  count = var.use_existing_additional_master_security_group == false ? 1 : 0

  revoke_rules_on_delete = true
  vpc_id                 = var.vpc_id
  name                   = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.master_security_group_name, count.index + 1) : format("%s%s", var.prefix, var.master_security_group_name)
  description            = "Allow inbound traffic from Security Groups and CIDRs for masters. Allow all outbound traffic"
  tags = merge(
    var.tags,
    var.security_group_master_tags,
    {
      Name = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.master_security_group_name, count.index + 1) : format("%s%s", var.prefix, var.master_security_group_name)
    },
    local.tags,
  )
}

resource "aws_security_group_rule" "master_security_groups_any_ingress" {
  count = var.use_existing_additional_master_security_group == false ? length(var.master_allowed_security_groups) : 0

  description              = "Allow inbound traffic from Security Groups"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = var.master_allowed_security_groups[count.index]
  security_group_id        = element(concat(aws_security_group.master.*.id, [""]), 0)
}

resource "aws_security_group_rule" "master_security_groups_cidrs_any_ingress" {
  count = length(var.master_allowed_cidr_blocks) > 0 && var.use_existing_additional_master_security_group == false ? 1 : 0

  description       = "Allow inbound traffic from CIDR blocks"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = var.master_allowed_cidr_blocks
  security_group_id = element(concat(aws_security_group.master.*.id, [""]), 0)
}

resource "aws_security_group_rule" "master_security_groups_65535_egress" {
  count = var.use_existing_additional_master_security_group == false ? 1 : 0

  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = element(concat(aws_security_group.master.*.id, [""]), 0)
}

resource "aws_security_group" "slave" {
  count = var.use_existing_additional_slave_security_group == false ? 1 : 0

  revoke_rules_on_delete = true
  vpc_id                 = var.vpc_id
  name                   = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.slave_security_group_name, count.index + 1) : format("%s%s", var.prefix, var.slave_security_group_name)
  description            = "Allow inbound traffic from Security Groups and CIDRs for slaves. Allow all outbound traffic"
  tags = merge(
    var.tags,
    var.security_group_slave_tags,
    {
      Name = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.slave_security_group_name, count.index + 1) : format("%s%s", var.prefix, var.slave_security_group_name)
    },
    local.tags,
  )
}

resource "aws_security_group_rule" "slave_security_groups_65535_ingress" {
  count = var.use_existing_additional_slave_security_group == false ? length(var.slave_allowed_security_groups) : 0

  description              = "Allow inbound traffic from Security Groups"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = var.slave_allowed_security_groups[count.index]
  security_group_id        = element(concat(aws_security_group.slave.*.id, [""]), 0)
}

resource "aws_security_group_rule" "slave_security_groups_cidrs_65535_ingress" {
  count = length(var.slave_allowed_cidr_blocks) > 0 && var.use_existing_additional_slave_security_group == false ? 1 : 0

  description       = "Allow inbound traffic from CIDR blocks"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = var.slave_allowed_cidr_blocks
  security_group_id = element(concat(aws_security_group.slave.*.id, [""]), 0)
}

resource "aws_security_group_rule" "slave_security_groups_65535_egress" {
  count = var.use_existing_additional_slave_security_group == false ? 1 : 0

  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = element(concat(aws_security_group.slave.*.id, [""]), 0)
}

data "aws_iam_policy_document" "assume_role_emr" {

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["elasticmapreduce.amazonaws.com", "application-autoscaling.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  name               = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.emr_role_name, count.index + 1) : format("%s%s", var.prefix, var.emr_role_name)
  assume_role_policy = element(concat(data.aws_iam_policy_document.assume_role_emr.*.json, [""]), 0)
  tags = merge(
    var.tags,
    local.tags,
    {
      Name = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.emr_role_name, count.index + 1) : format("%s%s", var.prefix, var.emr_role_name)
    }
  )
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = element(concat(aws_iam_role.this.*.name, [""]), 0)
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

data "aws_iam_policy_document" "assume_role_ec2" {

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2" {
  name               = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.emr_ec2_role_name, count.index + 1) : format("%s%s", var.prefix, var.emr_ec2_role_name)
  assume_role_policy = element(concat(data.aws_iam_policy_document.assume_role_ec2.*.json, [""]), 0)
  tags = merge(
    var.tags,
    local.tags,
    {
      Name = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.emr_ec2_role_name, count.index + 1) : format("%s%s", var.prefix, var.emr_ec2_role_name)
    }
  )
}

resource "aws_iam_role_policy_attachment" "ec2" {
  role       = element(concat(aws_iam_role.ec2.*.name, [""]), 0)
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2" {
  name = element(concat(aws_iam_role.ec2.*.name, [""]), 0)
  role = element(concat(aws_iam_role.ec2.*.name, [""]), 0)
}

resource "aws_iam_role" "ec2_autoscaling" {
  name               = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.emr_autoscaling_role_name, count.index + 1) : format("%s%s", var.prefix, var.emr_autoscaling_role_name)
  assume_role_policy = element(concat(data.aws_iam_policy_document.assume_role_emr.*.json, [""]), 0)
  tags = merge(
    var.tags,
    local.tags,
    {
      Name = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.emr_autoscaling_role_name, count.index + 1) : format("%s%s", var.prefix, var.emr_autoscaling_role_name)
    }
  )
}

resource "aws_iam_role_policy_attachment" "ec2_autoscaling" {
  role       = element(concat(aws_iam_role.ec2_autoscaling.*.name, [""]), 0)
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforAutoScalingRole"
}

resource "aws_emr_cluster" "default" {
  name          = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.emr_cluster_name, count.index + 1) : format("%s%s", var.prefix, var.emr_cluster_name)
  release_label = var.release_label

  ec2_attributes {
    key_name                          = var.key_name
    subnet_ids                        = var.subnet_ids
    emr_managed_master_security_group = var.use_existing_managed_master_security_group == false ? element(concat(aws_security_group.managed_master.*.id, [""]), 0) : var.managed_master_security_group
    emr_managed_slave_security_group  = var.use_existing_managed_slave_security_group == false ? element(concat(aws_security_group.managed_slave.*.id, [""]), 0) : var.managed_slave_security_group
    service_access_security_group     = var.use_existing_service_access_security_group == false && var.subnet_type == "private" ? element(concat(aws_security_group.managed_service_access.*.id, [""]), 0) : var.service_access_security_group
    instance_profile                  = element(concat(aws_iam_instance_profile.ec2.*.arn, [""]), 0)
    additional_master_security_groups = var.use_existing_additional_master_security_group == false ? element(concat(aws_security_group.master.*.id, [""]), 0) : var.additional_master_security_group
    additional_slave_security_groups  = var.use_existing_additional_slave_security_group == false ? element(concat(aws_security_group.slave.*.id, [""]), 0) : var.additional_slave_security_group
  }

  termination_protection            = var.termination_protection
  keep_job_flow_alive_when_no_steps = var.keep_job_flow_alive_when_no_steps
  step_concurrency_level            = var.step_concurrency_level
  ebs_root_volume_size              = var.ebs_root_volume_size
  custom_ami_id                     = var.custom_ami_id
  visible_to_all_users              = var.visible_to_all_users

  applications = var.applications

  core_instance_group {
    name           = var.core_instance_group_name
    instance_type  = var.core_instance_group_instance_type
    instance_count = var.core_instance_group_instance_count

    ebs_config {
      size                 = var.core_instance_group_ebs_size
      type                 = var.core_instance_group_ebs_type
      iops                 = var.core_instance_group_ebs_iops
      volumes_per_instance = var.core_instance_group_ebs_volumes_per_instance
    }

    bid_price          = var.core_instance_group_bid_price
    autoscaling_policy = var.core_instance_group_autoscaling_policy
  }

  master_instance_group {
    name           = var.master_instance_group_name
    instance_type  = var.master_instance_group_instance_type
    instance_count = var.master_instance_group_instance_count
    bid_price      = var.master_instance_group_bid_price

    ebs_config {
      size                 = var.master_instance_group_ebs_size
      type                 = var.master_instance_group_ebs_type
      iops                 = var.master_instance_group_ebs_iops
      volumes_per_instance = var.master_instance_group_ebs_volumes_per_instance
    }
  }

  scale_down_behavior    = var.scale_down_behavior
  additional_info        = var.additional_info
  security_configuration = var.security_configuration

  dynamic "bootstrap_action" {
    for_each = local.bootstrap_action
    content {
      path = bootstrap_action.value.path
      name = bootstrap_action.value.name
      args = bootstrap_action.value.args
    }
  }

  dynamic "kerberos_attributes" {
    for_each = var.kerberos_enabled ? [local.kerberos_attributes] : []

    content {
      ad_domain_join_password              = kerberos_attributes.value.ad_domain_join_password
      ad_domain_join_user                  = kerberos_attributes.value.ad_domain_join_user
      cross_realm_trust_principal_password = kerberos_attributes.value.cross_realm_trust_principal_password
      kdc_admin_password                   = kerberos_attributes.value.kdc_admin_password
      realm                                = kerberos_attributes.value.realm
    }
  }

  dynamic "step" {
    for_each = var.steps
    content {
      name              = step.value.name
      action_on_failure = step.value.action_on_failure
      hadoop_jar_step {
        jar        = step.value.hadoop_jar_step["jar"]
        main_class = lookup(step.value.hadoop_jar_step, "main_class", null)
        properties = lookup(step.value.hadoop_jar_step, "properties", null)
        args       = lookup(step.value.hadoop_jar_step, "args", null)
      }
    }
  }

  configurations_json = var.configurations_json

  log_uri = var.log_uri

  service_role     = element(concat(aws_iam_role.this.*.arn, [""]), 0)
  autoscaling_role = element(concat(aws_iam_role.ec2_autoscaling.*.arn, [""]), 0)

  tags = merge(
    var.tags,
    var.emr_cluster_tags,
    local.tags,
    {
      Name = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.emr_cluster_name, count.index + 1) : format("%s%s", var.prefix, var.emr_cluster_name)
    }
  )

  lifecycle {
    ignore_changes = [kerberos_attributes, step, configurations_json]
  }
}

resource "aws_emr_instance_group" "task" {
  count = var.create_task_instance_group ? 1 : 0

  name       = var.use_num_suffix ? format("%s%s-%0${var.num_suffix_digits}d", var.prefix, var.task_instance_group_name, count.index + 1) : format("%s%s", var.prefix, var.task_instance_group_name)
  cluster_id = element(concat(aws_emr_cluster.default.*.id, [""]), 0)

  instance_type  = var.task_instance_group_instance_type
  instance_count = var.task_instance_group_instance_count

  ebs_config {
    size                 = var.task_instance_group_ebs_size
    type                 = var.task_instance_group_ebs_type
    iops                 = var.task_instance_group_ebs_iops
    volumes_per_instance = var.task_instance_group_ebs_volumes_per_instance
  }

  bid_price          = var.task_instance_group_bid_price
  ebs_optimized      = var.task_instance_group_ebs_optimized
  autoscaling_policy = var.task_instance_group_autoscaling_policy
}

resource "aws_vpc_endpoint" "vpc_endpoint_s3" {
  count = var.subnet_type == "private" && var.create_vpc_endpoint_s3 ? 1 : 0

  vpc_id          = var.vpc_id
  service_name    = format("com.amazonaws.%s.s3", var.region)
  auto_accept     = true
  route_table_ids = [var.route_table_id]
  tags            = merge(var.tags, local.tags)
}
