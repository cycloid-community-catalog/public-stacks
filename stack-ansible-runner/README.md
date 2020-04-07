# stack-ansible-runner

This stack allow you to do ansible or ansible-playbook command.

# Architecture

# Requirements

# Details

## Pipeline

<img src="docs/pipeline.png" width="800">

**Jobs description**

  * `ansible`: Run a ansible playbook.

**Params**

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`ansible_params`|Parameters of ansible-runner script. Can be found here: https://github.com/cycloidio/cycloid-images/tree/master/cycloid-toolkit#ansible-runner.|`-`|`dict`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`git_ansible_path`|Path of ansible files in the git repositorycycloid-toolkit docker image tag to use (https://hub.docker.com/r/cycloid/cycloid-toolkit/tags).|`-`|`./`|`True`|
|`git_branch`|Branch of the ansible source code Git repository.|`-`|`master`|`True`|
|`git_private_key`|SSH key pair to fetch ansible source code Git repository.|`-`|`((git_config.ssh_key))`|`True`|
|`git_repository`|URL to the Git repository containing ansible source code.|`-`|`git@github.com:MyUser/ansible-code.git`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
