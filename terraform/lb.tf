resource "google_compute_forwarding_rule" "lb-forward-rule" {
    name = "app-forwarding-rule"
    target = "${google_compute_target_pool.lb-puma-app.self_link}"
    port_range = "9292"
}

resource "google_compute_target_pool" "lb-puma-app" {
  name = "app-pool"

 instances = [
    "europe-west3-c/puma-app",
    "europe-west3-c/puma-app2",
  ]

  health_checks = [
    "${google_compute_http_health_check.lb-app-check.name}",
  ]
}

resource "google_compute_http_health_check" "lb-app-check" {
    name = "lb-app-check"

    check_interval_sec = 1
    healthy_threshold = 4
    unhealthy_threshold = 10
    timeout_sec = 1
    port = "9292"
}
