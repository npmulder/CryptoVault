using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Serilog;

namespace CryptoVault.Api
{
  [ExcludeFromCodeCoverage]
  public class Program
  {
    public static void Main(string[] args)
    {
      var configuration = new ConfigurationBuilder()
        .AddJsonFile("appsettings.json")
        .Build();

      Log.Logger = new LoggerConfiguration()
        .ReadFrom.Configuration(configuration)
        .CreateLogger();

      try
      {
        Log.Information("Application starting up.");
        CreateHostBuilder(args).Build().Run();
      }
      catch (Exception ex)
      {
        Log.Fatal(ex, "Application failed to start.");
        throw;
      }
      finally
      {
        Log.CloseAndFlush();
      }


    }

    public static IHostBuilder CreateHostBuilder(string[] args) =>
        Host.CreateDefaultBuilder(args)
            .UseSerilog()
            .ConfigureWebHostDefaults(webBuilder =>
            {
              webBuilder.UseStartup<Startup>();
            });
  }
}
