output "project_id" {
  value = module.pfactory_project.project_id
}

output "shared_vpc" {
  value = module.pfactory_project.project_id
}

output "sa_key" {
  value     = google_service_account_key.int_test.private_key
  sensitive = true
}

output "folder_id" {
  value = google_folder.ci_pfactory_folder.folder_id
}

output "org_id" {
  value = var.org_id
}

output "billing_account" {
  value = var.billing_account
}

output "random_string_for_testing" {
  value = random_id.random_string_for_testing.hex
}

output "gsuite_admin_account" {
  value = var.gsuite_admin_email
}

output "domain" {
  value = var.gsuite_domain
}

output "group_name" {
  value = "ci-pfactory-test-group-${random_id.folder_rand.hex}"
}

output "service_account_email" {
  value = google_service_account.int_test.email
}