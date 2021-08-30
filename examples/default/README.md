# Default example

## Usage

```
# terraform init
# terraform apply
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.5 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_emr_cluster"></a> [emr\_cluster](#module\_emr\_cluster) | ../../ | n/a |
| <a name="module_s3_log_bucket"></a> [s3\_log\_bucket](#module\_s3\_log\_bucket) | git::ssh://git@scm.dazzlingwrench.fxinnovation.com:2222/fxinnovation-public/terraform-module-aws-bucket-s3.git | 2.1.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 2.70.0 |

## Resources

| Name | Type |
|------|------|
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_key"></a> [access\_key](#input\_access\_key) | Credentials: AWS access key. | `string` | n/a | yes |
| <a name="input_secret_key"></a> [secret\_key](#input\_secret\_key) | Credentials: AWS secret key. Pass this as a variable, never write password in the code. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | EMR cluster ID |
| <a name="output_cluster_master_public_dns"></a> [cluster\_master\_public\_dns](#output\_cluster\_master\_public\_dns) | Master public DNS |
| <a name="output_cluster_master_security_group_id"></a> [cluster\_master\_security\_group\_id](#output\_cluster\_master\_security\_group\_id) | Master security group ID |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | EMR cluster name |
| <a name="output_cluster_slave_security_group_id"></a> [cluster\_slave\_security\_group\_id](#output\_cluster\_slave\_security\_group\_id) | Slave security group ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
