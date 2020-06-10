"locals" = {
  "tags_cycloid" = {
    "cycloid.io" = "true"

    "env" = "${var.env}"
  }

  "tags_stack" = {}
}

"provider" "aws" {
  "region" = "e23df"
}

"provider" "vault" {
  "address" = "adfr34"

  "max_lease_ttl_seconds" = -1

  "skip_tls_verify" = false

  "token" = "dsdf"
}

"variable" "env" {
  "default" = "[PLACEHOLDER]"

  "type" = "string"
}

"variable" "project" {
  "default" = "[PLACEHOLDER]"

  "type" = "string"
}
