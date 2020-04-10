#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${DIR}/shared.sh
source ${DIR}/config.cfg 

main() {
    if [[ ! $@ =~ ^\-.+ ]]
    then
    info "No parameter passed. All default values from config.cfg will be taken "	
    fi

    # Override values from config.cfg with runtime parameters explicitly set 
    while getopts p:z:d:n:t:c:h:m:C:L:D:? parameter 
    do 
    case "${parameter}" 
    in 
    p) lo_project=${OPTARG};; 
    z) lo_zone=${OPTARG};;
    C) lo_cluster_name=${OPTARG};;
    n) lo_namespace=${OPTARG};;
    d) lo_dns=${OPTARG};;
    t) lo_type=${OPTARG};;
    L) lo_disk_size_logs=${OPTARG};;
    D) lo_disk_size_data=${OPTARG};;
    c) lo_cloud_dns_zone=${OPTARG};;
    m) lo_machine_type=${OPTARG};;
    h) gethelp;;

    esac 
    done 

    export LO_PROJECT=${lo_project}
    export LO_ZONE=${lo_zone}
    export LO_CLUSTER_NAME=${lo_cluster_name}
    export LO_NAMESPACE=${lo_namespace}
    export LO_DNS=${lo_dns}
    export LO_TYPE=${lo_type}
    export LO_DISK_SIZE_LOGS=${lo_disk_size_logs}
    export LO_DISK_SIZE_DATA=${lo_disk_size_data}
    export LO_CLOUD_DNS_ZONE=${lo_cloud_dns_zone}
    export LO_MACHINE_TYPE=${lo_machine_type}

    info "Step 1 - Creating GKE cluster"
    . ${DIR}/gcloud-cluster-create.sh

    info "Step 2 - Get credentials"
    . ${DIR}/gcloud-credentials-get.sh

    info "Step 3 - Preparing K8S Cluster"
    . ${DIR}/gcloud-cluster-prepare.sh

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

    info "Step 4 - Update DNS settings"
    . ${DIR}/gcloud-dns-update.sh

    info "Step 5 - Create environment "
    . ${DIR}/gcp-env-create.sh

    info ""
    info "DONE"
    info ""
}

# execute main function
main "$@"