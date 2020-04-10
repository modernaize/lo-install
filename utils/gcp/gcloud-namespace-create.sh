#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${DIR}/shared.sh

lo_namespace=${LO_NAMESPACE}

kubectl create namespace $lo_namespace

