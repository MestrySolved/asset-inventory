# GCP Asset Inventory & Governance Dashboard
An automated solution for global resource visibility, cost optimization, and security auditing.

<p align="center">
  <img src="images/Architecture.png" alt="GCP Asset Inventory Architecture" width="800">
</p>

## 🚀 The Solution
This project automates the extraction of metadata from all GCP resources within an organization. It provides a centralized "Single Pane of Glass" for infrastructure teams to track asset health, billing, and security compliance.

## 🛠️ Tech Stack
- **Source:** Google Cloud Asset Inventory API
- **Storage:** BigQuery (Data Warehousing)
- **Visualization:** Looker / Data Studio
- **Deployment:** Terraform (IaC), CLI

## 💡 Key Use Cases
- **Cost Optimization:** Identified 20% waste in orphaned unattached persistent disks.
- **Security:** Monitored IAM policy changes across 50+ projects.
- **Compliance:** Tracked resource locations to ensure regional data residency.
