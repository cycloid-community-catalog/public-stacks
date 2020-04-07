module "req" {

  #####################################
  # Do not modify the following lines #
  source = "module-req"
  env     = "${var.env}"
  project = "${var.project}"
  customer = "${var.customer}"
  #####################################

  #. create_s3_bucket (optional, string): "1"
  #+ To know if the the S3 bucket has to be created or not
  
  #. create_codecommit_repository (optional, string): "1""
  #+ To know if the the codecommit repo has to be created or not

  #. codecommit_readonly_key_public (optional): ""
  #+ Only required when using codecommit - key allowing readonly access to the repository

  #.  codecommit_key_public (optional): ""
  #+ Only required when using codecommit - key allowing admin access to the repository

  #. force_destroy (optional, bool): true
  #+ for S3: by default it WILL delete the s3 bucket containing its remote state.

  #. bucket_name (optional): req-terraform-remote-state
  #+ Specify the S3 bucket name 

  #. codecommit_repository_name (optional): cycloid-${var.customer}-servicescatalog
  #+ Codecommit repository name to create

  #. suffix (optional): ""
  #+ Extra potential suffix in case of already existing users

  #. infra_iam_arn (optional): ""
  #+ If provided this user will be used instead of the created one
}
