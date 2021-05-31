using System;
using Xunit;
using Microsoft.Extensions.Logging.Abstractions;

namespace CryptoVault.Api.IntegrationTests
{
    public class WeatherForecastControllerTests
    {
        [Fact]
        public void ShouldReturnAListofValues()
        {
            //Given
            var logger = new NullLogger<Controllers.WeatherForecastController>();
            var service = new Controllers.WeatherForecastController(logger);
        
            //When
            var result = service.Get();
            
        
            //Then
            Assert.NotNull(result);
        }
    }

}