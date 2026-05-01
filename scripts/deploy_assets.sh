#!/bin/bash

# 1. Enable Cloud Asset API
echo "Enabling Cloud Asset API..."
gcloud services enable cloudasset.googleapis.com

# 2. Create VM Instances
echo "Creating VM instances..."
gcloud compute instances create asset-1 --machine-type=f1-micro --zone=asia-south1-a
gcloud compute instances create asset-2 --machine-type=f1-micro --zone=asia-south1-b
gcloud compute instances create asset-3 --machine-type=f1-micro --zone=asia-south2-a

# 3. Export Inventory to Storage
# Replace [PROJECT_ID] with your actual project ID
PROJECT_ID="ringed-hearth-330808"
BUCKET_NAME="gs://bucket_asset"

echo "Exporting Asset Inventory to $BUCKET_NAME..."
gcloud asset export \
    --project=$PROJECT_ID \
    --content-type='resource' \
    --output-path="$BUCKET_NAME/asset_inventory_export.csv"

echo "Deployment and Export Complete."
