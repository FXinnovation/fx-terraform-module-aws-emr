# terraform-module-multi-template

Template repository for public terraform modules

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | >= 2.34 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.34 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_emr_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emr_cluster) |
| [aws_emr_instance_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emr_instance_group) |
| [aws_iam_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) |
| [aws_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) |
| [aws_vpc_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_info | A JSON string for selecting additional features such as adding proxy information. Note: Currently there is no API to retrieve the value of this argument after EMR cluster creation from provider, therefore Terraform cannot detect drift from the actual EMR cluster if its value is changed outside Terraform | `string` | `null` | no |
| additional\_master\_security\_group | The name of the existing additional security group that will be used for EMR master node. If empty, a new security group will be created | `string` | `""` | no |
| additional\_slave\_security\_group | The name of the existing additional security group that will be used for EMR core & task nodes. If empty, a new security group will be created | `string` | `""` | no |
| applications | A list of applications for the cluster. Valid values are: Flink, Ganglia, Hadoop, HBase, HCatalog, Hive, Hue, JupyterHub, Livy, Mahout, MXNet, Oozie, Phoenix, Pig, Presto, Spark, Sqoop, TensorFlow, Tez, Zeppelin, and ZooKeeper (as of EMR 5.25.0). Case insensitive | `list(string)` | <pre>[<br>  "Spark"<br>]</pre> | no |
| bootstrap\_action | List of bootstrap actions that will be run before Hadoop is started on the cluster nodes | <pre>list(object({<br>    path = string<br>    name = string<br>    args = list(string)<br>  }))</pre> | `[]` | no |
| configurations\_json | A JSON string for supplying list of configurations for the EMR cluster. See https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-configure-apps.html for more details | `string` | `""` | no |
| core\_instance\_group\_autoscaling\_policy | String containing the EMR Auto Scaling Policy JSON for the Core instance group | `string` | `null` | no |
| core\_instance\_group\_bid\_price | Bid price for each EC2 instance in the Core instance group, expressed in USD. By setting this attribute, the instance group is being declared as a Spot Instance, and will implicitly create a Spot request. Leave this blank to use On-Demand Instances | `string` | `null` | no |
| core\_instance\_group\_ebs\_iops | The number of I/O operations per second (IOPS) that the Core volume supports | `number` | `null` | no |
| core\_instance\_group\_ebs\_size | Core instances volume size, in gibibytes (GiB) | `number` | n/a | yes |
| core\_instance\_group\_ebs\_type | Core instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1` | `string` | `"gp3"` | no |
| core\_instance\_group\_ebs\_volumes\_per\_instance | The number of EBS volumes with this configuration to attach to each EC2 instance in the Core instance group | `number` | `1` | no |
| core\_instance\_group\_instance\_count | Target number of instances for the Core instance group. Must be at least 1 | `number` | `1` | no |
| core\_instance\_group\_instance\_type | EC2 instance type for all instances in the Core instance group | `string` | n/a | yes |
| core\_instance\_group\_name | name of the emr clore group | `string` | `"emr-core"` | no |
| create\_task\_instance\_group | Whether to create an instance group for Task nodes. For more info: https://www.terraform.io/docs/providers/aws/r/emr_instance_group.html, https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-master-core-task-nodes.html | `bool` | `false` | no |
| create\_vpc\_endpoint\_s3 | Set to false to prevent the module from creating VPC S3 Endpoint | `bool` | `true` | no |
| custom\_ami\_id | A custom Amazon Linux AMI for the cluster (instead of an EMR-owned AMI). Available in Amazon EMR version 5.7.0 and later | `string` | `null` | no |
| ebs\_root\_volume\_size | Size in GiB of the EBS root device volume of the Linux AMI that is used for each EC2 instance. Available in Amazon EMR version 4.x and later | `number` | `10` | no |
| emr\_autoscaling\_role\_name | The name of the iam role assigned to emr | `string` | `"emr_autoscaling_role"` | no |
| emr\_cluster\_name | name of the emr cluster | `string` | `"emr"` | no |
| emr\_ec2\_role\_name | The name of the iam role assigned to emr | `string` | `"emr_ec2_role"` | no |
| emr\_role\_name | The name of the iam role assigned to emr | `string` | `"emr_master_role"` | no |
| keep\_job\_flow\_alive\_when\_no\_steps | Switch on/off run cluster with no steps or when all steps are complete | `bool` | `true` | no |
| kerberos\_ad\_domain\_join\_password | The Active Directory password for ad\_domain\_join\_user. Terraform cannot perform drift detection of this configuration. | `string` | `null` | no |
| kerberos\_ad\_domain\_join\_user | Required only when establishing a cross-realm trust with an Active Directory domain. A user with sufficient privileges to join resources to the domain. Terraform cannot perform drift detection of this configuration. | `string` | `null` | no |
| kerberos\_cross\_realm\_trust\_principal\_password | Required only when establishing a cross-realm trust with a KDC in a different realm. The cross-realm principal password, which must be identical across realms. Terraform cannot perform drift detection of this configuration. | `string` | `null` | no |
| kerberos\_enabled | Set to true if EMR cluster will use kerberos\_attributes | `bool` | `false` | no |
| kerberos\_kdc\_admin\_password | The password used within the cluster for the kadmin service on the cluster-dedicated KDC, which maintains Kerberos principals, password policies, and keytabs for the cluster. Terraform cannot perform drift detection of this configuration. | `string` | `null` | no |
| kerberos\_realm | The name of the Kerberos realm to which all nodes in a cluster belong. For example, EC2.INTERNAL | `string` | `"EC2.INTERNAL"` | no |
| key\_name | Amazon EC2 key pair that can be used to ssh to the master node as the user called `hadoop` | `string` | `null` | no |
| log\_uri | The path to the Amazon S3 location where logs for this cluster are stored | `string` | `null` | no |
| managed\_master\_security\_group | The name of the existing managed security group that will be used for EMR master node. If empty, a new security group will be created | `string` | `""` | no |
| managed\_master\_security\_group\_name | The name of the  managed security group that will be used for EMR master node. | `string` | `"managed-emr-master-sg"` | no |
| managed\_slave\_security\_group | The name of the existing managed security group that will be used for EMR core & task nodes. If empty, a new security group will be created | `string` | `""` | no |
| managed\_slave\_security\_group\_name | The name of the  managed security group that will be used for EMR master node. | `string` | `"managed-slave-emr-sg"` | no |
| master\_allowed\_cidr\_blocks | List of CIDR blocks to be allowed to access the master instances | `list(string)` | `[]` | no |
| master\_allowed\_security\_groups | List of security groups to be allowed to connect to the master instances | `list(string)` | `[]` | no |
| master\_dns\_name | Name of the cluster CNAME record to create in the parent DNS zone specified by `zone_id`. If left empty, the name will be auto-asigned using the format `emr-master-var.name` | `string` | `null` | no |
| master\_instance\_group\_bid\_price | Bid price for each EC2 instance in the Master instance group, expressed in USD. By setting this attribute, the instance group is being declared as a Spot Instance, and will implicitly create a Spot request. Leave this blank to use On-Demand Instances | `string` | `null` | no |
| master\_instance\_group\_ebs\_iops | The number of I/O operations per second (IOPS) that the Master volume supports | `number` | `null` | no |
| master\_instance\_group\_ebs\_size | Master instances volume size, in gibibytes (GiB) | `number` | n/a | yes |
| master\_instance\_group\_ebs\_type | Master instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1` | `string` | `"gp3"` | no |
| master\_instance\_group\_ebs\_volumes\_per\_instance | The number of EBS volumes with this configuration to attach to each EC2 instance in the Master instance group | `number` | `1` | no |
| master\_instance\_group\_instance\_count | Target number of instances for the Master instance group. Must be at least 1 | `number` | `1` | no |
| master\_instance\_group\_instance\_type | EC2 instance type for all instances in the Master instance group | `string` | n/a | yes |
| master\_instance\_group\_name | name of the emr clore group | `string` | `"emr-master"` | no |
| master\_security\_group\_name | The name of the  managed security group that will be used for EMR master node. | `string` | `"emr-master-sg"` | no |
| num\_suffix\_digits | Number of significant digits to append to instances name. | `number` | `2` | no |
| prefix | Prefix to be added to all resources, except SSM paramter keys. To prefix SSM parameter keys, see `ssm_parameters_prefix`. | `string` | `""` | no |
| region | AWS region | `string` | n/a | yes |
| release\_label | The release label for the Amazon EMR release. https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-release-5x.html | `string` | `"emr-5.25.0"` | no |
| route\_table\_id | Route table ID for the VPC S3 Endpoint when launching the EMR cluster in a private subnet. Required when `subnet_type` is `private` | `string` | `""` | no |
| scale\_down\_behavior | The way that individual Amazon EC2 instances terminate when an automatic scale-in activity occurs or an instance group is resized | `string` | `null` | no |
| security\_configuration | The security configuration name to attach to the EMR cluster. Only valid for EMR clusters with `release_label` 4.8.0 or greater. See https://www.terraform.io/docs/providers/aws/r/emr_security_configuration.html for more info | `string` | `null` | no |
| security\_group\_managed\_service\_tags | Tags to be merged to the managed slave security group | `map(string)` | `{}` | no |
| security\_group\_master\_tags | Tags to be merged to the master security group | `map(string)` | `{}` | no |
| security\_group\_slave\_tags | Tags to be merged to the slave security group | `map(string)` | `{}` | no |
| security\_group\_tags | Tags to be merged to the security group | `map(string)` | `{}` | no |
| service\_access\_security\_group | The name of the existing additional security group that will be used for EMR core & task nodes. If empty, a new security group will be created | `string` | `""` | no |
| service\_security\_group\_name | The name of the  managed security group that will be used for EMR master node. | `string` | `"service-emr-sg"` | no |
| slave\_allowed\_cidr\_blocks | List of CIDR blocks to be allowed to access the slave instances | `list(string)` | `[]` | no |
| slave\_allowed\_security\_groups | List of security groups to be allowed to connect to the slave instances | `list(string)` | `[]` | no |
| slave\_security\_group\_name | The name of the  managed security group that will be used for EMR master node. | `string` | `"emr-slave-sg"` | no |
| step\_concurrency\_level | The number of steps that can be executed concurrently. You can specify a maximum of 256 steps. Only valid for EMR clusters with release\_label 5.28.0 or greater. | `number` | `null` | no |
| steps | List of steps to run when creating the cluster. | <pre>list(object({<br>    name              = string<br>    action_on_failure = string<br>    hadoop_jar_step = object({<br>      args       = list(string)<br>      jar        = string<br>      main_class = string<br>      properties = map(string)<br>    })<br>  }))</pre> | `[]` | no |
| subnet\_id | VPC subnet ID where you want the job flow to launch. Cannot specify the `cc1.4xlarge` instance type for nodes of a job flow launched in a Amazon VPC | `string` | n/a | yes |
| subnet\_type | Type of VPC subnet ID where you want the job flow to launch. Supported values are `private` or `public` | `string` | `"private"` | no |
| tags | Tags to be merged with all resources of this module. | `map(string)` | `{}` | no |
| task\_instance\_group\_autoscaling\_policy | String containing the EMR Auto Scaling Policy JSON for the Task instance group | `string` | `null` | no |
| task\_instance\_group\_bid\_price | Bid price for each EC2 instance in the Task instance group, expressed in USD. By setting this attribute, the instance group is being declared as a Spot Instance, and will implicitly create a Spot request. Leave this blank to use On-Demand Instances | `string` | `null` | no |
| task\_instance\_group\_ebs\_iops | The number of I/O operations per second (IOPS) that the Task volume supports | `number` | `null` | no |
| task\_instance\_group\_ebs\_optimized | Indicates whether an Amazon EBS volume in the Task instance group is EBS-optimized. Changing this forces a new resource to be created | `bool` | `false` | no |
| task\_instance\_group\_ebs\_size | Task instances volume size, in gibibytes (GiB) | `number` | `10` | no |
| task\_instance\_group\_ebs\_type | Task instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1` | `string` | `"gp3"` | no |
| task\_instance\_group\_ebs\_volumes\_per\_instance | The number of EBS volumes with this configuration to attach to each EC2 instance in the Task instance group | `number` | `1` | no |
| task\_instance\_group\_instance\_count | Target number of instances for the Task instance group. Must be at least 1 | `number` | `1` | no |
| task\_instance\_group\_instance\_type | EC2 instance type for all instances in the Task instance group | `string` | `null` | no |
| task\_instance\_group\_name | name of the emr clore group | `string` | `"emr-task"` | no |
| termination\_protection | Switch on/off termination protection (default is false, except when using multiple master nodes). Before attempting to destroy the resource when termination protection is enabled, this configuration must be applied with its value set to false | `bool` | `false` | no |
| use\_existing\_additional\_master\_security\_group | If set to `true`, will use variable `additional_master_security_group` using an existing security group that was created outside of this module | `bool` | `false` | no |
| use\_existing\_additional\_slave\_security\_group | If set to `true`, will use variable `additional_slave_security_group` using an existing security group that was created outside of this module | `bool` | `false` | no |
| use\_existing\_managed\_master\_security\_group | If set to `true`, will use variable `managed_master_security_group` using an existing security group that was created outside of this module | `bool` | `false` | no |
| use\_existing\_managed\_slave\_security\_group | If set to `true`, will use variable `managed_slave_security_group` using an existing security group that was created outside of this module | `bool` | `false` | no |
| use\_existing\_service\_access\_security\_group | If set to `true`, will use variable `service_access_security_group` using an existing security group that was created outside of this module | `bool` | `false` | no |
| use\_num\_suffix | Always append numerical suffix to all resources. | `bool` | `true` | no |
| visible\_to\_all\_users | Whether the job flow is visible to all IAM users of the AWS account associated with the job flow | `bool` | `true` | no |
| vpc\_id | ID of the VPC | `string` | `null` | no |
| zone\_id | Route53 parent zone ID. If provided (not empty), the module will create sub-domain DNS records for the masters and slaves | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id | EMR cluster ID |
| cluster\_name | EMR cluster name |
| ec2\_role | Role name of EMR EC2 instances so users can attach more policies |
| master\_public\_dns | Master public DNS |
| master\_security\_group\_id | Master security group ID |
| slave\_security\_group\_id | Slave security group ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Versioning
This repository follows [Semantic Versioning 2.0.0](https://semver.org/)

## Git Hooks
This repository uses [pre-commit](https://pre-commit.com/) hooks.
