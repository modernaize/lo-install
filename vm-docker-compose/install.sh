#!/usr/bin/env bash
#
# Copyright 2020 Live Object Inc. All Rights Reserved.
#

{ # make sure that the entire script is downloaded #

    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    LATEST_VERSION=v2020.3.0
    
    info() {
        # 32 Green
        echo -e "\\033[1m\\033[32m>>>\\033[0m\\033[0m ${1}"
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

    # check if command is installed
    lo_has() {
        type "$1" >/dev/null 2>&1
    }

    lo_install_dir() {
        if [ -n "$LO_DIR" ]; then
            printf %s "${LO_DIR}"
        else
            debug "Using default Installation directory"
            lo_default_install_dir
        fi
    }

    lo_default_install_dir() {
        printf %s "$HOME/liveObjectsInstall"
    }

    lo_download() {
        debug "Executing lo_download"
        debug "Parameters : $@"
        if lo_has "curl"; then
            debug "Downloading via curl"
            curl --compressed "$@"
        elif lo_has "wget"; then
            # Emulate curl with wget
            debug "Downloading via wget"
            ARGS=$(echo "$*" | command sed -e 's/--progress-bar /--progress=bar /' \
                -e 's/-L //' \
                -e 's/--compressed //' \
                -e 's/-I /--server-response /' \
                -e 's/-s /-q /' \
                -e 's/-o /-O /' \
                -e 's/-C - /-c /')
            # shellcheck disable=SC2086
            eval wget $ARGS
        fi
    }

    install_lo_as_script() {

        # test
        # @ needs to be set if TOKEN is set , else public repo
       
        LO_GITHUB_URL=https://raw.githubusercontent.com/liveobjectsai/lo-install/${VERSION}/vm-docker-compose
      
        LO_INSTALL_TAR="install.tar.gz"
        LO_INSTALL_TAR_URL=$LO_GITHUB_URL/$LO_INSTALL_TAR

        lo_make_install_dir

        local INSTALL_DIR="$(lo_install_dir)"

        debug "INSTALL_DIR : $INSTALL_DIR"


        lo_download -s "$LO_INSTALL_TAR_URL" -o "$INSTALL_DIR/$LO_INSTALL_TAR" || {
            debug "Failed to download : $LO_INSTALL_TAR_URL"
            return 1
        } &
        for job in $(jobs -p | command sort); do
            wait "$job" || return $?
        done

        debug "Unpacking tar file $INSTALL_DIR/$LO_INSTALL_TAR" 
        
        tar -xf $INSTALL_DIR/$LO_INSTALL_TAR -C $INSTALL_DIR

        # Ensure that some scripts are executable
        
        chmod a+x "$INSTALL_DIR/nginx_create_site.sh" || {
            error >&2 "Failed to mark '$INSTALL_DIR/nginx_create_site.sh' as executable"
            return 3
        }
        chmod a+x "$INSTALL_DIR/start.sh" || {
            error >&2 "Failed to mark '$INSTALL_DIR/start.sh' as executable"
            return 3
        }
        chmod a+x "$INSTALL_DIR/stop.sh" || {
            error >&2 "Failed to mark '$INSTALL_DIR/stop.sh' as executable"
            return 3
        }
        chmod a+x "$INSTALL_DIR/config.sh" || {
            error >&2 "Failed to mark '$INSTALL_DIR/config.sh' as executable"
            return 3
        }
        chmod a+x "$INSTALL_DIR/getCertificate.sh" || {
            error >&2 "Failed to mark '$INSTALL_DIR/getCertificate.sh' as executable"
            return 3
        }
        chmod a+x "$INSTALL_DIR/refresh.sh" || {
            error >&2 "Failed to mark '$INSTALL_DIR/refresh.sh' as executable"
            return 3
        }
         
        debug "Creating directories : $INSTALL_DIR "
        mkdir -p $INSTALL_DIR/keys
        mkdir -p $INSTALL_DIR/logs
        mkdir -p $INSTALL_DIR/license
        mkdir -p $INSTALL_DIR/pgdata

        debug "Grant authorizations : $INSTALL_DIR "
        chmod -R 777 $INSTALL_DIR/keys
        chmod -R 777 $INSTALL_DIR/logs
        chmod -R 777 $INSTALL_DIR/license
        chmod -R 777 $INSTALL_DIR/pgdata

        info
        info "Live Objects Installer has been successfully downloaded into directory $INSTALL_DIR "
        info

        # input_config

    }


    lo_make_install_dir() {
        debug "Executing lo_make_install_dir"
        local INSTALL_DIR="$(lo_install_dir)"
        rm -rf "$INSTALL_DIR"
        # Downloading to $INSTALL_DIR
        mkdir -p "$INSTALL_DIR"

    }

    lo_do_install() {
        debug "Executing lo_do_install"

        if [ -n "${LO_DIR-}" ] && ! [ -d "${LO_DIR}" ]; then
            if [ -e "${LO_DIR}" ]; then
                error >&2 "File \"${LO_DIR}\" has the same name as installation directory."
                exit 1
            fi

            mkdir "${LO_DIR}" || true
        fi

        install_lo_as_script

    }

    # use environment variable
    if [[ -z "$LO_VERSION" ]]; then
        VERSION=${LATEST_VERSION}
    else 
        VERSION=${LO_VERSION}
    fi

    lo_do_install
    # this ensures the entire script is downloaded #
}
