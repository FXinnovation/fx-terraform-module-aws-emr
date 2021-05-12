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
| aws | ~> 2 |
| aws | ~> 2.57 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2 ~> 2.57 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| emr_cluster | ../../ |  |

## Resources

| Name |
|------|
| [aws_subnet_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_key | Credentials: AWS access key. | `string` | n/a | yes |
| secret\_key | Credentials: AWS secret key. Pass this as a variable, never write password in the code. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id | EMR cluster ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
