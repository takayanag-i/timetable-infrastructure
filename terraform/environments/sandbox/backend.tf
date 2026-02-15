terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  # Backend configuration for storing Terraform state
  # Uncomment and configure after creating the GCS bucket
  # backend "gcs" {
  #   bucket = "YOUR_PROJECT_ID-terraform-state"
  #   prefix = "sandbox"
  # }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
