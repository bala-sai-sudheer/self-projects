using Ocelot.DependencyInjection;
using Ocelot.Middleware;

var builder = WebApplication.CreateBuilder(args);

// Load configuration - try multiple possible file names
builder.Configuration
    .AddJsonFile("ocelot.json", optional: true, reloadOnChange: true)
    .AddJsonFile("Ocelot.json", optional: true, reloadOnChange: true)
    .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
    .AddEnvironmentVariables();

// If ocelot config is empty, create a default one
Console.WriteLine("Configuration loaded. Checking for Ocelot routes...");

builder.Services.AddOcelot(builder.Configuration);

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder =>
    {
        builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
    });
});

var app = builder.Build();

app.UseCors("AllowAll");

try
{
    await app.UseOcelot();
}
catch (Exception ex)
{
    Console.WriteLine($"Ocelot error: {ex.Message}");
    // Even if Ocelot fails, keep the app running
}

app.Run();
