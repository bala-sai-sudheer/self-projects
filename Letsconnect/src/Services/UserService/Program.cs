using LetsConnect.Common.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

// Configure Serilog
Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateLogger();
builder.Host.UseSerilog();

try
{
    // Add services
    builder.Services.AddControllers();
    builder.Services.AddEndpointsApiExplorer();
    builder.Services.AddSwaggerGen();

    // Database with retry logic
    var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") 
        ?? "Server=letsconnect-mysql;Database=LetsConnectDB;User=root;Password=YourPassword123!;";
    
    Log.Information("Using connection string: {Connection}", connectionString);
    
    builder.Services.AddDbContext<LetsConnectDbContext>(options =>
        options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString),
            mySqlOptions => mySqlOptions.EnableRetryOnFailure(
                maxRetryCount: 5,
                maxRetryDelay: TimeSpan.FromSeconds(10),
                errorNumbersToAdd: null)));

    // JWT Authentication
    var jwtKey = builder.Configuration["Jwt:Key"] ?? "YourSuperSecretKeyThatIsAtLeast32BytesLong!@#$%^&*()";
    
    builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
        .AddJwtBearer(options =>
        {
            options.TokenValidationParameters = new TokenValidationParameters
            {
                ValidateIssuer = true,
                ValidateAudience = true,
                ValidateLifetime = true,
                ValidateIssuerSigningKey = true,
                ValidIssuer = builder.Configuration["Jwt:Issuer"] ?? "LetsConnect",
                ValidAudience = builder.Configuration["Jwt:Audience"] ?? "LetsConnect",
                IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey))
            };
        });

    // Redis Cache
    var redisConnection = builder.Configuration.GetConnectionString("Redis") ?? "letsconnect-redis:6379,password=YourRedisPassword";
    builder.Services.AddStackExchangeRedisCache(options =>
    {
        options.Configuration = redisConnection;
    });

    // AutoMapper
    builder.Services.AddAutoMapper(typeof(Program));

    // CORS
    builder.Services.AddCors(options =>
    {
        options.AddPolicy("AllowAll", builder =>
        {
            builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
        });
    });

    var app = builder.Build();

    if (app.Environment.IsDevelopment() || true) // Enable Swagger in all environments for testing
    {
        app.UseSwagger();
        app.UseSwaggerUI();
    }

    app.UseCors("AllowAll");
    app.UseAuthentication();
    app.UseAuthorization();
    app.MapControllers();

    Log.Information("User Service starting on http://+:80");
    app.Run();
}
catch (Exception ex)
{
    Log.Fatal(ex, "User Service failed to start");
    throw;
}
finally
{
    Log.CloseAndFlush();
}
