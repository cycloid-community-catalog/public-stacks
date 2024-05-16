# Stack-compute - GCP

Deploys a configurable vm in gcp and 2 associated firewalls via target_tags, one egress disactivated by default and one ingress activated with a pre-configured SSH allow traffic rule.

# Requirements

In order to run this task, couple elements are required :

* Having a VPC network [Here](https://cloud.google.com/vpc/docs/using-vpc)
* Having an Google Cloud Storage bucket to store Terraform remote states [Here](https://cloud.google.com/storage/docs/creating-buckets).

# Details

## Pipeline - Params
|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config-gke.git`|`True`|
|`config_terraform_path`|Path of Terraform files in the config git repository|`-`|`($ .project $)/terraform/($ .environment $)`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ .organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ .environment $)`|`True`|
|`gcp_credentials_json`|Google Cloud Platform credentials JSON for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((gcp.json_key))`|`True`|
|`gcp_project`|Google Cloud Platform project to use for Terraform.|`-`|`($ .project $)`|`True`|
|`gcp_region`|Google Cloud Platform region to use for Terraform.|`-`|`europe-west1`|`True`|
|`gcp_zone`|Google Cloud Platform zone to use for Terraform.|`-`|`europe-west1-b`|`False`|
|`project`|Name of the project.|`-`|`($ .project $)`|`True`|
|`stack_git_branch`|Branch to use on the public stack Git repository|`-`|`master`|`True`|
|`terraform_storage_bucket_name`|Google Cloud Storage bucket name to store terraform remote state file.|`-`|`($ .organization_canonical $)-terraform-remote-state`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'1.0.6'`|`True`|

## Terraform - inputs

**Instance Configurations**
|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`instance_name`|The unique name for the instance.|`string`|``|`True`|
|`machine_type`|The machine type to create.|`string`|``|`True`|
|`file_content`|The content of the file to use if cloud init is used.|`string`|``|`False`|
|`instance_tags`|A list of network tags to attach to the instance.|`array`|``|`False`|
|`allow_stopping_for_update`|Allows to stop the instance to update its properties.|`bool`|``|`False`|
|`instance_extra_labels`|A map of key/value label pairs to assign to the instance.|`-`|``|`False`|

**Network Configurations**
|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`network`|The name or self_link of the network to attach this interface to.|`string`|``|`True`|
|`network_ip`|The private IP address to assign to the instance. If empty, the address will be automatically assigned.|`string`|``|`False`|

**Boot Disk Configurations**
|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`boot_disk_auto_delete`|Enables disk deletion when the instance is deleted.|`bool`|``|`False`|
|`boot_disk_device_name`|Name with which attached disk will be accessible, as /dev/disk/by-id/google-{{device_name}}.|`string`|``|`False`|
|`boot_disk_image`|The image from which to initialize this disk.|`string`|``|`False`|
|`boot_disk_size`|The size of the image in gigabytes. If not specified, it will inherit the size of its base image.|`integer`|``|`False`|
|`boot_disk_type`|The GCE disk type|`string`|``|`False`|

**Firewall Ingress Configurations**
|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`ingress_firewall_name`|Name of the firewall ingress resource.|`string`|``|`False`|
|`ingress_disabled`|Denotes whether the firewall ingress rule is disabled.|`bool`|``|`False`|
|`ingress_allow_ports`|An otional list of IP ports to which the egress allow rule applies.|`map`|``|`False`|
|`ingress_allow_protocol`|The IP protocol to which the ingress allow rule applies.|`string`|``|`False`|
|`ingress_source_ranges`|If specified the firewall will only be applied to the source IP address in these ranges.|`array`|``|`False`|
|`ingress_source_tags`|If source tags are specified, the firewall will apply only to traffic with source IP that belongs to a tag listed in source tags. |`array`|``|`False`|

**Firewall Egress Configurations**
|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`egress_firewall_name`|Name of the firewall egress resource.|`string`|``|`False`|
|`egress_allow_protocol`|The IP protocol to which the egress allow rule applies.|`string`|``|`False`|
|`egress_destination_ranges`|Lists the destination IP address, as CIDR, to apply egress firewalls rules.|`array`|``|`False`|
|`egress_disabled`|Denotes whether the firewall egress rule is disabled.|`bool`|``|`False`|


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | IP of the VM |


## Attach extra storage to the VM or more firewall rules

If you need to attach extra storage to the VM or more firewall rules, you'll need to create and add the terraform code in a separate file. Please follow the example as defined in the end of the file [vm.tf.sample](terraform/gcp/vm.tf.sample)
