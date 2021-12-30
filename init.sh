#!/usr/bin/env bash

ENV_FILE="./languages.env"
SUPPORT_OS="Ubuntu 20.04"

getDependencies() {
    apt-get install curl
    
    # install frep to generate scripts from tmpl files
    curl -fSL https://github.com/subchen/frep/releases/download/v1.3.12/frep-1.3.12-linux-amd64 -o /usr/local/bin/frep
    chmod +x /usr/local/bin/frep
}

verifyEnv() {
    # Check if OS is Ubuntu
    [[ ! -f "/etc/issue" ]] && { echo "Support only Linux-$SUPPORT_OS"; exit; }

    # Check if Ubuntu version is supported
    OS=$(cat /etc/issue)
    [[ ! $OS == *"$SUPPORT_OS"* ]] && { echo "You are on $OS, Support only $SUPPORT_OS"; exit; }

    # Check if Env File exists
    [[ ! -f "$ENV_FILE" ]] && { echo "$ENV_FILE does not exist, try create one by the example file."; exit; }
}

generateTmpls() {
    source languages.env
    frep ./golang/prerequirements.sh.tmpl --overwrite
}

init() {
    echo "Verify the system environment..."
    verifyEnv

    echo "Download dependencies..."
    getDependencies

    echo "generateScripts..."
    generateTmpls
}

if [[ $# -eq 0 ]] ; then
    echo 'Please provide one of the arguments (example: bash init.sh init):
    1 > init ( sudo bash init.sh init)
    2 > verify (bash init.sh verify)
    3 > getdep (bash init.sh getdep)
    4 > gentmpls (bash init.sh gentmpls)'
elif [[ $1 == init ]]; then
    init && echo "Finished Env Init!"
elif [[ $1 == verify ]]; then
    verify && echo "Finished Verification!"
elif [[ $1 == getdep ]]; then
    getDependencies && echo "Finished getting dependencies!"
elif [[ $1 == gentmpls ]]; then
    generateTmpls && echo "Finished templates generating!"
fi

