#!/usr/bin/env bash

{ # make sure that the entire script is downloaded #
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

    # Shared code
    source ${DIR}/shared.sh

    usage() {
        echo ""
        echo "Live Objects Inc. - The Process Intelligence Platform"
        echo ""
        echo "./start.sh 123-456-789"
        echo ""
        echo "or "
        echo ""
        echo "export TOKEN=123-456-789 && ./start.sh"
        echo ""
        echo "The TOKEN should have been given to you by your Sales representative" 
        echo ""
        exit 1
    }

    validate-env() {
        echo
        # The follwoing env variables are being use in docker-compose.yml
        # if [[ -z "$DATA" ]]; then
        #    error "Environment variable DATA is empty"
        #    exit 2
        # fi
    } 

    docker-docker-login() {
        docker login --username=liveobjects --password=${TOKEN}

        if [ $? -ne 0 ]; then
            error ""
            error "TOKEN is invalid. Please contact your sales representative"
            error ""

            exit 1
        fi
    }

    main() {
        docker-compose up -d
        if [ $? -ne 0 ]; then
            exit 1
        fi
    }

    # check env variable TOKEN
    if [[ -z "$TOKEN" ]] && [[ -z "$1" ]]; then
        usage
    fi

    if [[ ! -z "$1" ]]; then
        TOKEN=$1
    fi

    validate-env
    docker-docker-login
    main

# count=$(docker ps --all --filter "name=${containerName}" | tail -n+2 | wc -l)
#	if [ "$count" -eq "1" ]; resume else start
   
}