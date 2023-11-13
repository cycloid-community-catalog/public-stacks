# Stack-getting-started

Getting started stack purpose is to ovver a easy to use Cycloid stack during onboarding process.

This stack offer on multi cloud provider to create a default compute instance.

<p align="center">
<img src="icon.png" width="250px">
</p>

# Requirements

In order to run this task you need to configure a **Terraform remote backend in your Cycloid organization settings**.
Then a couple elements are required within the infrastructure depending of the cloud provider you choose:

  * **AWS**
    * An access key to create ec2 instances [Here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) 
  * **Azure**
    * A resource group [Here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal)
    * The subnet ID of a virtual network [Here](https://docs.microsoft.com/en-us/azure/virtual-network/quick-create-portal)
    * An Azure Managed Identity [Here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/managed_service_identity)
  * **GCP** 
    * A service account upload to this bucket and create a compute instances [Here](https://cloud.google.com/iam/docs/creating-managing-service-accounts)

