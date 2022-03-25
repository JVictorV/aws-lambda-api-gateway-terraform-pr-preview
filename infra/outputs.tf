output "shared_data" {
  value = terraform.workspace == "shared" ? module.shared[0] : null
}

output "app_data" {
  value = terraform.workspace != "shared" ? module.app : null
}
