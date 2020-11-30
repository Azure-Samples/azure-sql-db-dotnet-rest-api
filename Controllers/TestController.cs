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
    [ApiController]
    [Route("[controller]")]
    public class TestController : ControllerBase
    {
        private readonly ILogger<TestController> _logger;
        private readonly IConfiguration _config;

        public TestController(IConfiguration config, ILogger<TestController> logger)
        {
            _logger = logger;
            _config = config;
        }
        
        [HttpGet]
        [Route("Test1")]
        public JsonElement Test1()
        {
            var dummy = new {
                TimeStamp = DateTime.UtcNow
            };

            var json = JsonSerializer.Serialize(dummy);

            return JsonDocument.Parse(json).RootElement;
        }

        [HttpGet]
        [Route("Test2")]
        public async Task<JsonElement> Test2()
        {
            var verb = "get";
            var connectionStringName = verb.ToLower() != "get" ? "ReadWriteConnection" : "ReadOnlyConnection";

            using(var conn = new SqlConnection(_config.GetConnectionString(connectionStringName))) {               
                var qr = await conn.QuerySingleAsync<string>(
                    sql: "SELECT SYSDATETIME() AS Dummy FOR JSON AUTO", 
                    commandType: CommandType.Text
                );
                
                return JsonDocument.Parse(qr).RootElement;
            };
        }
    }
}
