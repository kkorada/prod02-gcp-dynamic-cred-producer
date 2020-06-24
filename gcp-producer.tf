provider "vault" {
  address = "${var.vault_addr}"
  token   = "${var.vault_token}"
}

resource "vault_gcp_secret_backend" "gcp_auth_producer" {
  #   depends_on                = ["google_project_iam_member.project_iam_member_vault_service_account"]
  credentials               = "${file("${var.creds_file_name}")}"
  path                      = "${var.gcp_secret_engine_path}"
  default_lease_ttl_seconds = "3600"
  max_lease_ttl_seconds     = "86400"
}

resource "vault_gcp_secret_roleset" "gke_admin" {
  backend      = "${vault_gcp_secret_backend.gcp_auth_producer.path}"
  roleset      = "${var.gcp_admin_roleset}"
  secret_type  = "access_token"
  project      = "${var.project_id}"
  token_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

  binding {
    resource = "//cloudresourcemanager.googleapis.com/projects/${var.project_id}"

    roles = [
      "roles/container.admin",
      "roles/iam.serviceAccountUser",
      "roles/iam.serviceAccountAdmin",
      "roles/compute.viewer",
      "roles/compute.admin",
      "roles/resourcemanager.projectIamAdmin",
      "roles/iam.serviceAccountTokenCreator"
    ]
  }
}

resource "vault_gcp_secret_roleset" "gke_reader" {
  backend      = "${vault_gcp_secret_backend.gcp_auth_producer.path}"
  roleset      = "${var.gcp_reader_roleset}"
  secret_type  = "access_token"
  project      = "${var.project_id}"
  token_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

  binding {
    resource = "//cloudresourcemanager.googleapis.com/projects/${var.project_id}"

    roles = [
      "roles/compute.viewer"
    ]
  }
}

resource "vault_policy" "policyname" {
  name = "${var.admin_policy_name}"

  policy = <<EOT
    path "${vault_gcp_secret_backend.gcp_auth_producer.path}/token/${vault_gcp_secret_roleset.gke_admin.roleset}" {
      capabilities = ["read", "create"]
    }

    path "auth/token/*" {
      capabilities = ["read"]
    }
  EOT
}
