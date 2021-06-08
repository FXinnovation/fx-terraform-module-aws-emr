output "cluster_id" {
  value       = element(concat(aws_emr_cluster.default.*.id, [""]), 0)
  description = "EMR cluster ID"
}

output "cluster_name" {
  value       = element(concat(aws_emr_cluster.default.*.name, [""]), 0)
  description = "EMR cluster name"
}

output "master_public_dns" {
  value       = element(concat(aws_emr_cluster.default.*.master_public_dns, [""]), 0)
  description = "Master public DNS"
}

output "master_security_group_id" {
  value       = element(concat(aws_security_group.master.*.id, [""]), 0)
  description = "Master security group ID"
}

output "slave_security_group_id" {
  value       = element(concat(aws_security_group.slave.*.id, [""]), 0)
  description = "Slave security group ID"
}

output "ec2_role" {
  value       = element(concat(aws_iam_role.ec2.*.name, [""]), 0)
  description = "Role name of EMR EC2 instances so users can attach more policies"
}
