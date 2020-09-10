#!/bin/bash
{
	DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

	sanitize() {
		if [[ -z "$@" ]]; then
			# Error with instruction
			{
				echo
				echo "[i] Help: Available options"
				echo
				echo "  --domains \"[LIST]\"	list of domains (require: quotes and 1 space between each domain)"
				echo "  --email [STRING]		valid E-mail address - Default info@liveobjects.online"
				echo "  --data-path [STRING]	path to Certbot folder - Default ./certbot"
				echo "  --staging [NUMBER]		set to 1 if you're testing your setup (to avoid hitting request limits) - Default 1"
				echo
			}
			exit
		fi

		clear
		
		# Set Defaults
		email="info@liveobjects.online"
		data_path="./webserver/certbot"
		staging="1"

		# Define required options
		while [[ -n "$1" ]]; do
			case "$1" in
			--domains)
				# Check option value
				if ! [[ -z "$2" ]]; then
					domains=("$2")
					regex="([^www.].+)"
				else
					# Error
					echo
					echo "[x] Error: Value for option $1 is required!"
					echo
					exit
					clear
				fi
				shift
				;;
			--email)
				# Check option value
				if ! [[ -z "$2" ]]; then
					# Adding a valid address is strongly recommended
					email="$2"
				fi
				shift
				;;
			--data-path)
				# Check option value
				if ! [[ -z "$2" ]]; then
					# Path to Certbot folder
					data_path=$2
				fi
				shift
				;;
			--staging)
				# Check option value
				if ! [[ -z "$2" ]]; then
					# Set to 1 if you're testing your setup to avoid hitting request limits
					staging=$2
				fi
				shift
				;;
			*)
				# Error
				echo
				echo "[x] Error: Unknown option $1 with value $2..."
				echo
				exit
				clear
				shift
				;;
			esac
			shift
		done

		echo 
		echo "--domains   : $domains "
		echo "--email     : $email "
		echo "--data-path : $data_path "
		echo "--staging   : $staging "
		echo 

	}

	existingCert() {
				# Menu for existing folder
		for domain in ${domains[@]}; do

			domain_name=$(echo $domain | grep -o -P $regex)

			if [ -d "$data_path/conf/live/$domain_name" ]; then
				echo
				echo "[i] Existing data found for some domains..."
				echo

				PS3='Your choice: '

				select opt in "Skip registered domains" "Remove registered domains and continue" "Remove registered domains and exit" "Exit"; do
					echo
					echo
					case $REPLY in
					1)
						echo " Installed certificates will be skipped" echo
						echo
						break
						;;
					2)
						echo " Old certificates removed"
						echo
						echo
						rm -rf "$data_path"
						break
						;;
					3)
						echo " Old certificates removed"
						echo
						rm -rf "$data_path"
						echo " Exit..."
						echo
						echo
						sleep 2
						clear
						exit
						;;
					4)
						echo " Exit..."
						echo
						echo
						sleep 0.5
						clear
						exit
						;;
					*) echo "invalid option $REPLY" ;;
					esac
				done
				break
			fi
		done

	}

	runAsRootCheck() {
		echo "Run as Root ? "
		# root required
		# if [ "$EUID" -ne 0 ]; then
		#	echo; echo "[✘] Error: Please run $0 as root!"; echo;
		#	exit
		# fi
	}
	createDummyCertificate() {
				# Dummy certificate
		for domain in ${!domains[*]}; do
			domain_set=(${domains[$domain]})
			domain_name=$(echo ${domain_set[0]} | grep -o -P $regex)

			mkdir -p "$data_path/conf/live/$domain_name"

			if [ ! -e "$data_path/conf/live/$domain_name/cert.pem" ]; then
				echo
				echo "[i] Creating dummy certificate for $domain_name domain..."
				echo

				path="/etc/letsencrypt/live/$domain_name"
				docker-compose -f docker-compose-certs.yml run --rm --entrypoint "openssl req -x509 -nodes -newkey rsa:1024 \
	-days 1 -keyout '$path/privkey.pem' -out '$path/fullchain.pem' -subj '/CN=localhost'" certbot
			fi
		done

	}

	downloadTLSParameters() {
		mkdir -p "$data_path"

		if [ ! -e "$data_path/conf/options-ssl-nginx.conf" ] && [ ! -e "$data_path/conf/ssl-dhparams.pem" ]; then
			echo
			echo "[i] Downloading recommended TLS parameters..."
			echo

			mkdir -p "$data_path/conf"

			curl -s $options_ssl_nginx >"$data_path/conf/options-ssl-nginx.conf"
			curl -s $ssl_dhparams >"$data_path/conf/ssl-dhparams.pem"
		fi

	}

	createLetsEncryptCertificate() {
				# Enable staging mode if needed
		if [ $staging != "0" ]; then staging_arg="--staging"; fi

		for domain in ${!domains[*]}; do
			domain_set=(${domains[$domain]})
			domain_name=$(echo ${domain_set[0]} | grep -o -P $regex)

			if [ -e "$data_path/conf/live/$domain_name/cert.pem" ]; then
				echo
				echo "Skipping $domain_name domain"
				echo
			else
				echo
				echo "[i] Deleting dummy certificate for $domain_name domain ..."
				echo

				rm -rf "$data_path/conf/live/$domain_name"

				echo
				echo "[i] Requesting Let's Encrypt certificate for $domain_name domain ..."
				echo

				# Join $domains to -d args
				domain_args=""
				for domain in "${domain_set[@]}"; do
					domain_args="$domain_args -d $domain"
				done

				mkdir -p "$data_path/www"

				docker-compose -f docker-compose-certs.yml run --rm --entrypoint "certbot certonly --webroot -w /var/www/certbot --cert-name $domain_name $domain_args \
		$staging_arg $email_arg --rsa-key-size $rsa_key_size --agree-tos --force-renewal --non-interactive" certbot
			fi
		done

	}

	main() {

		sanitize "$@"

		# Check for granted options

		# Set RSA key size
		rsa_key_size=4096
		# Recommended TLS parameters
		options_ssl_nginx="https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf"
		ssl_dhparams="https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem"

		runAsRootCheck 

		existingCert

		downloadTLSParameters

		createDummyCertificate 

		echo
		echo "[i] Starting nginx..."
		echo

		# Restarting for case if nginx container is already started
		docker-compose -f docker-compose-certs.yml up -d nginx && docker-compose -f docker-compose-certs.yml restart nginx

		# Select appropriate email arg
		case "$email" in
		"") email_arg="--register-unsafely-without-email" ;;
		*) email_arg="--email $email" ;;
		esac

		createLetsEncryptCertificate

	}

	main "$@"
}
