# Configure vSphere provider
provider "vsphere" {
	vsphere_server = "${var.vsphere_vcenter}"
	user = "${var.vsphere_user}"
	password = "${var.vsphere_password}"

	allow_unverified_ssl = "${var.vsphere_unverified_ssl}"
}

# Create a vSphere VM folder
resource "vsphere_folder" "terraform-ubuntu-01" {
	datacenter = "${var.vsphere_datacenter}"
	path = "${var.vsphere_vm_folder}"
}

# Create a vSphere VM in the terraform folder
resource "vsphere_virtual_machine" "terraform-ubuntu" {
	# VM placement
	name = "${var.vsphere_vm_name}"
	folder = "${vsphere_folder.terraform-ubuntu-01.path}"
        datacenter = "${var.vsphere_datacenter}"
        cluster = "${var.vsphere_cluster}"

	# VM resources
	vcpu = "${var.vsphere_vcpu_number}"
	memory = "${var.vsphere_memory_size}"

        # VM storage
        disk {
                datastore = "${var.vsphere_datastore}"
                template = "${var.vsphere_vm_template}"
        }

	# VM networking
	network_interface {
		label = "${var.vsphere_port_group}"
		ipv4_address = "${var.vsphere_ipv4_address}"
		ipv4_prefix_length = "${var.vsphere_ipv4_netmask}"
		ipv4_gateway = "${var.vsphere_ipv4_gateway}"
	}

	dns_servers = ["${split(",", var.vsphere_dns_servers)}"]
	hostname = "${var.vsphere_vm_name}"

	# VM timezone

	time_zone = "${var.vsphere_time_zone}"
}
