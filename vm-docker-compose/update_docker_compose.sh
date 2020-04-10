#!/usr/bin/env bash
#
{ # make sure that the entire script is downloaded #
    VERSION="1.0.7"

    # Shared code
    source shared.sh

    usage() {
        echo ""
        echo "Live Objects - The Process Intelligence Platform"
        echo ""
        exit 1
    }

    main() {
        readonly REPL_SSL_PORT=443:3000
        readonly REPL_NON_SSL_PORT=3000:3000
        readonly REPL_SSL_TRUE=TLS_CERT_PROVIDED=true
        readonly REPL_SSL_FALSE=TLS_CERT_PROVIDED=false

        sudo sed -i.1 "s/${REPL_SSL_PORT}/${REPL_NON_SSL_PORT}/g" ./docker-compose.yml  
        sudo sed -i.2 "s/${REPL_SSL_TRUE}/${REPL_SSL_FALSE}/g" ./docker-compose.yml

    }

    info 'Updating docker-compose from HTTPS => HTTPS'

    main @1
}
