#!/bin/bash

# Usage of this script
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <GCP_REGION> <PUBSUB_TOPIC> <DATABASE>"
    exit 1
fi

# Assigning passed arguments to variables
REGION=$1
TOPIC=$2
DATABASE=$3

# Dynamically retrieve the GCP Project ID
PROJECT=$(gcloud config get-value project)

# Deploy the Cloud Function
gcloud functions deploy crossfiresyncp-$REGION-$DATABASE \
--gen2 \
--entry-point=com.unitvectory.crossfiresyncpubsub.CrossFireSyncPubSub \
--runtime=java17 \
--region=$REGION \
--memory=512MB \
--source=. \
--set-env-vars REPLICATION_MODE=SINGLE_REGION_PRIMARY,DATABASE=$DATABASE,GOOGLE_CLOUD_PROJECT=$PROJECT \
--trigger-topic=$TOPIC

