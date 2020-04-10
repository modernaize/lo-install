#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${DIR}/shared.sh
source ${DIR}/config.cfg 

export LO_PROJECT=${lo_project}
export LO_ZONE=${lo_zone}
export LO_CLUSTER_NAME=${lo_cluster_name}
export LO_NAMESPACE=${lo_namespace}

gethelp() {
    info "Help"
}

usage() {
    info "Wrong parameter "
    exit 1
}

detect_shell

if [[ ! $@ =~ ^\-.+ ]]
then
  info "No parameter passed. All default values from config.cfg will be taken "	
fi

# Override values from config.cfg with runtime parameters explicitly set 
while getopts p:z:n:c:h? parameter 
do 
 case "${parameter}" 
 in 
 p) lo_project=${OPTARG};; 
 z) lo_zone=${OPTARG};;
 n) lo_namespace=${OPTARG};;
 h) gethelp;;
 ?) usage;;
 esac 
done 

export LO_PROJECT=${lo_project}
export LO_ZONE=${lo_zone}
export LO_NAMESPACE=${lo_namespace}

info "lo_project : ${lo_project}"
info "lo_zone : ${lo_zone}"
info "lo_namespace : ${lo_namespace}"

info "Step 1 - Deleting GKE cluster"
. ${DIR}/gcloud-cluster-delete.sh

info "Step 2 - Deleting disks"
. ${DIR}/gcloud-disk-delete.sh