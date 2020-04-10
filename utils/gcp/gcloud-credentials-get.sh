#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${DIR}/shared.sh

lo_project=$LO_PROJECT
lo_cluster_name=$LO_CLUSTER_NAME
lo_zone=$LO_ZONE

gcloud container clusters get-credentials ${lo_cluster_name} --project ${lo_project} --zone ${lo_zone}