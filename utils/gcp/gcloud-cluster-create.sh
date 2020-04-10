#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${DIR}/shared.sh

lo_project=$LO_PROJECT
lo_cluster_name=$LO_CLUSTER_NAME
lo_zone=$LO_ZONE
lo_machine_type=$LO_MACHINE_TYPE

gcloud container clusters create ${lo_cluster_name} --project ${lo_project} --zone ${lo_zone} --machine-type ${lo_machine_type}


