---
page_type: sample
languages:
- tsql
- sql
- aspx-csharp
products:
- azure
- dotnet
- aspnet
- dotnet-core
- aspnet-core
- azure-api-apps
- vs-code
- azure-sql-database
description: "Creating a modern REST API with .NET Core and Azure SQL, using Dapper and Visual Studio Code"
urlFragment: "azure-sql-db-dotnet-rest-api"
---

# Creating a REST API with .NET Core and Azure SQL

![License](https://img.shields.io/badge/license-MIT-green.svg)

<!-- 
Guidelines on README format: https://review.docs.microsoft.com/help/onboard/admin/samples/concepts/readme-template?branch=master

Guidance on onboarding samples to docs.microsoft.com/samples: https://review.docs.microsoft.com/help/onboard/admin/samples/process/onboarding?branch=master

Taxonomies for products and languages: https://review.docs.microsoft.com/new-hope/information-architecture/metadata/taxonomies?branch=master
-->

Thanks to native JSON support, creating a REST API with Azure SQL and .NET Core is really a matter of a few lines of code:

```csharp
    var qr = await conn.ExecuteScalarAsync<string>(
        sql: procedure,
        param: parameters,
        commandType: CommandType.StoredProcedure
    );
    
    var result = JsonDocument.Parse(qr);
```

This is possible thanks to [Azure SQL native support to JSON](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-json-features) format and the MicroORM [Dapper](https://medium.com/dapper-net/get-started-with-dapper-net-591592c335aa) that removes all the plumbing code and returns not tables and columns but a fully deserialized object. Object that can be a POCO object or just JSON for maximum flexibilty.

## Install Sample Database

In order to run this sample, the WideWorldImporters database is needed. Install WideWorldImporters sample database:

[Restore WideWorldImporters Database](https://github.com/yorek/azure-sql-db-samples#restore-wideworldimporters-database)

## Add Database Objects

Once the sample database has been installed, you need to add some stored procedures that will be called from .NET. The SQL code is available here:

`./SQL/WideWorldImportersUpdates.sql`

If you need any help in executing the SQL script, you can find a Quickstart here: [Quickstart: Use Azure Data Studio to connect and query Azure SQL database](https://docs.microsoft.com/en-us/sql/azure-data-studio/quickstart-sql-database)

## Run sample locally

Make sure you have [.NET Core 3.0](https://dotnet.microsoft.com/download) SDK installed on your machine. Clone this repo in a directory on your computer and then configure the connection string in `appsettings.json`.

If you don't want to save the connection string in the `appsettings.json` file for security reasons, you can just set it using an environment variable:

Linux:

```bash
export ConnectionStrings__DefaultConnection="<your-connection-string>"
```

Windows (Powershell):

```powershell
$Env:ConnectionStrings__DefaultConnection="<your-connection-string>"
```

Your connection string is something like:

```text
SERVER=<your-server-name>.database.windows.net;DATABASE=<your-database-name>;UID=DotNetWebApp;PWD=a987REALLY#$%TRONGpa44w0rd!
```

Just replace `<your-server-name>` and `<your-database-name>` with the correct values for your environment.

To run and test the REST API locally, just run

```bash
dotnet run
```

.NET will start the HTTP server and when everything is up and running you'll see something like

```text
Now listening on: https://localhost:5001
```

Using a REST Client (like [Insomnia](https://insomnia.rest/), [Postman](https://www.getpostman.com/) or curl), you can now call your API, for example:

```bash
curl -k -X GET http://localhosts:5001/customer/123
```

and you'll get info on Customer 123:

```json
[
    {
        "CustomerID": 123,
        "CustomerName": "Tailspin Toys (Roe Park, NY)",
        "PhoneNumber": "(212) 555-0100",
        "FaxNumber": "(212) 555-0101",
        "WebsiteURL": "http://www.tailspintoys.com/RoePark",
        "Delivery": {
            "AddressLine1": "Shop 219",
            "AddressLine2": "528 Persson Road",
            "PostalCode": "90775"
        }
    }
]
```

Check out more samples to test all implemented verbs here:

[cUrl Samples](./Sample-Usage.md)

## Deploy to Azure

Now that your REST API solution is ready, it's time to deploy it on Azure so that anyone can take advantage of it. A detailed article on how you can that that is here:

- [Create an ASP.NET Core app in App Service on Linux](https://docs.microsoft.com/en-us/azure/app-service/containers/quickstart-dotnetcore)

The only thing you have do in addition to what explained in the above article is to add the connection string to the Azure Web App configuration. Using AZ CLI, for example:

```bash
appName="azure-sql-db-dotnet-rest-api"
resourceGroup="my-resource-group"

az webapp config connection-string set \
    -g $resourceGroup \
    -n $appName \
    --settings DefaultConnection=$ConnectionStrings__DefaultConnection \
    --connection-string-type=SQLAzure
```

Just make sure you correctly set `$appName` and `$resourceGroup` to match your environment and also that the variable `$ConnectionStrings__DefaultConnection` as also been set, as mentioned in section "Run sample locally". 

An example of a full script that deploys the REST API is available here: `azure-deploy.sh`.

## Learn more

If you're new to .NET and want to learn more, there are a lot of tutorial available on the [Microsoft Learn](https://docs.microsoft.com/en-us/learn/browse/?products=dotnet) platform. You can start from here, for example:

- https://docs.microsoft.com/en-us/learn/modules/build-web-api-net-core/?view=aspnetcore-3.1

If you also want to learn more about Visual Studio Code, here's another resource:

[Using .NET Core in Visual Studio Code](https://code.visualstudio.com/docs/languages/dotnet)

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
