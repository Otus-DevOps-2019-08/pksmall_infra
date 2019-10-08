resource "google_storage_bucket" "reddit_state_prod" {
  name     = "reddit-state-prod-puma"
  location = "${var.region}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  force_destroy = true
}