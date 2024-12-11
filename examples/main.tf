module "export_function" {
  source = "../"

  export_jobs = []

  function_name                  = var.function_name
  function_service_account_email = google_service_account.export_function.email
  project_id                     = var.project_id
  region                         = var.region
}

resource "google_project_iam_member" "export_function" {
  for_each = toset([
    "roles/compute.viewer",
    "roles/logging.logWriter",
    "roles/cloudsql.viewer",
    "roles/monitoring.metricWriter"
  ])

  role    = each.key
  member  = google_service_account.export_function.member
  project = var.project_id
}

resource "google_service_account" "export_function" {
  account_id   = var.function_name
  description  = "Service account used to trigger cloudSQL database exports."
  display_name = "cloudSQL database export function"
  project      = var.project_id
}
