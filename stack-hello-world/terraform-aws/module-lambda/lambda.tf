resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.project}_iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_lambda_function" "test_lambda" {
  filename = "../../s3_release/${var.project}.zip"
  source_code_hash = filebase64sha256("../../s3_release/${var.project}.zip")

  function_name = "${var.project}-${var.env}-lambda"
  role = aws_iam_role.iam_for_lambda.arn
  handler = "index.handler"

  runtime = "nodejs8.10"

  environment {
    variables = {
      env = var.env
    }
  }

  tags = {
    "cycloid.io" = "true"
    env = var.env
    project = var.project
    customer = var.customer
  }
}

output "lambda_function_arn" {
  value = aws_lambda_function.test_lambda.arn
}
