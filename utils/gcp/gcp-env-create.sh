#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${DIR}/shared.sh
source ${DIR}/config.cfg 

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
while getopts p:z:d:n:t:c:h? parameter 
do 
 case "${parameter}" 
 in 
 p) lo_project=${OPTARG};; 
 z) lo_zone=${OPTARG};;
 n) lo_namespace=${OPTARG};;
 t) lo_type=${OPTARG};;
 d) lo_dns=${OPTARG};;
 c) lo_cloud_dns_zone=${OPTARG};;
 h) gethelp;;
 ?) usage;;
 esac 
done 

info "lo_project : ${lo_project}"
info "lo_zone : ${lo_zone}"
info "lo_namespace : ${lo_namespace}"
info "lo_type : ${lo_type}"
info "lo_dns : ${lo_dns}"
info "lo_cloud_dns_zone : ${lo_cloud_dns_zone}"

if [ -z "$lo_project" ]
then
   error "$lo_project is empty"
   usage;
   exit
fi

if [[ "$lo_dns" =~ '.'$ ]]; then 
  info "DNS ends with a . - All good"
else
  # Fix DNS name and add "." for GCP 
  ${lo_dns}="${lo_dns}."
fi

export LO_PROJECT=${lo_project}
export LO_ZONE=${lo_zone}
export LO_NAMESPACE=${lo_namespace}
export LO_TYPE=${lo_type}
export LO_DISK_SIZE_LOGS=${lo_disk_size_logs}
export LO_DISK_SIZE_DATA=${lo_disk_size_data}
export LO_CLOUD_DNS_ZONE=${lo_cloud_dns_zone}
export LO_DNS=${lo_dns}

info "Step 1 - Creating disks"
. ${DIR}/gcloud-disk-create.sh

info "Step 2 - Create new namespace"
. ${DIR}/gcloud-namespace-create.sh

info "Step 3 - Add docker-credentials for new namespace"
. ${DIR}/gcloud-docker-credentials-create.sh

info "Step 4 - get_external Ingress IP address"
while true; do                                                                     
    external_ip="$(kubectl get svc ingress-nginx-ingress-controller --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")"        
    if [[ -z "$external_ip" ]]; then                                               
        info "Waiting for endpoint readiness..."                                   
        sleep 10                                                                   
    else                                                                           
        sleep 2                                                                    
        export EXTERNAL_IP=$external_ip                                       
        info ""
        info  "    The LoadBalancer is up on external IP : $external_ip "
        info ""                                                                    
        break                                                                      
    fi                                                                             
done

info "Step 5 - update DNS Settings "
. ${DIR}/gcloud-dns-update.sh
