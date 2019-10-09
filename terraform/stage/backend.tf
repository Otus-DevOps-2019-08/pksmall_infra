resource "google_storage_bucket" "reddit_state_stage" {
  name     = "reddit-state-stage-puma"
  location = "${var.region}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  force_destroy = true
}