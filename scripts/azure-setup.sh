#!/usr/bin/env bash

set -ueo pipefail

DNS_PREFIX="ngcloud"
REGION="uksouth" #ukwest westus westeurope eastus
SUBSCRIPTION=$(az account list --output tsv | cut -f2)
createClusterScript() {
  echo "About to create cluster with subscription id $SUBSCRIPTION"
}

case "${1:-"create"}" in
  "create")
    createClusterScript
  ;;
esac
