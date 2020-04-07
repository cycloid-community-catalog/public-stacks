resource "aws_iam_user" "infra" {
  count = "${var.create_infra_user ? 1 : 0}"

  name = "infra${var.suffix}"
  path = "/cycloid/"
}

resource "aws_iam_access_key" "infra" {
  count = "${var.create_infra_user ? 1 : 0}"

  user = "${aws_iam_user.infra.name}"
}

resource "aws_iam_user_policy_attachment" "infra_user_admin_attach" {
  count      = "${var.create_infra_user ? 1 : 0}"
  user       = "${aws_iam_user.infra.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
