#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${DIR}/shared.sh
source ${DIR}/config.cfg 

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
 n) lo_namespace=${OPTARG};;
 h) gethelp;;
 ?) usage;;
 esac 
done 

export LO_NAMESPACE=${lo_namespace}

info "Step 1 - Deploying into namespace : ${lo_namespace} "
helm install lo ./ -n=${lo_namespace}