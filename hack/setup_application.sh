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

echo "Await reconciliation"
sleep 3

echo "Get machine user token"
SERVICE_ACCOUNT_TOKEN=$(rx get application \
    --from-config \
    --cluster iknu-test-machine-user | jq .registration.serviceAccountToken | tr -d '"')

echo "Copy the machine user token on the app admin page. The token is ${SERVICE_ACCOUNT_TOKEN:0:10}...."
echo "See https://github.community/t5/GitHub-Actions/Github-Apps-to-add-secrets/td-p/28259/page/2 for when "
echo "github secret can be modified through the API"

echo ""
read -p "Delete application again? (Y/n) " -n 1 -r
if [[ "$REPLY" =~ (N|n) ]]; then
    echo ""
    echo "Chicken!"
    exit 1
fi

rx delete application \
    --from-config \
    --cluster iknu-test-machine-user
