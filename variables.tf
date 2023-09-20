variable "service_account_name_prefix" {
  type        = string
  description = "Service account name prefix"
  default     = "sa"
}

variable "service_account_name" {
  type        = string
  description = "Service account name"
  default     = "github"
}

variable "roles_for_service_account" {
  type        = list(string)
  description = "Roles for service account without roles prefix"
  default     = []
}

variable "workload_identity_id" {
  type        = string
  description = "Workload identity id"
  default     = "github-actions"
}

variable "workload_identity_display_name" {
  type        = string
  description = "Workload identity display name"
  default     = "GitHub Actions"
}

variable "workload_identity_descriptiom" {
  type        = string
  description = "Workload identity description"
  default     = "OIDC Provider for GitHub Actions"
}

variable "workload_identity_pool_provider_attribute_condition" {
  type        = string
  description = "Workload identity pool provider attribute condition"
  default     = ""
}

variable "google_project_id_to_create_sa" {
  type        = string
  description = "Project ID where SA is created"
}

variable "google_project_id_for_roles" {
  type        = list(string)
  description = "Project ID to which the role is granted"
}

variable "github_owner" {
  type        = string
  description = "GitHub owner"
}

variable "github_repo" {
  type        = string
  description = "GitHub repo"
}
