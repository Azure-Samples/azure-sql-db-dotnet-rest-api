#!/bin/bash

set -euo pipefail

# Make sure these values are correct for your environment
resourceGroup="azure-sql-db-dotnet-rest-api"
appName="azure-sql-db-dotnet-rest-api"
location="WestUS2" 

# Change this if you are using your own github repository
gitSource="https://github.com/yorek/azure-sql-db-dotnet-rest-api.git"

az group create \
    -n $resourceGroup \
    -l $location

az appservice plan create \
    -g $resourceGroup \
    -n "linux-plan" \
    --sku B1 \
    --is-linux

az webapp create \
    -g $resourceGroup \
    -n $appName \
    --plan "linux-plan" \
    --runtime "DOTNETCORE|3.0" \
    --deployment-source-url $gitSource \
    --deployment-source-branch master

az webapp config connection-string set \
    -g $resourceGroup \
    -n $appName \
    --settings DefaultConnection=$DefaultConnection \
    --connection-string-type=SQLAzure
