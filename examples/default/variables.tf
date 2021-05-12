variable "region" {
  type        = string
  description = "AWS region"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "ebs_root_volume_size" {
  type        = number
  description = "Size in GiB of the EBS root device volume of the Linux AMI that is used for each EC2 instance. Available in Amazon EMR version 4.x and later"
}

variable "visible_to_all_users" {
  type        = bool
  description = "Whether the job flow is visible to all IAM users of the AWS account associated with the job flow"
}

variable "release_label" {
  type        = string
  description = "The release label for the Amazon EMR release. https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-release-5x.html"
}

variable "configurations_json" {
  type        = string
  description = "A JSON string for supplying list of configurations for the EMR cluster"
  default     = ""
}

variable "core_instance_group_instance_type" {
  type        = string
  description = "EC2 instance type for all instances in the Core instance group"
}

variable "core_instance_group_instance_count" {
  type        = number
  description = "Target number of instances for the Core instance group. Must be at least 1"
}

variable "core_instance_group_ebs_size" {
  type        = number
  description = "Core instances volume size, in gibibytes (GiB)"
}

variable "core_instance_group_ebs_type" {
  type        = string
  description = "Core instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1`"
}

variable "core_instance_group_ebs_volumes_per_instance" {
  type        = number
  description = "The number of EBS volumes with this configuration to attach to each EC2 instance in the Core instance group"
}

variable "master_instance_group_instance_type" {
  type        = string
  description = "EC2 instance type for all instances in the Master instance group"
}

variable "master_instance_group_instance_count" {
  type        = number
  description = "Target number of instances for the Master instance group. Must be at least 1"
}

variable "master_instance_group_ebs_size" {
  type        = number
  description = "Master instances volume size, in gibibytes (GiB)"
}

variable "master_instance_group_ebs_type" {
  type        = string
  description = "Master instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1`"
}

variable "master_instance_group_ebs_volumes_per_instance" {
  type        = number
  description = "The number of EBS volumes with this configuration to attach to each EC2 instance in the Master instance group"
}

variable "create_task_instance_group" {
  type        = bool
  description = "Whether to create an instance group for Task nodes. For more info: https://www.terraform.io/docs/providers/aws/r/emr_instance_group.html, https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-master-core-task-nodes.html"
}


variable "access_key" {
  description = "Credentials: AWS access key."
  type        = string
}

variable "secret_key" {
  description = "Credentials: AWS secret key. Pass this as a variable, never write password in the code."
  type        = string
}
