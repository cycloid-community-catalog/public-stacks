# stack-k8s-runner

This stack is designed to manage resources deployed on a Kubernetes cluster using YAML manifests and/or Terraform resources.

# Details

## Pipeline

> **Note** The pipeline contains manual approvals between `kubernetes plan` & `kubernetes apply` and `terraform plan` & `terraform apply`.
> That means if you trigger a `plan` job, to apply it, you have to go on the associated `apply` job and click on the `+` button to trigger it.
> The `kubernetes delete` and `terraform destroy` jobs are also manually triggered.

<img src="docs/pipeline.png" width="800">

**Jobs description**

  * `kubernetes-plan`: Kubernetes job that will simply make a diff and dry-run of the kubernetes manifests.
  * `kubernetes-apply`: Kubernetes job that will apply the kubernetes manifests. Please see the plan diff for a better understanding.
  * `kubernetes-delete`: :warning: Kubernetes job meant to delete the whole kubernetes manifests - **NO CONFIRMATION ASKED**. If triggered, the full project **WILL** be destroyed. Use with caution.
  * `terraform-plan`: Terraform job that will simply make a plan of the stack.
  * `terraform-apply`: Terraform job similar to the plan one, but will actually create/update everything that needs to. Please see the plan diff for a better understanding.
  * `terraform-destroy`: :warning: Terraform job meant to destroy the whole stack - **NO CONFIRMATION ASKED**. If triggered, the full project **WILL** be destroyed. Use with caution.

**Variations**

There are multiple versions of the pipeline supported in this stack:
  * Classic Kubernetes: `pipeline.yml` + `variables.sample.yml`
  * Classic Kubernetes + Terraform: `pipeline-terraform.yml` + `variables-terraform.sample.yml`
  * Amazon EKS: `pipeline-eks.yml` + `variables-eks.sample.yml`
  * Amazon EKS + Terraform: `pipeline-eks-terraform.yml` + `variables-eks-terraform.sample.yml`
  * Google GKE: `pipeline-gke.yml` + `variables-gke.sample.yml`
  * Google GKE + Terraform: `pipeline-gke-terraform.yml` + `variables-gke-terraform.sample.yml`

**Params**

***default***

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config-k8s-runner.git`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`k8s_kubeconfig`|Kubernetes config used to connect to the cluster.|`-`|`((custom_kubeconfig))`|`True`|
|`k8s_path`|Path to the manifest(s) to apply in the config git repository, can be either a folder or a single file.|`-`|`($ project $)/k8s/($ environment $)`|`True`|
|`k8s_version`|Kubernetes version for the concourse resource used to apply your manifests.|`-`|`'1.15'`|`True`|
|`k8s_wait_ready_selector`|Used to tell the concourse kubernetes resource to wait for a certain label selector to be ready.|`-`|`''`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|

***default_terraform***

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config-k8s-runner.git`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`k8s_kubeconfig`|Kubernetes config used to connect to the cluster.|`-`|`((custom_kubeconfig))`|`True`|
|`k8s_path`|Path to the manifest(s) to apply in the config git repository, can be either a folder or a single file.|`-`|`($ project $)/k8s/($ environment $)`|`True`|
|`k8s_version`|Kubernetes version for the concourse resource used to apply your manifests.|`-`|`'1.15'`|`True`|
|`k8s_wait_ready_selector`|Used to tell the concourse kubernetes resource to wait for a certain label selector to be ready.|`-`|`''`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
|`terraform_backend_config`|Terraform backend configuration.|`-`|`{}`|`True`|
|`terraform_backend_type`|Terraform backend type to use for the terraform remote state|`-`|`local`|`True`|
|`terraform_envvars`|Terraform resource envvars available during the terraform execution.|`-`|`{}`|`True`|
|`terraform_path`|Path to the terraform code to apply in the config git repository|`-`|`($ project $)/terraform/($ environment $)`|`True`|
|`terraform_vars`|Terraform resource variables available during the terraform execution.|`-`|`[customer, project, env]`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'latest'`|`True`|

***eks***

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`aws_access_key`|Amazon AWS access key for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((aws.access_key))`|`True`|
|`aws_secret_key`|Amazon AWS secret key for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((aws.secret_key))`|`True`|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config-k8s-runner.git`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`k8s_kubeconfig`|Kubernetes config used to connect to the cluster.|`-`|`((custom_kubeconfig))`|`True`|
|`k8s_path`|Path to the manifest(s) to apply in the config git repository, can be either a folder or a single file.|`-`|`($ project $)/k8s/($ environment $)`|`True`|
|`k8s_version`|Kubernetes version for the concourse resource used to apply your manifests.|`-`|`'1.15'`|`True`|
|`k8s_wait_ready_selector`|Used to tell the concourse kubernetes resource to wait for a certain label selector to be ready.|`-`|`''`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|

***eks_terraform***

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`aws_access_key`|Amazon AWS access key for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((aws.access_key))`|`True`|
|`aws_default_region`|Amazon AWS region to use for Terraform.|`-`|`eu-west-1`|`True`|
|`aws_secret_key`|Amazon AWS secret key for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((aws.secret_key))`|`True`|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config-k8s-runner.git`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`k8s_kubeconfig`|Kubernetes config used to connect to the cluster.|`-`|`((custom_kubeconfig))`|`True`|
|`k8s_path`|Path to the manifest(s) to apply in the config git repository, can be either a folder or a single file.|`-`|`($ project $)/k8s/($ environment $)`|`True`|
|`k8s_version`|Kubernetes version for the concourse resource used to apply your manifests.|`-`|`'1.15'`|`True`|
|`k8s_wait_ready_selector`|Used to tell the concourse kubernetes resource to wait for a certain label selector to be ready.|`-`|`''`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
|`terraform_path`|Path to the terraform code to apply in the config git repository|`-`|`($ project $)/terraform/($ environment $)`|`True`|
|`terraform_storage_bucket_name`|AWS S3 bucket name to store terraform remote state file.|`-`|`($ organization_canonical $)-terraform-remote-state`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'latest'`|`True`|

***gke***

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config-k8s-runner.git`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`gcp_credentials_json`|Google Cloud Platform credentials JSON for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((gcp.json_key))`|`True`|
|`k8s_kubeconfig`|Kubernetes config used to connect to the cluster.|`-`|`((custom_kubeconfig))`|`True`|
|`k8s_path`|Path to the manifest(s) to apply in the config git repository, can be either a folder or a single file.|`-`|`($ project $)/k8s/($ environment $)`|`True`|
|`k8s_version`|Kubernetes version for the concourse resource used to apply your manifests.|`-`|`'1.15'`|`True`|
|`k8s_wait_ready_selector`|Used to tell the concourse kubernetes resource to wait for a certain label selector to be ready.|`-`|`''`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|

***gke_default***

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config-k8s-runner.git`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`gcp_credentials_json`|Google Cloud Platform credentials JSON for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((gcp.json_key))`|`True`|
|`gcp_project`|Google Cloud Platform project to use for Terraform.|`-`|`($ project $)`|`True`|
|`gcp_region`|Google Cloud Platform region to use for Terraform.|`-`|`europe-west1`|`True`|
|`k8s_kubeconfig`|Kubernetes config used to connect to the cluster.|`-`|`((custom_kubeconfig))`|`True`|
|`k8s_path`|Path to the manifest(s) to apply in the config git repository, can be either a folder or a single file.|`-`|`($ project $)/k8s/($ environment $)`|`True`|
|`k8s_version`|Kubernetes version for the concourse resource used to apply your manifests.|`-`|`'1.15'`|`True`|
|`k8s_wait_ready_selector`|Used to tell the concourse kubernetes resource to wait for a certain label selector to be ready.|`-`|`''`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
|`terraform_path`|Path to the terraform code to apply in the config git repository|`-`|`($ project $)/terraform/($ environment $)`|`True`|
|`terraform_storage_bucket_name`|AWS S3 bucket name to store terraform remote state file.|`-`|`($ organization_canonical $)-terraform-remote-state`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'latest'`|`True`|
