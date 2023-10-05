variable customer {
  type = "string"
}

variable env {
  type = "string"
}

variable project {
  type = "string"
}

# Required variable for S3/CodeCommit
# If nothing is provided, it will be a default variable relying on 'customer'
variable codecommit_repository_name {
  default = ""
}

# Extra potential suffix in case of already existing users
variable suffix {
  default = ""
}

# To know if the the codecommit repo has to be created or not
variable create_codecommit_repository {
  default = 1
}

# To know if the the S3 bucket has to be created or not
variable create_s3_bucket {
  default = 1
}

variable bucket_name {
  default = "req-terraform-remote-state"
}

variable force_destroy {
  default = true
}

# To know if the the infra user has to be created or not
variable create_infra_user {
  default = 1
}

# If provided this user will be used instead of the created one
variable infra_iam_arn {
  default = ""
}

# Only required when using codecommit - key allowing admin access to the repository
variable codecommit_key_public {
  default = ""
}

# Only required when using codecommit - key allowing readonly access to the repository
variable codecommit_readonly_key_public {
  default = ""
}
