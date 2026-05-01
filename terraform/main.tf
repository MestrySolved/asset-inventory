# --- Provider Configuration ---
provider "google" {
  project = "ringed-hearth-330808"
  region  = "asia-south1"
  zone    = "asia-south1-a"
  # Note: Use environment variables for credentials in production 
  # credentials = file("path/to/your/service-account.json")
}

# --- Compute Resources ---
resource "google_compute_instance" "vm_instance" {
  count        = 3
  name         = "asset-${count.index + 1}"
  machine_type = "f1-micro"
  zone         = count.index == 2 ? "asia-south2-a" : (count.index == 1 ? "asia-south1-b" : "asia-south1-a")

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }
}

# --- Storage Resources ---
resource "google_storage_bucket" "asset_bucket" {
  name          = "bucket_asset_inventory_${uuid()}" # Unique name
  storage_class = "STANDARD"
  location      = "ASIA"
  force_destroy = true
}

# --- API Enablement ---
resource "google_project_service" "cloud_asset_api" {
  service = "cloudasset.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "resource_manager_api" {
  service = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
}
