#!/bin/bash
source .env


echoStatus () {
    echo ""
    printf '=%.0s' {1..80}
    echo ""
    printf "\n                     $1 \n"
    echo ""
    printf '=%.0s' {1..80}
    echo ""
}


generateAccessToken(){
  echoStatus "Generating admin access token"
  $MATTERMOST_INSTALL_DIR/bin/mmctl token generate admin matterhelp --json --local
}

setupAdminUser(){
  echoStatus "Adding Admin user."
  $MATTERMOST_INSTALL_DIR/bin/mmctl user create --email admin@example.com --username admin --password TestPassword123! --system-admin --email-verified --json --local
}

# This needs to stay at the bottom of the script after the functions have been declared.
if declare -f "$1" > /dev/null
then
  # call arguments verbatim
  "$@"
else
  # Show a helpful error
  echo "'$1' is not a known function name" >&2
  exit 1
fi
