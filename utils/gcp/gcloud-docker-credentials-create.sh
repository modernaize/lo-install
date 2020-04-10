#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${DIR}/shared.sh
source ${DIR}/docker.cred

lo_namespace=${LO_NAMESPACE}

check_variables() {
    if [ -z "$lo_namespace" ]
    then
    error "$lo_namespace is empty"
    exit
    fi

    if [ -z "$server" ]
    then
    error "$server is empty"
    exit
    fi

    if [ -z "$username" ]
    then
    error "$username is empty"
    exit
    fi
    if [ -z "$password" ]
    then
    error "$password is empty"
    exit
    fi

}

check_variables

kubectl create secret docker-registry regcred --docker-server=${server} --docker-username=${username} --docker-password=${password} --namespace=${lo_namespace}