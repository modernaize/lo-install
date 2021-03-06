#!/usr/bin/env bash
export LC_CTYPE=C
export LANG=C
{ # make sure that the entire script is downloaded #
    VERSION="1.0.0"

    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

    # Shared code
    source ${DIR}/shared.sh

    check_installed_programs() {

        for i in docker-compose envsubst sed grep tr cut ; do
            if ! [ -x "$(command -v ${i})" ]; then
                error "Error: ${i} is not installed." >&2
                exit 1
            fi
        done
    }

    input_UPGRADE() {

        PS3='Is this an Upgrade deployment? : '
        echo

        local _options=("y" "n" "exit")
        select SELECT in "${_options[@]}"
        do
            case $SELECT in
                "y")
                    export FLYWAY_ENABLE="true"
                    export FLYWAY_BASELINE_ON_MIGRATE=true"true"
                    export UPGRADE=y
                    break
                    ;;
                "n")
                    export FLYWAY_ENABLE="false"
                    export FLYWAY_BASELINE_ON_MIGRATE=true"false"
                    export UPGRADE=n
                    break
                    ;;
                "exit")
                    exit 1
                    ;;
                *) error "invalid option $REPLY";;
            esac
        done

        info "Upgrade : ${UPGRADE}"

    }

    input_UPGRADE_VERSION() {

        PS3='Verion to upgrade from: '
        echo

        local _options=("2020.2.x" "exit")
        select SELECT in "${_options[@]}"
        do
            case $SELECT in
                "2020.2.x")
                    export UPGRADE_VERSION=2020.2.x
                    break
                    ;;
                "exit")
                    exit 1
                    ;;
                *) error "invalid option $REPLY";;
            esac
        done

        info "Upgrade from version : ${UPGRADE_VERSION}"

    }

    input_DEPLOYMENT_PORT() {

        while true; do
            read -p "Enter the application port : or exit " port1

            if [[ $port1 == "exit" ]]
            then
                exit
            else
               export DEPLOYMENT_PORT=$port1
               info "Deployment port: ${DEPLOYMENT_PORT}"
                    break

            fi
        done
    }
    input_PROTOCOL() {

        PS3='Select the PROTOCOL for your deployment : '
        echo

        local _options=("https" "http" "exit")
        select SELECT in "${_options[@]}"
        do
            case $SELECT in
                "https")
                    export PROTOCOL=https
                    break
                    ;;
                "http")
                    export PROTOCOL=http
                    break
                    ;;
                "exit")
                    exit 1
                    ;;
                *) error "invalid option $REPLY";;
            esac
        done

        info "Protocol : ${PROTOCOL}" 

    }


    input_SYSMON() {

        PS3='Do you want to install the system monitoring tools : '
        echo

        local _options=("y" "n" "exit")
        select SELECT in "${_options[@]}"
        do
            case $SELECT in
                "y")
                    export SYSMON=y
                    break
                    ;;
                "n")
                    export SYSMON=n
                    break
                    ;;
                "exit")
                    exit 1
                    ;;
                *) error "invalid option $REPLY";;
            esac
        done
        
        info "System Monitoring Tools : ${SYSMON}" 

    }
    input_SUPPORT() {

        PS3='Do you want to install the remote support tools : '
        echo

        local _options=("y" "n" "exit")
        select SELECT in "${_options[@]}"
        do
            case $SELECT in
                "y")
                    export SUPPORT=y
                    break
                    ;;
                "n")
                    export SUPPORT=n
                    break
                    ;;
                "exit")
                    exit 1
                    ;;
                *) error "invalid option $REPLY";;
            esac
        done
        
        info "Support Tools : ${SUPPORT}" 

    }

    input_INGRESS_PROTOCOL() {

        PS3='Do you want to use INGRESS with SSL '
        echo

        local _options=("y" "n" "exit")
        select SELECT in "${_options[@]}"
        do
            case $SELECT in
                "y")
                    export INGRESS_SSL=y
                    export PROTOCOL_INGRESS=https
                    input_CERTBOT_DOCKER
                    break
                    ;;
                "n")
                    export INGRESS_SSL=n
                    export PROTOCOL_INGRESS=http
                    break
                    ;;
                "exit")
                    exit 1
                    ;;
                *) error "invalid option $REPLY";;
            esac
        done

        info "INGRESS with SSL certificate : ${INGRESS_SSL}" 
        info "INGRESS Protocol : ${PROTOCOL_INGRESS}" 

    }

    input_NGINX() {

        PS3='Do you want to run NGINX as a docker container : '
        echo

        local _options=("y" "n" "exit")
        select SELECT in "${_options[@]}"
        do
            case $SELECT in
                "y")
                    export NGINX_DOCKER=y
                    break
                    ;;
                "n")
                    export NGINX_DOCKER=n
                    break
                    ;;
                "exit")
                    exit 1
                    ;;
                *) error "invalid option $REPLY";;
            esac
        done

    }

    input_CERTBOT_DOCKER() {

        PS3='Do you want to run CERTBOT to maintain your LETSENCYPT certificate : '
        echo

        local _options=("y" "n" "exit")
        select SELECT in "${_options[@]}"
        do
            case $SELECT in
                "y")
                    export CERTBOT_DOCKER=y
                    break
                    ;;
                "n")
                    export CERTBOT_DOCKER=n
                    break
                    ;;
                "exit")
                    exit 1
                    ;;
                *) error "invalid option $REPLY";;
            esac
        done

    }

    input_DEPLOYMENT() {

        PS3='Select the Type of Deployment for your deployment : '
        echo

        local _options=("ip" "dns" "ingress" "exit")
        select SELECT in "${_options[@]}"
        do
            case $SELECT in
                "ip")
                    export DEPLOYMENT=ip
                    break
                    ;;
                "dns")
                    export DEPLOYMENT=dns
                    break
                    ;;
                "ingress")
                    export DEPLOYMENT=ingress
                    break
                    ;;
                "exit")
                    exit 1
                    ;;
                *) error "invalid option $REPLY";;
            esac
        done

        ## ip, dns, ingress
        if [[ ${DEPLOYMENT} == "ip" ]] ; then
            input_EXTERNAL_IP
            info "External IP : $EXTERNAL_IP" 
        fi

        ## ip, dns, ingress
        if [[ ${DEPLOYMENT} == "dns" ]] ; then
            input_DNS
            
        fi
                ## ip, dns, ingress
        if [[ ${DEPLOYMENT} == "ingress" ]] ; then
            # input_INTERNAL_IP
            input_DNS

            info "DNS : ${DEPLOY_URL}" 
        fi

        info "Deployment :${DEPLOYMENT} "

    }

    checkIP(){
        ip=$1
        byte1=`echo "$ip"|xargs|cut -d "." -f1`
        byte2=`echo "$ip"|xargs|cut -d "." -f2`
        byte3=`echo "$ip"|xargs|cut -d "." -f3`
        byte4=`echo "$ip"|xargs|cut -d "." -f4`

        if [[  $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$  && $byte1 -ge 0 && $byte1 -le 255 && $byte2 -ge 0 && $byte2 -le 255 && $byte3 -ge 0 && $byte3 -le 255 && $byte4 -ge 0 && $byte4 -le 255 ]]
        then
            echo "valid"
        else
            echo "invalid" 
        fi
    }

    input_EXTERNAL_IP() {

        while true; do
            read -p "Enter the ip address where the deployment is reachable : or exit " var1

            if [[ $var1 == "exit" ]]
            then
                exit
            else
                result=$(checkIP $var1)
                if [[ $result == "valid" ]]; then
                    DEPLOY_URL=$var1
                    EXTERNAL_IP=$var1
                    break
                else
                    error
                    error ' Invalid IP address ' $var1 
                    error
                fi
            fi
        done
    }

    input_INTERNAL_IP() {

        while true; do
            info
            read -p "Enter internal ip address: or EXIT " var1

            if [[ $var1 == "exit" ]]
            then
                exit
            else
                result=$(checkIP $var1)
                if [[ $result == "valid" ]]; then
                    INTERNAL_IP=$var1
                    break
                else
                    error
                    error ' Invalid IP address ' $var1 
                    error
                fi
            fi
        done
        info
        info "Internal IP : ${INTERNAL_IP}" 

    }

    input_DNS() {
        while true; do
            read -p "Enter DNS : or exit " var1

            if [[ $var1 == "exit" ]]
            then
                exit
            else
                ## result=$(checkIP $var1)
                ## if [[ $result == "valid" ]]; then
                    DEPLOY_URL=$var1
                    break
                # else
                #    echo
                #    echo ' Invalid IP address ' $var1 
                #    echo
                # fi
            fi
        done
        info
        info "DEPLOY_URL : $DEPLOY_URL" 
    }

    main() {

        check_installed_programs

        input_DEPLOYMENT

        if [[ "${DEPLOYMENT}" == "ip" ]]; then
            PROTOCOL="http"
        fi

        if [[ "${DEPLOYMENT}" == "ingress" ]]; then
            PROTOCOL="http"
            input_INGRESS_PROTOCOL
        fi

        if [[ "${DEPLOYMENT}" == "dns" ]]; then
            # Can run with or w/o SSL
            input_PROTOCOL
        fi
        #input deployment port
        #input_DEPLOYMENT_PORT

        # chcek if it is for upgrade
        input_UPGRADE

        if [[ "${UPGRADE}" == "y" ]]; then
          # upgrade
          input_UPGRADE_VERSION
        fi

        input_SUPPORT
        input_SYSMON

        export DEPLOYMENT=${DEPLOYMENT}
        export PROTOCOL=${PROTOCOL}
        export DEPLOY_URL=${DEPLOY_URL}
        export FLYWAY_ENABLE=${FLYWAY_ENABLE}
        export FLYWAY_BASELINE_ON_MIGRATE=${FLYWAY_BASELINE_ON_MIGRATE}
        export UPGRADE_VERSION=${UPGRADE_VERSION}

        FILE=.env
        if [[ -f "$FILE" ]]; then
            info "Backup existing .env file"
            cp .env .env.before_config
        fi

        FILE=docker-compose.yml
        if [[ -f "$FILE" ]]; then
            info "Backup existing docker-compose file"
            cp docker-compose.yml docker-compose.yml.before_config
        fi

        info "Creating docker-compose environment"
        envsubst < ./templates/.env.template > .env
        cp ./templates/.docker-compose.template ./docker-compose.yml

        if [[ "${DEPLOYMENT}" == "ingress" ]]; then
            input_NGINX

            if [[ "${NGINX_DOCKER}" == "y" ]]; then
                info "Configure NGINX in docker "

                if [[ "${PROTOCOL_INGRESS}" == "http" ]]; then
                    readonly REPL_DEPLOY_URL=domain
                    cp ./templates/.nginx-docker.template ./nginx/sites/${DEPLOY_URL}
                    sed -i "s/${REPL_DEPLOY_URL}/${DEPLOY_URL}/g" ./nginx/sites/${DEPLOY_URL}
                else 
                    readonly REPL_DEPLOY_URL=domain
                    cp ./templates/.nginx-docker-ssl.template ./nginx/sites/${DEPLOY_URL}
                    sed -i "s/${REPL_DEPLOY_URL}/${DEPLOY_URL}/g" ./nginx/sites/${DEPLOY_URL}
                fi

                cat ./templates/.docker-compose-nginx.template >> ./docker-compose.yml
                
                if [[ "${CERTBOT_DOCKER}" == "y" ]]; then
                    cat ./templates/.docker-compose-certbot.template >> ./docker-compose.yml
                fi

            else
                info "Configure NGINX installed outside of the docker network"
                # DEPLOYMENT 
                input_INTERNAL_IP
                . "./nginx_create_site.sh" ${INTERNAL_IP} ${DEPLOY_URL}
            fi
        fi

        if [[ "${SUPPORT}" == "y" ]]; then
            info "Configure Support tools"
            cat ./templates/.docker-compose-portainer.template >> ./docker-compose.yml
        fi

        if [[ "${SYSMON}" == "y" ]]; then
            info "Configure System monitoring"
            cat ./templates/.docker-compose-sysmon.template >> ./docker-compose.yml
        fi


        if [[ "${UPGRADE}" == "y" ]]; then
            info "Configure System upgrade: "
            #may not need this. but envsubst does not seem to work unless we use a ${} veriable in the template
            sed -i'.org' 's/FLYWAY_ENABLE=false/FLYWAY_ENABLE=true/' .env
            sed -i'.org' 's/FLYWAY_BASELINE_ON_MIGRATE=false/FLYWAY_BASELINE_ON_MIGRATE=true/' .env
            sed -i'.org' "s/UPGRADE_VERSION=0.0.0/UPGRADE_VERSION=$UPGRADE_VERSION/" .env
            rm .env.org

        fi

        #sed -i'.org' "s/DEPLOYMENT_PORT=443/DEPLOYMENT_PORT=$DEPLOYMENT_PORT/" .env
        #rm .env.org
    }

  main @1
  
}
