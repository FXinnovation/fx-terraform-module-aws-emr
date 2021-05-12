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
| terraform | >= 0.12 |
| aws | >= 2.34 |

## Providers

| Name | Version |
|------|---------|
| random | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| emr_cluster | ../../ |  |
| vpc | terraform-aws-modules/vpc/aws | 2.70.0 |

## Resources

| Name |
|------|
| [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_key | Credentials: AWS access key. | `string` | n/a | yes |
| secret\_key | Credentials: AWS secret key. Pass this as a variable, never write password in the code. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id | EMR cluster ID |
| cluster\_master\_host | Name of the cluster CNAME record for the master nodes in the parent DNS zone |
| cluster\_master\_public\_dns | Master public DNS |
| cluster\_master\_security\_group\_id | Master security group ID |
| cluster\_name | EMR cluster name |
| cluster\_slave\_security\_group\_id | Slave security group ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
