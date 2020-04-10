#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${DIR}/shared.sh

lo_project=${LO_PROJECT:-"live-objects-demo"}
lo_zone=${LO_ZONE:-"europe-west4-c"}
lo_namespace=${LO_NAMESPACE:-"lo-2"}

name1=backend-data
echo "Deleting disk : ${lo_namespace}-${name1} in zone : ${lo_zone}"
gcloud compute disks delete ${lo_namespace}-$name1 --zone=$lo_zone -q

name2=backend-logs
echo "Deleting disk : ${lo_namespace}-${name2} in zone : ${lo_zone}"
gcloud compute disks delete ${lo_namespace}-$name2 --zone=$lo_zone -q

name3=frontend-logs
echo "Deleting disk : ${lo_namespace}-${name3} in zone : ${lo_zone}"
gcloud compute disks delete ${lo_namespace}-$name3 --zone=$lo_zone -q

name4=postgres-data
echo "Deleting disk : ${lo_namespace}-${name4} in zone : ${lo_zone}"
gcloud compute disks delete ${lo_namespace}-$name4 --zone=$lo_zone -q

name5=learn-logs
echo "Deleting disk : ${lo_namespace}-${name5} in zone : ${lo_zone}"
gcloud compute disks delete ${lo_namespace}-$name5 --zone=$lo_zone -q

