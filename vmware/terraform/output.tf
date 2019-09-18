output "ibm_cloud_private_admin_url" {
  value = "https://icp-console.${var.ocp_infra_ip}.nip.io"
}

output "ibm_cloud_private_admin_user" {
  value = "${var.icp_admin_user}"
}

output "ibm_cloud_private_admin_password" {
  value = "${var.icp_admin_password}"
}