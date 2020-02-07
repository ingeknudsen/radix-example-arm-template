#!/bin/bash

# Required inputs:
# - BRANCH       :           Name of branch
# - SHA          :           commit id
# - GITHUB_USER  :           user
# - GITHUB_EMAIL :           email
# - GITHUB_REPO  :           ${{ github.repository }}
# - PERSONAL_ACCESS_TOKEN :  ${{ secrets.PRIVATE_TOKEN }}

CONFIG_BRANCH=master
PROD_BRANCH=release
COMPONENT=api

if [[ -z "$BRANCH" ]]; then
    echo "Please provide BRANCH" >&2
    exit 1
fi

if [[ -z "$SHA" ]]; then
    echo "Please provide SHA" >&2
    exit 1
fi

if [[ -z "$GITHUB_USER" ]]; then
    echo "Please provide GITHUB_USER" >&2
    exit 1
fi

if [[ -z "$GITHUB_EMAIL" ]]; then
    echo "Please provide GITHUB_EMAIL" >&2
    exit 1
fi

if [[ -z "$GITHUB_REPO" ]]; then
    echo "Please provide GITHUB_REPO" >&2
    exit 1
fi

if [[ -z "$PERSONAL_ACCESS_TOKEN" ]]; then
    echo "Please provide PERSONAL_ACCESS_TOKEN" >&2
    exit 1
fi

# Will only have dynamic tagging for prod environment
if [[ "$BRANCH" == "$PROD_BRANCH" ]]; then
    # Install pre-requisite
    python -m pip install --user ruamel.yaml
    python hack/modifyTag.py "${COMPONENT}" "${BRANCH}" "${BRANCH}-${SHA}"

    git config --global user.name '${GITHUB_USER}'
    git config --global user.email '{GITHUB_EMAIL}'
    git remote set-url origin https://x-access-token:${PERSONAL_ACCESS_TOKEN}@github.com/${GITHUB_REPO}
    git commit -am "${BRANCH}-${SHA}"
    git push origin HEAD:${CONFIG_BRANCH}
fi
