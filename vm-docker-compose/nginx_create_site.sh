#!/usr/bin/env bash
#
{ # make sure that the entire script is downloaded #
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

    VERSION="1.0.7"

    # Shared code
    source ${DIR}/shared.sh

    usage() {
        echo ""
        echo "Live Objects - The Process Intelligence Platform"
        echo ""
        echo "./nginx_create_site.sh 10.22.1.27 demo3.liveobjects.rocks"
        echo ""
        echo "or "
        echo ""
        echo "export INTERNAL_IP=10.34.182.111  && export DEPLOY_URL=demo.liveobjects.rocks && ./nginx_create_site.sh"
        echo ""
        echo ""
        exit 1
    }

    main() {
        readonly REPL_DEPLOY_URL=domain
        readonly REPL_INTERNAL_IP=127.0.0.1

        # GCP Cloud DNS entry update
        # Internal IP address 10.xxxx
        # Domain = demo.liveobjects.ai

        sudo cp ${DIR}/nginx.template ${DIR}/${DEPLOY_URL}

        sudo sed -i "s/${REPL_DEPLOY_URL}/${DEPLOY_URL}/g" ${DIR}/${DEPLOY_URL}
        sudo sed -i "s/${REPL_INTERNAL_IP}/${INTERNAL_IP}/g" ${DIR}/${DEPLOY_URL}

        sudo cp ${DIR}/${DEPLOY_URL} /etc/nginx/sites

        info 'Starting Nginx'
        sudo nginx -t && sudo service nginx reload
    }

    info 'create nginx sites'

    # check env variable TOKEN
    if [[ -z "$INTERNAL_IP" ]] && [[ -z "$1" ]]; then
        usage
    fi

    if [[ ! -z "$1" ]]; then
        INTERNAL_IP=$1
    fi

    if [[ -z "$DEPLOY_URL" ]] && [[ -z "$2" ]]; then
        usage
    fi

    if [[ ! -z "$2" ]]; then
        DEPLOY_URL=$2
    fi

    main @1
}
