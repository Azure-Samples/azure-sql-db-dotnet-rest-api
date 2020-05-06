#!/bin/bash

set -euo pipefail

# Make sure these values are correct for your environment
resourceGroup="dm-api-02"
appName="dm-api-02"
location="WestUS2" 

# Change this if you are using your own github repository
gitSource="https://github.com/Azure-Samples/azure-sql-db-dotnet-rest-api.git"

# Make sure connection string variable is set
if [[ -z "${ConnectionStrings__DefaultConnection:-}" ]]; then
	echo "Please export Azure SQL connection string:";
    echo "export ConnectionStrings__DefaultConnection=\"your-connection-string-here\"";
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
    --runtime "DOTNETCORE|3.1" \
    --deployment-source-url $gitSource \
    --deployment-source-branch master

echo "Configuring Connection String...";
az webapp config connection-string set \
    -g $resourceGroup \
    -n $appName \
    --settings DefaultConnection=$ConnectionStrings__DefaultConnection \
    --connection-string-type=SQLAzure

echo "Done."