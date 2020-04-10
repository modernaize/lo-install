#!/usr/bin/env bash

{ # make sure that the entire script is downloaded #

    docker-compose down

    # count=$(docker ps --all --filter "name=${containerName}" | tail -n+2 | wc -l)
    #	if [ "$count" -eq "1" ]; resume else start

}
