resource "aws_key_pair" "cycloid-worker" {
  key_name   = "${var.customer}-${var.project}-${var.env}-cycloid-worker-key"
  public_key = var.keypair_public
}