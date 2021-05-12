output "cluster_id" {
  value       = module.emr_cluster.cluster_id
  description = "EMR cluster ID"
}

output "cluster_name" {
  value       = module.emr_cluster.cluster_name
  description = "EMR cluster name"
}

output "cluster_master_public_dns" {
  value       = module.emr_cluster.master_public_dns
  description = "Master public DNS"
}

output "cluster_master_security_group_id" {
  value       = module.emr_cluster.master_security_group_id
  description = "Master security group ID"
}

output "cluster_slave_security_group_id" {
  value       = module.emr_cluster.slave_security_group_id
  description = "Slave security group ID"
}
