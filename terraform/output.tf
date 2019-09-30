output "app_external_ip" {
  value = google_compute_instance.puma-app.network_interface[0].access_config[0].nat_ip
}

output "app2_external_ip" {
  value = google_compute_instance.puma-app2.network_interface[0].access_config[0].nat_ip
}

output "lb_external_ip" {
  value = "${google_compute_forwarding_rule.lb-forward-rule.ip_address}"
}
