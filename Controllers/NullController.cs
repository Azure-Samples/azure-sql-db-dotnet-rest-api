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
    public class NullController : ControllerBase
    {
        [HttpGet]
        public string Get()
        {
            var dummy = new {
                TimeStamp = DateTime.UtcNow
            };

            return JsonSerializer.Serialize(dummy);
        }
    }
}
