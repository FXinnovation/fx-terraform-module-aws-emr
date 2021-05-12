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
| aws | >= 2.34 |

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
| access\_key | Credentials: AWS access key. | `string` | `"AKIAXNVGRAXDRI7SM43W"` | no |
| secret\_key | Credentials: AWS secret key. Pass this as a variable, never write password in the code. | `string` | `"Quei7nn63S1DQWlwoRKm1kYoWHYkzk53Kgf7yHd4"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id | EMR cluster ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
