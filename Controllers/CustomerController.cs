using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Text.Json;
using Microsoft.Extensions.Configuration;

namespace AzureSamples.AzureSQL.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CustomerController : ControllerQuery
    {
        public CustomerController(IConfiguration config, ILogger<CustomersController> logger):
            base(config, logger) {}

        [HttpGet("{customerId}")]
        public async Task<JsonElement> Get(int customerId)
        {
            return await this.Query("get", this.GetType(), customerId);
        }

        [HttpPut]
        public async Task<JsonElement> Put([FromBody]JsonElement payload)
        {
            return await this.Query("put", this.GetType(), payload: payload);
        }

        [HttpPatch("{customerId}")]
        public async Task<JsonElement> Patch([FromBody]JsonElement payload, int customerId)
        {
            return await this.Query("patch", this.GetType(), customerId, payload);
        }

        [HttpDelete("{customerId}")]
        public async Task<JsonElement> Delete(int customerId)
        {
            return await this.Query("delete", this.GetType(), customerId);
        }
    }
}
