resource "aws_key_pair" "deployment" {
  key_name   = var.keypair_name != "" ? var.keypair_name : "${var.customer}-${var.project}${var.suffix}"
  public_key = var.keypair_public
}

