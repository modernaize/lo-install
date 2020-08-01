#!/bin/bash -xe

{ # make sure that the entire script is downloaded #

    local VERSION="1.0.7"
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

    # Shared code
    source ${DIR}/shared.sh

    main() {

        info 'Installing nginx'
        sudo apt-get -y install nginx

        sudo mkdir -p /etc/nginx/sites
        sudo chmod 644 /etc/nginx/sites
        sudo sed -i 's/sites-enabled/sites/' /etc/nginx/nginx.conf

        sudo apt-get -y install software-properties-common
        #sudo add-apt-repository -y ppa:certbot/certbot
        sudo apt-get update
        sudo apt-get -y install python3-certbot-nginx
        sudo apt-get -y install letsencrypt
        sudo mkdir -p /var/www/letsencrypt
    }

    main @1

}
