resource "random_id" "folder_rand" {
  byte_length = 2
}

resource "google_folder" "ci_pfactory_folder" {
  display_name = "ci-tests-pfactory-folder-${random_id.folder_rand.hex}"
  parent       = "folders/${replace(var.folder_id, "folders/", "")}"
}

module "pfactory_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 13.0"

  name              = "ci-pfactory-tests"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.ci_pfactory_folder.folder_id
  billing_account   = var.billing_account

  activate_apis = [
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "oslogin.googleapis.com",
    "serviceusage.googleapis.com",
    "billingbudgets.googleapis.com",
    "pubsub.googleapis.com",
    "accesscontextmanager.googleapis.com",
    "essentialcontacts.googleapis.com",
    "serviceconsumermanagement.googleapis.com"
  ]
}

resource "random_id" "random_string_for_testing" {
  byte_length = 3
}

# propagation time
resource "time_sleep" "wait_180_seconds" {
  depends_on = [module.pfactory_project.enabled_apis]

  create_duration = "180s"
}