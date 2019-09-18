provider "vsphere" {
  version              = "~> 1.3"
  allow_unverified_ssl = "true"
}

provider "random" {
  version = "~> 1.0"
}

provider "local" {
  version = "~> 1.1"
}

provider "null" {
  version = "~> 1.0"
}

provider "tls" {
  version = "~> 1.0"
}

resource "random_string" "random-dir" {
  length  = 8
  special = false
}

resource "tls_private_key" "generate" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "null_resource" "create-temp-random-dir" {
  provisioner "local-exec" {
    command = "${format("mkdir -p  /tmp/%s" , "${random_string.random-dir.result}")}"
  }
}

module "icp_download_load" {
  source                 = "git::https://github.com/IBM-CAMHub-Development/template_icp_modules.git?ref=2.3//config_icp_on_ocp_download"

  private_key            = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_os_password         = "${var.installer_vm_os_password}"
  vm_os_user             = "${var.installer_vm_os_user}"
  ocp_installer                = "${var.ocp_master_host}.${var.ocp_vm_domain_name}"
  icp_url                = "${var.icp_binary_url}"
  icp_version            = "${var.icp_version}"
  download_user          = "${var.download_user}"
  download_user_password = "${var.download_user_password}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}"  
  #######    
  random                 = "${random_string.random-dir.result}"
}

module "icp_config_yaml" {
  source                 = "git::https://github.com/IBM-CAMHub-Development/template_icp_modules.git?ref=2.3//config_icp_on_ocp_boot"

  private_key            = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_os_password         = "${var.installer_vm_os_password}"
  vm_os_user             = "${var.installer_vm_os_user}"
  ocp_installer                = "${var.ocp_master_host}.${var.ocp_vm_domain_name}"
  icp_version            = "${var.icp_version}"
  icp_cluster_name       = "${var.icp_cluster_name}"
  icp_admin_user         = "${var.icp_admin_user}"
  icp_admin_password     = "${var.icp_admin_password}"

  icp_master_host        = "${var.icp_master_host}"
  icp_proxy_host         = "${var.icp_proxy_host}"
  icp_management_host    = "${var.icp_management_host}"
  ocp_master_host        = "${var.ocp_master_host}"
  ocp_vm_domain_name     = "${var.ocp_vm_domain_name}"
  ocp_enable_glusterfs   = "${var.ocp_enable_glusterfs}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}"  
  #######    
  random                 = "${random_string.random-dir.result}"
  dependsOn              = "${module.icp_download_load.dependsOn}"
}
