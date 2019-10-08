resource "random_id" "clusterid" {
  byte_length = "2"
}

output "ibm_cloud_private_admin_url" {
  value = "https://icp-console.${var.ocp_infra_ip}.nip.io"
}

output "ibm_cloud_private_admin_user" {
  value = "${var.icp_admin_user}"
}

output "ibm_cloud_private_admin_password" {
  value = "${var.icp_admin_password}"
}

output "ibm_cloud_private_boot_ip" {
  value = "${element(values(var.ocp_master_host_ip),0)}"
}

output "registry_config_do_name"{
	value = "${var.icp_cluster_name}${random_id.clusterid.hex}RegistryConfig" 
}

output "icp_install_dir"{
  value = "/opt/ibm-cloud-private-rhos-${var.icp_version}/cluster"
}