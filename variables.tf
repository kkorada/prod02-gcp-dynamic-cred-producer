variable "vault_addr" {
    default="http://127.0.0.1:8200"
}

variable "vault_token" {}

variable "gcp_secret_engine_path" {
    default="kubex-app/ABCorg_prod02"
}

variable "creds_file_name" {
    default="/Users/kalyankorada/.kubex/5ed9cf1489687a4937766931-1591332628200-org/5ef32dd6ea7a9c7fef933af7-1592995286027-provider/5ef32dd6ea7a9c7fef933af7-cred-file.json"
}

variable "project_id" {
    default="kubex-2020"
}

variable "gcp_admin_roleset" {
    default="gke_admin"
}

variable "gcp_reader_roleset" {
    default="gke_reader"
}

variable "admin_policy_name" {
    default="ABCorg_prod02_policy"
}
