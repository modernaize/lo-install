#!/usr/bin/env bash

{ # make sure that the entire script is downloaded #
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    
    install_docker_ce() {
        # Ensure your system is updated.
        sudo apt-get -y update
        # sudo apt-get -y policy docker-ce
        #sudo apt-get install docker-ce docker-ce-cli containerd.io 
        # sudo apt install docker.io
        sudo apt install -y docker.io

        info "Adding User ${USER} to the docker group"
        sudo usermod -aG docker ${USER}
    }

    install_docker_compose() {
        # Install docker-compose
        sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
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

    }

    main $1

}
