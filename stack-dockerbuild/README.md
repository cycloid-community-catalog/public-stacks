# Stack-dockerbuild

Service catalog Docker Build stack

Build and test a docker image before pushing it to a registry

# Requirements

In order to run this task, couple elements are required within the infrastructure:

  * Having a registry to store the builded Docker image

# Details

## Pipeline

<img src="docs/pipeline.png" width="800">

**Jobs description**

  * `build`: Composed of several steps that you can provide : test, build, post build tests, upload the image.

Those steps can be configured for your own usage by putting the file from `docker/.ci/` into a `.ci` directory in your Docker image git repository `build.yml`, `post-tests.yml` and `tests.yml`.

**Variations**

There are 3 versions of the pipeline supported in this stack:
  * Single job: `pipeline.yml` + `variables.sample.yml` (default)
  * Split jobs: `pipeline-split-jobs.yml` + `variables.sample.yml`
  * Github PRs: `pipeline-github-pr.yml` + `variables-github-pr.sample.yml`

Currently, Cycloid console doesn't support yet switching between different pipeline variations, you will have to manually copy+paste pipeline+variables from GIT inside the Cycloid console to use them.

> **Note** Don't forget to replace the following Cycloid console anchors with the proper values when using a pipeline variation (the Cycloid console does it automatically for the default one):
>   * `($ organization_canonical $)` with your Cycloid organization name.
>   * `($ project $)` with your Cycloid project name.
>   * `($ environment $)` with your target Cycloid project environment name.

**Params**

***default & split-jobs***

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`aws_access_key`|AWS access key if pushing to AWS ECR, otherwise leave it as a empty string.|`string`|`((aws.access_key))`|`False`|
|`aws_region`|AWS region if pushing to AWS ECR, otherwise leave it as a empty string.|`string`|`eu-west-1`|`False`|
|`aws_secret_key`|AWS secret key if pushing to AWS ECR, otherwise leave it as a empty string.|`string`|`((aws.secret_key))`|`False`|
|`code_build_args`|Set build-time variables for the Docker build|`dict`|``|`False`|
|`code_build_context`|Path from the repository root to the files to build. The Dockerfile location is relative to this path.|`string`|`.`|`True`|
|`code_dockerfile_location`|Dockerfile location related to code_build_context|`string`|`Dockerfile`|`True`|
|`code_git_branch`|Branch of the code git repository.|`string`|`master`|`True`|
|`code_git_private_key`|SSH key pair to fetch the code git repository.|`string`|`((ssh_code.ssh_key))`|`True`|
|`code_git_repository`|Git repository url containing the code of the stack.|`string`|`git@github.com:...`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
|`registry_extra_tags`|Additional tags to put on the builded image. Separate each tag with a space.|`string`|`'tag1 tag2'`|`False`|
|`registry_image_name`|Name of the repository image. If using AWS ECR you only need the repository name, not the full URI e.g. `alpine` not `012345678910.dkr.ecr.us-east-1.amazonaws.com/alpine`.|`string`|`myuser/imagename`|`True`|
|`registry_password`|Password for regular image repository, otherwise leave it as a empty string.|`string`|`secret`|`False`|
|`registry_tag`|tag to put on the builded image (eg latest).|`string`|`($ environment $)`|`True`|
|`registry_tag_commit_id`|Add additionnal tag using short commit id|`bool`|`false`|`False`|
|`registry_username`|Username for regular image repository, otherwise leave it as a empty string.|`string`|`myuser`|`False`|
|`stack_git_branch`|Branch to use on the public stack git repository|`-`|`master`|`True`|

***github-pr***

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`code_build_args`|Set build-time variables for the Docker build|`dict`|``|`False`|
|`code_build_context`|Path from the repository root to the files to build. The Dockerfile location is relative to this path.|`-`|`.`|`True`|
|`code_dockerfile_location`|Dockerfile location related to code_build_context|`-`|`Dockerfile`|`True`|
|`code_git_repository`|Git repository url containing the code of the stack.|`-`|`git@github.com:...`|`True`|
|`code_github_access_token`|Github access token for Github PRs|`-`|`((custom_github.access_token))`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
|`registry_extra_tags`|Additional tags to put on the builded image.|`-`|``|`False`|
|`registry_image_name`|Name of the repository image.|`-`|`myuser/imagename`|`True`|
|`registry_tag`|tag to put on the builded image (eg latest).|`-`|`($ environment $)`|`True`|
|`registry_tag_commit_id`|Add additionnal tag using short commit id|`bool`|`false`|`False`|
|`stack_git_branch`|Branch to use on the public stack git repository|`-`|`master`|`True`|
