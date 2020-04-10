#!/usr/bin/env bash

{ # make sure that the entire script is downloaded #
    #
    # Copyright Live Objects
    #
    info() {
        # 32 Green
        echo -e "\033[1m\\033[32m>>>\\033[0m\\033[0m ${1}"
    }

    error() {
        # 31 Red
        echo -e "\\033[1m\\033[31m!!!\\033[0m\\033[0m ${1}"
    }

    debug() {
        # 94 Blue
        if [[ "$DEBUG" =~ ^(TRUE|true)$ ]]; then
            echo -e "\\033[1m\\033[94m###\\033[0m\\033[0m ${1}"
        fi
    }
}
