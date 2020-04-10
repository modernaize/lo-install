#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${DIR}/shared.sh
source ${DIR}/config.cfg 

export LO_PROJECT=${lo_project}
export LO_ZONE=${lo_zone}
export LO_NAMESPACE=${lo_namespace}

echo "Step 1 - Deleting existing namespace"
. ${DIR}/gcloud-namespace-delete.sh

echo "Step 2 - Deleting disks"
. ${DIR}/gcloud-disk-delete.sh


