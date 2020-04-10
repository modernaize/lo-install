
info() {
    # 32 Green
  #  echo ">>> ${1}"
    FRED="\033[31m" 
    echo -e "\033[1m\033[32m>>>\033[0m\033[0m ${1}"

}

error() {
    # 31 Red
    echo -e "\033[1m\033[31m!!!\033[0m\033[0m ${1}"
}

debug() {
    # 94 Blue
    if [[ "$DEBUG" =~ ^(TRUE|true)$ ]]; then
      echo -e "\033[1m\033[94m###\033[0m\033[0m ${1}"
    fi
}

detect_shell() {

    if [ -n "$ZSH_VERSION" ]; then
      debug "ZSH Shell"
    elif [ -n "$BASH_VERSION" ]; then
      debug "Bash Shell"
    else
      debug "Different Shell"
    fi

}

check_installed_programs() {
    info "Executing check_installed_programs"

    for i in gcloud jq awk grep; do
        # can I use al awkso test ????
        if ! [ -x "$(command -v ${i})" ]; then
            error "Error: ${i} is not installed." >&2
            exit 1
        fi
    done
}
