#
# VM outputs
#
output "id" {
  description = "The UUID of the virtual machine"
  value       = vsphere_virtual_machine.vm.id
}

output "name" {
  description = "The name of this virtual machine"
  value       = "${var.customer}-${var.project}-${var.env}-vm"
}