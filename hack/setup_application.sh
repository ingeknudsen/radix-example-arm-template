#!/bin/bash

# PRECONDITIONS
#
# It is assumed that:
# 1. that you have setup a personal github access token (https://github.com/settings/tokens)
#    with admin:repo_hook scope and set up the environment
#    variables:
#    GH_USERNAME=<github user name>
#    GITHUB_PAT_TOKEN=<token generated>

REPOSITORY_PATH="equinor/radix-example-arm-template"
REPOSITORY="https://github.com/$REPOSITORY_PATH"
OWNER="iknu@equinor.com"
SHARED_SECRET=NotApplicable

echo "Create application"
PUBLIC_KEY=$(rx create application \
    --from-config \
    --cluster iknu-test-machine-user \
    --repository $REPOSITORY \
    --owner $OWNER \
    --shared-secret $SHARED_SECRET 2>&1)

echo "Add deploy key"
PAYLOAD='{"title":"iknu-test-cluster", "key": "'$PUBLIC_KEY'" }'
RESPONSE=$(curl -X POST -H "Content-Type: application/json" -u ${GH_USERNAME}:${GITHUB_PAT_TOKEN} \
    https://api.github.com/repos/$REPOSITORY_PATH/keys \
    -d "$PAYLOAD" 2>&1)

echo ""
read -p "Delete application again? (Y/n) " -n 1 -r
if [[ "$REPLY" =~ (N|n) ]]; then
    echo ""
    echo "Chicken!"
    exit 1
fi

rx delete application \
    --from-config \
    --context playground
