"locals" = {
  "tags_cycloid" = {
    "cycloid.io" = "true"

    "env" = "${var.env}"
  }

  "tags_stack" = {}
}

"provider" "aws" {
  "region" = "awstesting123"
}

"provider" "vault" {
  "address" = "Vaulttesting123"

  "token" = "Vaulttesttoken123"
}

"resource" "aws_security_group" "esatea" {
  "name_prefix" = "esatea"

  "tags" = {
    "cycloid.io" = "true"

    "env" = "${var.env}"
  }
}

"resource" "aws_security_group" "test1234" {
  "name_prefix" = "test1234"

  "tags" = {
    "cycloid.io" = "true"

    "env" = "${var.env}"
  }
}

"variable" "env" {
  "default" = "[PLACEHOLDER]"

  "type" = "string"
}

"variable" "project" {
  "default" = "[PLACEHOLDER]"

  "type" = "string"
}
