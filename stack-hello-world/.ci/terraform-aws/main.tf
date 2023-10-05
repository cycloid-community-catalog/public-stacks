module "lambda" {

  #####################################
  # Do not modify the following lines #
  source = "./module-lambda"

  project  = var.project
  env      = var.env
  customer = var.customer
  #####################################

}
