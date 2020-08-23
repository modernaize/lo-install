#!/usr/bin/env bash

{ # make sure that the entire script is downloaded #
    check_installed_programs() {

        for i in envsubst grep tr cut ; do
            if ! [ -x "$(command -v ${i})" ]; then
                error "Error: ${i} is not installed." >&2
                exit 1
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

        echo "Protocol : " $PROTOCOL

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
        if [[ $DEPLOYMENT == "ip" ]] ; then
            input_EXTERNAL_IP
            echo "External IP : " $EXTERNAL_IP
        fi

        ## ip, dns, ingress
        if [[ $DEPLOYMENT == "dns" ]] ; then
            input_DNS
            echo "DNS : " $DNS
        fi
                ## ip, dns, ingress
        if [[ $DEPLOYMENT == "ingress" ]] ; then
            input_INTERNAL_IP
            input_DNS

            echo "DNS : " $DEPLOY_URL
            echo "Internal IP : " $INTERNAL_IP
        fi

        echo "Deployment : " $DEPLOYMENT

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
                    echo
                    echo ' Invalid IP address ' $var1 
                    echo
                fi
            fi
        done
    }

    input_INTERNAL_IP() {

        while true; do
            echo
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
                    echo
                    echo ' Invalid IP address ' $var1 
                    echo
                fi
            fi
        done
        echo

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
    }

    input_ADVANCED_OPTIONS() {
        PS3='Do you want to enter more options ? '
        echo

        local _options=("y" "n")
        select YN in "${_options[@]}"
        do
            case $YN in
                "y")
                    break
                    ;;
                "n")
                    exit 1
                    ;;
                *) echo "invalid option $REPLY";;
            esac
        done

    }

    main() {

        check_installed_programs

        input_PROTOCOL
        input_DEPLOYMENT
        
        ## input_ADVANCED_OPTIONS

        export DEPLOYMENT=$DEPLOYMENT
        export PROTOCOL=$PROTOCOL
        export DEPLOY_URL=$DEPLOY_URL

        cp .env .env.before_config
        envsubst < .env.template > .env

    }

  main @1
}
