locals {
  int_required_project_roles = [
    "roles/owner",
    "roles/compute.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/storage.admin",
    "roles/iam.serviceAccountUser",
    "roles/billing.projectManager",
  ]

  int_required_folder_roles = [
    "roles/owner",
    "roles/resourcemanager.projectCreator",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.folderIamAdmin",
    "roles/billing.projectManager",
    "roles/compute.xpnAdmin"
  ]

  int_required_org_roles = [
    "roles/accesscontextmanager.policyAdmin",
    "roles/resourcemanager.organizationViewer",
  ]
}

resource "google_service_account" "int_test" {
  project      = module.pfactory_project.project_id
  account_id   = "pfactory-int-test"
  display_name = "pfactory-int-test"
}

resource "google_project_iam_member" "int_test_project" {
  for_each = toset(local.int_required_project_roles)

  project = module.pfactory_project.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_folder_iam_member" "int_test_folder" {
  for_each = toset(local.int_required_folder_roles)

  folder = google_folder.ci_pfactory_folder.name
  role   = each.value
  member = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_organization_iam_member" "int_test_org" {
  for_each = toset(local.int_required_org_roles)

  org_id = var.org_id
  role   = each.value
  member = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_service_account_key" "int_test" {
  service_account_id = google_service_account.int_test.id
}

resource "google_billing_account_iam_member" "int_billing_admin" {
  billing_account_id = var.billing_account
  role               = "roles/billing.admin"
  member             = "serviceAccount:${google_service_account.int_test.email}"
}