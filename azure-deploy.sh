#!/bin/bash

set -euo pipefail

# Make sure these values are correct for your environment
resourceGroup="dm-api-02"
appName="dm-api-02"
location="WestUS2" 

# Change this if you are using your own github repository
gitSource="https://github.com/Azure-Samples/azure-sql-db-dotnet-rest-api.git"


# Azure configuration
FILE=".env"
if [[ -f $FILE ]]; then
	echo "loading from .env" 
    export $(egrep . $FILE | xargs -n1)
else
	cat << EOF > .env
ConnectionStrings__ReadWriteConnection="Server=.database.windows.net;Database=;UID=;PWD="
ConnectionStrings__ReadOnlyConnection="Server=.database.windows.net;Database=;UID=;PWD="
EOF
	echo "Enviroment file not detected."
	echo "Please configure values for your environment in the created .env file"
	echo "and run the script again."
	echo "ConnectionStrings__ReadWriteConnection: Azure SQL Connection String used for Read/Write workloads"
	echo "ConnectionStrings__ReadOnlyConnection: Azure SQL Connection String used for Read-Only workloads"
	exit 1
fi

# Make sure connection string variable is set
if [[ -z "${ConnectionStrings__ReadWriteConnection:-}" ]]; then
    echo "ConnectionStrings__ReadWriteConnection not found."
	exit 1;
fi

if [[ -z "${ConnectionStrings__ReadOnlyConnection:-}" ]]; then
	echo "ConnectionStrings__ReadOnlyConnection not found."
	exit 1;
fi

echo "Creating Resource Group...";
az group create \
    -n $resourceGroup \
    -l $location

echo "Creating Application Service Plan...";
az appservice plan create \
    -g $resourceGroup \
    -n "windows-plan" \
    --sku B1     

echo "Creating Web Application...";
az webapp create \
    -g $resourceGroup \
    -n $appName \
    --plan "windows-plan" \
    --deployment-source-url $gitSource \
    --deployment-source-branch perftest

echo "Configuring Connection String...";
az webapp config connection-string set \
    -g $resourceGroup \
    -n $appName \
    --settings ReadWriteConnection=$ConnectionStrings__ReadWriteConnection \
    --connection-string-type=SQLAzure

az webapp config connection-string set \
    -g $resourceGroup \
    -n $appName \
    --settings ReadOnlyConnection=$ConnectionStrings__ReadOnlyConnection \
    --connection-string-type=SQLAzure

echo "Done."