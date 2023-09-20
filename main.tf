module "google_service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "4.2.0"

  project_id = var.google_project_id_to_create_sa
  prefix     = var.service_account_name_prefix
  names      = [var.service_account_name]

  project_roles = (
    var.roles_for_service_account == [] ? [] :
    flatten([
      for r in var.google_project_ids_for_roles
      : formatlist("%s=>roles/%s", r, var.roles_for_service_account)
    ])
  )
}

resource "google_iam_workload_identity_pool" "main" {
  provider                  = google-beta
  project                   = var.google_project_id_to_create_sa
  workload_identity_pool_id = var.workload_identity_id
  display_name              = var.workload_identity_display_name
}

resource "google_iam_workload_identity_pool_provider" "provider" {
  project                            = var.google_project_id_to_create_sa
  workload_identity_pool_id          = google_iam_workload_identity_pool.main.workload_identity_pool_id
  workload_identity_pool_provider_id = var.workload_identity_id
  display_name                       = var.workload_identity_display_name
  description                        = var.workload_identity_descriptiom
  attribute_condition                = var.workload_identity_pool_provider_attribute_condition

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.owner"      = "assertion.repository_owner"
    "attribute.refs"       = "assertion.ref"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_binding" "binding" {
  service_account_id = module.google_service_accounts.service_account.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.main.name}/attribute.repository/${var.github_owner}/${var.github_repo}"
  ]
}
