#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${DIR}/shared.sh

lo_project=${LO_PROJECT:-"live-objects-demo"}
lo_zone=${LO_ZONE:-"us-central1-c"}
lo_namespace=${LO_NAMESPACE:-"lo-1"}
lo_type=${LO_TYPE:-"pd-standard"}
lo_disk_size_logs=${LO_DISK_SIZE_LOGS:-"10GB"}
lo_disk_size_data=${LO_DISK_SIZE_DATA:-"100GB"}

name1=backend-data
echo "Creating disk : ${lo_namespace}-${name1} - Size : ${lo_disk_size_data} of type : ${lo_type}"
gcloud beta compute disks create ${lo_namespace}-$name1 --project $lo_project --type $lo_type --size $lo_disk_size_data --zone $lo_zone --physical-block-size=4096 --labels=namespace=${lo_namespace}

name2=backend-logs
echo "Creating disk : ${lo_namespace}-${name2} - Size : ${lo_disk_size_logs} of type : ${lo_type}"
gcloud beta compute disks create ${lo_namespace}-$name2 --project $lo_project --type $lo_type --size $lo_disk_size_logs --zone $lo_zone --physical-block-size=4096 --labels=namespace=${lo_namespace}

name3=frontend-logs
echo "Creating disk : ${lo_namespace}-${name3} - Size : ${lo_disk_size_logs} of type : ${lo_type}"
gcloud beta compute disks create ${lo_namespace}-$name3 --project $lo_project --type $lo_type --size $lo_disk_size_data --zone $lo_zone --physical-block-size=4096 --labels=namespace=${lo_namespace}

name4=postgres-data
echo "Creating disk : ${lo_namespace}-${name4} - Size : ${lo_disk_size_data} of type : ${lo_type}"
gcloud beta compute disks create ${lo_namespace}-$name4 --project $lo_project --type $lo_type --size $lo_disk_size_data --zone $lo_zone --physical-block-size=4096 --labels=namespace=${lo_namespace}

name5=learn-logs
echo "Creating disk : ${lo_namespace}-${name5} - Size : ${lo_disk_size_logs} of type : ${TYPE}"
gcloud beta compute disks create ${lo_namespace}-$name5 --project $lo_project --type $lo_type --size $lo_disk_size_logs --zone $lo_zone --physical-block-size=4096 --labels=namespace=${lo_namespace}
