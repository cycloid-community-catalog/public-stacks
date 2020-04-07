resource "google_cloudfunctions_function" "test_function" {
  name                  = "${var.project}-${var.env}-function"
  runtime               = "nodejs10"
  available_memory_mb   = 128
  source_archive_bucket = "${var.bucket_name}"
  source_archive_object = "${var.bucket_object_path}"
  trigger_http          = true
  timeout               = 60
  entry_point           = "helloOwl"

  labels = {
    cycloid-io = "true"
    env        = "${var.env}"
    project    = "${var.project}"
    customer   = "${var.customer}"
  }
}

output "cloudfunctions_function_url" {
  value = "${google_cloudfunctions_function.test_function.https_trigger_url}"
}
