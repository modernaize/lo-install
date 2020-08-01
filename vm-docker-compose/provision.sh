#!/usr/bin/env bash

{ # make sure that the entire script is downloaded #
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    
    # Shared code
    source ${DIR}/shared.sh

    install_docker_ce() {
        # Ensure your system is updated.
        sudo apt-get -y update

        # Install basic dependencies
        sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

        # Docker login
        sudo apt-get -y install gnupg2 pass

        # Install Docker CE on Ubuntu 18.04/19.04/16.04
        sudo apt-get -y remove docker docker-engine docker.io runc nginx

        # Import Docker repository GPG key:
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

        # Add Docker CE repository to Ubuntu:
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu disco stable"
        #sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

        # Finally install Docker CE on Ubuntu 18.04/19.04/16.04:
        sudo apt-get -y update
        sudo apt-get -y policy docker-ce
        sudo apt-get -y install docker-ce

        info "Adding User ${USER} to the docker group"
        sudo usermod -aG docker ${USER}
    }

    install_docker_compose() {
        # Install docker-compose
        sudo apt-get -y install docker-compose
    }

    main() {
        export DEBIAN_FRONTEND=noninteractive

        install_docker_ce

        # So no logoff ...
        sudo service docker restart

        install_docker_compose


        if  [[ ! -z "$1" ]] && [[ "$1" == "--nginx" ]]; then
            . ${DIR}/nginx_provision.sh 
        fi

        # setup profile

        sudo cp ${DIR}/lo-profile.sh /etc/profile.d/lo-profile.sh

        info
        info 'System installation complete'
        info

    }

    main $1

}