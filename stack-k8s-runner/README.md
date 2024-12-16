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
