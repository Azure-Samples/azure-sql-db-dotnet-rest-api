using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Text.Json;
using System.Data;
using Microsoft.Data.SqlClient;
using Dapper;
using Microsoft.Extensions.Configuration;

namespace AzureSamples.AzureSQL.Controllers
{
    public class ControllerQuery : ControllerBase
    {
        private readonly ILogger<CustomersController> _logger;
        private readonly IConfiguration _config;

        public ControllerQuery(IConfiguration config, ILogger<CustomersController> logger)
        {
            _logger = logger;
            _config = config;
        }

        protected async Task<JsonDocument> Query(string verb, Type entity)
        {
            JsonDocument result = null;

            if (!(new string[] {"get", "put", "patch", "delete"}).Contains(verb.ToLower()))
            {
                throw new ArgumentException($"verb '{verb}' not supported", nameof(verb));
            }

            string entityName = entity.Name.Replace("Controller", string.Empty).ToLower();
            string procedure = $"web.{verb}_{entityName}";
            _logger.LogDebug($"Executing {procedure}");

            using(var conn = new SqlConnection(_config.GetConnectionString("DefaultConnection"))) {
                var qr = await conn.ExecuteScalarAsync<string>(procedure, commandType: CommandType.StoredProcedure);
                result = JsonDocument.Parse(qr);
            };

            if (result == null) 
                result = JsonDocument.Parse("[]");
                        
            return result;
        }
    }
}
