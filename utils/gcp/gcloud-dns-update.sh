#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${DIR}/shared.sh

lo_project=$LO_PROJECT
lo_cloud_dns_zone=$LO_CLOUD_DNS_ZONE
lo_dns=$LO_DNS
lo_external_ip=$EXTERNAL_IP

echo "Cloud DNS Zone : ${lo_cloud_dns_zone}"
echo "DNS : ${lo_dns}"
echo "Project : ${lo_project}"

lo_existing_ip=`gcloud dns --project=$lo_project record-sets list --zone=$lo_cloud_dns_zone | grep $lo_dns | awk '{print $4}'`

echo "Existing  DNS - IP : $lo_existing_ip"
echo "External Ingress IP : $lo_external_ip"

FILE=${DIR}/transaction.yaml
if [[ -f "$FILE" ]]; then
    gcloud dns --project=$lo_project record-sets transaction abort --zone=$lo_cloud_dns_zone -q || true
    echo "Previous DNS Update change log : $FILE exist"
fi

gcloud dns --project=$lo_project record-sets transaction start --zone=$lo_cloud_dns_zone

gcloud dns --project=$lo_project record-sets transaction add "$lo_external_ip" --name=$lo_dns --ttl=300 --type=A --zone=$lo_cloud_dns_zone

gcloud dns --project=$lo_project record-sets transaction remove $lo_existing_ip --name=$lo_dns --ttl=300 --type=A --zone=$lo_cloud_dns_zone

gcloud dns --project=$lo_project record-sets transaction execute --zone=$lo_cloud_dns_zone

gcloud dns --project=$lo_project record-sets list --zone=$lo_cloud_dns_zone