# Multi-Phase Asset Inventory Implementation
This document outlines the three phases of implementation for the GCP Asset Inventory & Governance Tool, ranging from manual configuration to scalable Infrastructure as Code (IaC).

## Phase 1: Manual Configuration (Cloud Console)
**Purpose:** To establish the architectural blueprint and verify fine-grained access controls.

- **Infrastructure Provisioning:** Created three f1-micro VM instances (asset-1, asset-2, asset-3) across asia-south1 and asia-south2 to simulate a distributed environment.
<p align="center">
  <img src="images/6.JPG" alt="GCP CE" width="800">
</p>

- **Service Enablement:** Manually enabled the Cloud Asset API via the API Dashboard to verify project-level permissions.
<p align="center">
  <img src="images/10.JPG" alt="GCP API" width="800">
</p>

- **Storage Setup:** Provisioned a Multi-Region (ASIA) Standard Storage bucket (bucket_asset) with Fine-grained access control to host metadata exports.
<p align="center">
  <img src="images/3.JPG" alt="GCP Bucket" width="800">
</p>

- **Data Extraction:** Performed manual exports of Resource and IAM Policy metadata to CSV for initial data schema validation.
<p align="center">
  <img src="images/7.JPG" alt="GCP IAM" width="800">
</p>

## Phase 2: CLI & Cloud Shell Automation
**Purpose:** To demonstrate programmatic control and rapid deployment using the gcloud SDK.

- **Resource Generation:**
```Bash
gcloud compute instances create asset-1 --machine-type=f1-micro --zone=asia-south1-a
gcloud compute instances create asset-2 --machine-type=f1-micro --zone=asia-south1-b
gcloud compute instances create asset-3 --machine-type=f1-micro --zone=asia-south2-a
```
- **API Management:**
```Bash
gcloud services enable cloudasset.googleapis.com
```
- **Automated Metadata Export:** Executed the following command to move project metadata into the governance bucket:
```Bash
gcloud asset export --project='[PROJECT_ID]' --content-type='resource' --output-path "gs://bucket_asset/asset_inventory_export.csv"
```
[deploy scripts](scripts/deploy_assets.sh)

## Phase 3: Infrastructure as Code (Terraform)
**Purpose:** To ensure environment reproducibility and eliminate configuration drift.

The following HCL code automates the entire lifecycle of the Asset Inventory system:

Provider Configuration
```Terraform
provider "google" {
  project = "ringed-hearth-330808"
  region  = "asia-south1"
  zone    = "asia-south1-a"
}
```
Resource Deployment
- **Compute:** Automated deployment of 3 VM instances across multiple zones.
- **Storage:** Defined a google_storage_bucket with force_destroy = true for clean environment teardown.
- **Services:** Managed google_project_service for Cloud Asset and Resource Manager APIs with specific timeouts to ensure stable deployments.

[main.tf](terraform/main.tf)

## Phase 4: Data Visualization (Looker Studio)
**Purpose:** Transforming raw metadata into actionable business insights.

- **Connector:** Utilized the Google Cloud Storage Connector to link the exported CSV files directly to Looker Studio.
- **Data Transformation:** Mapped resource types, locations, and timestamps to visualize the global footprint.
- **Insights Delivered:**
  - **Resource Distribution:** Visualized assets across asia-south1 vs asia-south2.
  - **Governance Audit:** Tracked IAM policy assignments to identify potential over-privileged accounts.

<p align="center">
  <img src="images/2.JPG" alt="Looker" width="800">
</p>
<p align="center">
  <img src="images/1.JPG" alt="Looker" width="800">
</p>

## Issue Tracker & Resolution
- **Observation:** Initial Lack of Asset Inventory data.
- **Solution:** Scripted the creation of diverse resources (VMs, IAM, Load Balancers) to populate the inventory, providing a rich dataset for governance testing.
