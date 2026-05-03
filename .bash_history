          "Host": "letsconnect-story-service",
          "Port": 80
        }
      ],
      "UpstreamPathTemplate": "/api/story/{everything}",
      "UpstreamHttpMethod": [ "GET", "POST", "PUT", "DELETE" ],
      "AuthenticationOptions": {
        "AuthenticationProviderKey": "GatewayKey",
        "AllowedScopes": []
      }
    },
    {
      "DownstreamPathTemplate": "/api/message/{everything}",
      "DownstreamScheme": "http",
      "DownstreamHostAndPorts": [
        {
          "Host": "letsconnect-message-service",
          "Port": 80
        }
      ],
      "UpstreamPathTemplate": "/api/message/{everything}",
      "UpstreamHttpMethod": [ "GET", "POST", "PUT", "DELETE" ],
      "AuthenticationOptions": {
        "AuthenticationProviderKey": "GatewayKey",
        "AllowedScopes": []
      }
    },
    {
      "DownstreamPathTemplate": "/api/notification/{everything}",
      "DownstreamScheme": "http",
      "DownstreamHostAndPorts": [
        {
          "Host": "letsconnect-notification-service",
          "Port": 80
        }
      ],
      "UpstreamPathTemplate": "/api/notification/{everything}",
      "UpstreamHttpMethod": [ "GET", "POST", "PUT", "DELETE" ],
      "AuthenticationOptions": {
        "AuthenticationProviderKey": "GatewayKey",
        "AllowedScopes": []
      }
    },
    {
      "DownstreamPathTemplate": "/api/search/{everything}",
      "DownstreamScheme": "http",
      "DownstreamHostAndPorts": [
        {
          "Host": "letsconnect-search-service",
          "Port": 80
        }
      ],
      "UpstreamPathTemplate": "/api/search/{everything}",
      "UpstreamHttpMethod": [ "GET", "POST", "PUT", "DELETE" ],
      "AuthenticationOptions": {
        "AuthenticationProviderKey": "GatewayKey",
        "AllowedScopes": []
      }
    }
  ],
  "GlobalConfiguration": {
    "BaseUrl": "http://localhost:5000"
  }
}
EOF

echo "✅ ocelot.json updated"
cd
cat > src/Gateway/LetsConnect.Gateway/Program.cs << 'EOF'
using Ocelot.DependencyInjection;
using Ocelot.Middleware;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add Ocelot configuration - load from both locations
builder.Configuration.AddJsonFile("ocelot.json", optional: true, reloadOnChange: true);
builder.Configuration.AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);
builder.Services.AddOcelot();

// JWT Authentication
var jwtKey = builder.Configuration["Jwt:Key"] ?? "YourSuperSecretKeyThatIsAtLeast32BytesLong!@#$%^&*()";
var jwtIssuer = builder.Configuration["Jwt:Issuer"] ?? "LetsConnect";
var jwtAudience = builder.Configuration["Jwt:Audience"] ?? "LetsConnect";

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer("GatewayKey", options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwtIssuer,
            ValidAudience = jwtAudience,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey))
        };
    });

// CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        builder =>
        {
            builder.AllowAnyOrigin()
                   .AllowAnyMethod()
                   .AllowAnyHeader();
        });
});

var app = builder.Build();

app.UseCors("AllowAll");
app.UseAuthentication();
app.UseAuthorization();
await app.UseOcelot();

app.Run();
EOF

echo "✅ Gateway Program.cs updated"
cd /root/Letsconnect
# Check if directory exists
ls -la src/Gateway/LetsConnect.Gateway/
# Check current Program.cs content
echo "=== Current Program.cs ==="
cat src/Gateway/LetsConnect.Gateway/Program.cs
# Now recreate it properly
cat > src/Gateway/LetsConnect.Gateway/Program.cs << 'PROGRAMEOF'
using Ocelot.DependencyInjection;
using Ocelot.Middleware;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add Ocelot configuration
builder.Configuration.AddJsonFile("ocelot.json", optional: false, reloadOnChange: true);
builder.Services.AddOcelot(builder.Configuration);

// JWT Authentication
var jwtKey = builder.Configuration["Jwt:Key"] ?? "YourSuperSecretKeyThatIsAtLeast32BytesLong!@#$%^&*()";
var jwtIssuer = builder.Configuration["Jwt:Issuer"] ?? "LetsConnect";
var jwtAudience = builder.Configuration["Jwt:Audience"] ?? "LetsConnect";

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer("GatewayKey", options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwtIssuer,
            ValidAudience = jwtAudience,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey))
        };
    });

// CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        builder =>
        {
            builder.AllowAnyOrigin()
                   .AllowAnyMethod()
                   .AllowAnyHeader();
        });
});

var app = builder.Build();

app.UseCors("AllowAll");
app.UseAuthentication();
app.UseAuthorization();
await app.UseOcelot();

app.Run();
PROGRAMEOF

echo "✅ Gateway Program.cs recreated"
# Verify the file
echo ""
echo "=== Verify Program.cs content ==="
cat src/Gateway/LetsConnect.Gateway/Program.cs
cd /root/Letsconnect
cat > src/Services/UserService/Program.cs << 'PROGRAMEOF'
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
PROGRAMEOF

echo "✅ User Service Program.cs recreated"
cd /root/Letsconnect
cat > src/Services/PostService/Program.cs << 'PROGRAMEOF'
using LetsConnect.Common.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateLogger();
builder.Host.UseSerilog();

try
{
    builder.Services.AddControllers();
    builder.Services.AddEndpointsApiExplorer();
    builder.Services.AddSwaggerGen();

    var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") 
        ?? "Server=letsconnect-mysql;Database=LetsConnectDB;User=root;Password=YourPassword123!;";
    
    builder.Services.AddDbContext<LetsConnectDbContext>(options =>
        options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString),
            mySqlOptions => mySqlOptions.EnableRetryOnFailure(5, TimeSpan.FromSeconds(10), null)));

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

    builder.Services.AddAutoMapper(typeof(Program));

    builder.Services.AddCors(options =>
    {
        options.AddPolicy("AllowAll", builder =>
        {
            builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
        });
    });

    var app = builder.Build();

    app.UseSwagger();
    app.UseSwaggerUI();
    app.UseCors("AllowAll");
    app.UseAuthentication();
    app.UseAuthorization();
    app.MapControllers();

    Log.Information("Post Service starting...");
    app.Run();
}
catch (Exception ex)
{
    Log.Fatal(ex, "Post Service failed to start");
    throw;
}
finally
{
    Log.CloseAndFlush();
}
PROGRAMEOF

echo "✅ Post Service Program.cs created"
cd /root/Letsconnect
cat > src/Services/StoryService/Program.cs << 'PROGRAMEOF'
using LetsConnect.Common.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateLogger();
builder.Host.UseSerilog();

try
{
    builder.Services.AddControllers();
    builder.Services.AddEndpointsApiExplorer();
    builder.Services.AddSwaggerGen();

    var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") 
        ?? "Server=letsconnect-mysql;Database=LetsConnectDB;User=root;Password=YourPassword123!;";
    
    builder.Services.AddDbContext<LetsConnectDbContext>(options =>
        options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString),
            mySqlOptions => mySqlOptions.EnableRetryOnFailure(5, TimeSpan.FromSeconds(10), null)));

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

    builder.Services.AddCors(options =>
    {
        options.AddPolicy("AllowAll", builder =>
        {
            builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
        });
    });

    var app = builder.Build();

    app.UseSwagger();
    app.UseSwaggerUI();
    app.UseCors("AllowAll");
    app.UseAuthentication();
    app.UseAuthorization();
    app.MapControllers();

    Log.Information("Story Service starting...");
    app.Run();
}
catch (Exception ex)
{
    Log.Fatal(ex, "Story Service failed to start");
    throw;
}
finally
{
    Log.CloseAndFlush();
}
PROGRAMEOF

echo "✅ Story Service Program.cs created"
cd
cd /root/Letsconnect
echo "=========================================="
echo "Stopping all services..."
echo "=========================================="
docker stop $(docker ps -aq --filter "name=letsconnect") 2>/dev/null
docker rm $(docker ps -aq --filter "name=letsconnect") 2>/dev/null
echo ""
echo "=========================================="
echo "Rebuilding all services..."
echo "=========================================="
docker build -t letsconnect-user-service:latest -f docker/user-service/Dockerfile . 2>&1 | tail -5
docker build -t letsconnect-post-service:latest -f docker/post-service/Dockerfile . 2>&1 | tail -5
docker build -t letsconnect-story-service:latest -f docker/story-service/Dockerfile . 2>&1 | tail -5
docker build -t letsconnect-message-service:latest -f docker/message-service/Dockerfile . 2>&1 | tail -5
docker build -t letsconnect-notification-service:latest -f docker/notification-service/Dockerfile . 2>&1 | tail -5
docker build -t letsconnect-search-service:latest -f docker/search-service/Dockerfile . 2>&1 | tail -5
docker build -t letsconnect-gateway:latest -f docker/gateway/Dockerfile . 2>&1 | tail -5
echo ""
echo "=========================================="
echo "Starting infrastructure..."
echo "=========================================="
docker start letsconnect-mysql letsconnect-redis 2>/dev/null ||   (docker run -d --name letsconnect-mysql --network letsconnect-network     -e MYSQL_ROOT_PASSWORD=YourPassword123! -e MYSQL_DATABASE=LetsConnectDB     -p 3306:3306 -v letsconnect-mysql-data:/var/lib/mysql mysql:8.0 &&    docker run -d --name letsconnect-redis --network letsconnect-network     -p 6379:6379 redis:alpine redis-server --requirepass YourRedisPassword)
echo "Waiting for MySQL and Redis (20 seconds)..."
sleep 20
echo ""
echo "=========================================="
echo "Starting microservices..."
echo "=========================================="
docker run -d --name letsconnect-user-service --network letsconnect-network   -e ConnectionStrings__Redis="letsconnect-redis:6379,password=YourRedisPassword"   -e ASPNETCORE_URLS="http://+:80" -p 5001:80 letsconnect-user-service:latest
sleep 5
docker run -d --name letsconnect-post-service --network letsconnect-network   -e ASPNETCORE_URLS="http://+:80" -p 5002:80 letsconnect-post-service:latest
docker run -d --name letsconnect-story-service --network letsconnect-network   -e ASPNETCORE_URLS="http://+:80" -p 5003:80 letsconnect-story-service:latest
docker run -d --name letsconnect-message-service --network letsconnect-network   -e ASPNETCORE_URLS="http://+:80" -p 5004:80 letsconnect-message-service:latest
docker run -d --name letsconnect-notification-service --network letsconnect-network   -e ASPNETCORE_URLS="http://+:80" -p 5005:80 letsconnect-notification-service:latest
docker run -d --name letsconnect-search-service --network letsconnect-network   -e ConnectionStrings__Redis="letsconnect-redis:6379,password=YourRedisPassword"   -e ASPNETCORE_URLS="http://+:80" -p 5006:80 letsconnect-search-service:latest
sleep 5
docker run -d --name letsconnect-gateway --network letsconnect-network   -e ASPNETCORE_URLS="http://+:80" -p 5000:80 letsconnect-gateway:latest
echo ""
echo "Waiting for services (15 seconds)..."
sleep 15
echo ""
echo "=========================================="
echo "Container Status:"
echo "=========================================="
docker ps --filter "name=letsconnect" --format "table {{.Names}}\t{{.Status}}"
echo ""
echo "=========================================="
echo "Testing API..."
echo "=========================================="
curl -s -X POST http://localhost:5001/api/auth/register   -H "Content-Type: application/json"   -d '{"username":"demo","email":"demo@test.com","password":"Demo@123","fullName":"Demo User"}'
cd /root/Letsconnect
# Create PostService AutoMapper profile if missing
cat > src/Services/PostService/MappingProfile.cs << 'EOF'
using AutoMapper;
using LetsConnect.Common.Models;

namespace PostService
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            // Add mappings here as needed
        }
    }
}
EOF

# Create Post DTOs
mkdir -p src/Services/PostService/Models
cat > src/Services/PostService/Models/PostDTOs.cs << 'EOF'
namespace PostService.Models
{
    public class PostDTO
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public string? Caption { get; set; }
        public string? Location { get; set; }
        public string? PostType { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    public class CreatePostDTO
    {
        public string? Caption { get; set; }
        public string? Location { get; set; }
        public List<IFormFile>? MediaFiles { get; set; }
    }

    public class UpdatePostDTO
    {
        public string? Caption { get; set; }
        public string? Location { get; set; }
    }

    public class CreateCommentDTO
    {
        public string? Content { get; set; }
        public Guid? ParentCommentId { get; set; }
    }

    public class CommentDTO
    {
        public Guid Id { get; set; }
        public string? Content { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
EOF

echo "✅ Post Service files created"
# Rebuild Post Service
docker build -t letsconnect-post-service:latest -f docker/post-service/Dockerfile . 2>&1 | tail -10
cd
cd /root/Letsconnect
# Create a complete PostService with minimal code to build successfully
cat > src/Services/PostService/PostService.csproj << 'EOF'
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
    <DockerDefaultTargetOS>Linux</DockerDefaultTargetOS>
    <RootNamespace>PostService</RootNamespace>
  </PropertyGroup>
  <ItemGroup>
    <PackageReference Include="Microsoft.VisualStudio.Azure.Containers.Tools.Targets" Version="1.19.5" />
    <PackageReference Include="AutoMapper.Extensions.Microsoft.DependencyInjection" Version="12.0.1" />
  </ItemGroup>
  <ItemGroup>
    <ProjectReference Include="..\..\BuildingBlocks\Common\Common.csproj" />
  </ItemGroup>
</Project>
EOF

# Create a simplified PostController that compiles
mkdir -p src/Services/PostService/Controllers
cat > src/Services/PostService/Controllers/PostController.cs << 'EOF'
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using LetsConnect.Common.Data;
using LetsConnect.Common.Models;
using Microsoft.AspNetCore.Authorization;
using AutoMapper;
using System.Security.Claims;

namespace PostService.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class PostController : ControllerBase
    {
        private readonly LetsConnectDbContext _context;
        private readonly IMapper _mapper;

        public PostController(LetsConnectDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        [HttpGet("feed")]
        public async Task<ActionResult> GetFeed()
        {
            var posts = await _context.Posts
                .Where(p => !p.IsDeleted)
                .Include(p => p.User)
                .OrderByDescending(p => p.CreatedAt)
                .Take(10)
                .ToListAsync();
            return Ok(posts);
        }

        [HttpPost("create")]
        public async Task<ActionResult> CreatePost([FromBody] CreatePostRequest request)
        {
            var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
            
            var post = new Post
            {
                Id = Guid.NewGuid(),
                UserId = userId,
                Caption = request.Caption,
                Location = request.Location
            };

            _context.Posts.Add(post);
            await _context.SaveChangesAsync();

            return Ok(post);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult> GetPost(Guid id)
        {
            var post = await _context.Posts
                .Include(p => p.User)
                .FirstOrDefaultAsync(p => p.Id == id);

            if (post == null) return NotFound();
            return Ok(post);
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> DeletePost(Guid id)
        {
            var post = await _context.Posts.FindAsync(id);
            if (post == null) return NotFound();

            var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
            if (post.UserId != userId) return Forbid();

            post.IsDeleted = true;
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }

    public class CreatePostRequest
    {
        public string? Caption { get; set; }
        public string? Location { get; set; }
    }
}
EOF

# Create AutoMapper profile
cat > src/Services/PostService/MappingProfile.cs << 'EOF'
using AutoMapper;
using LetsConnect.Common.Models;

namespace PostService
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            // Add mappings as needed
        }
    }
}
EOF

# Create Program.cs
cat > src/Services/PostService/Program.cs << 'EOF'
using LetsConnect.Common.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateLogger();
builder.Host.UseSerilog();

try
{
    builder.Services.AddControllers();
    builder.Services.AddEndpointsApiExplorer();
    builder.Services.AddSwaggerGen();

    var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") 
        ?? "Server=letsconnect-mysql;Database=LetsConnectDB;User=root;Password=YourPassword123!;";
    
    builder.Services.AddDbContext<LetsConnectDbContext>(options =>
        options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString),
            mySqlOptions => mySqlOptions.EnableRetryOnFailure(5, TimeSpan.FromSeconds(10), null)));

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

    builder.Services.AddAutoMapper(typeof(Program));

    builder.Services.AddCors(options =>
    {
        options.AddPolicy("AllowAll", builder =>
        {
            builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
        });
    });

    var app = builder.Build();

    app.UseSwagger();
    app.UseSwaggerUI();
    app.UseCors("AllowAll");
    app.UseAuthentication();
    app.UseAuthorization();
    app.MapControllers();

    Log.Information("Post Service starting...");
    app.Run();
}
catch (Exception ex)
{
    Log.Fatal(ex, "Post Service failed to start");
    throw;
}
finally
{
    Log.CloseAndFlush();
}
EOF

echo "✅ Post Service files rewritten"
# Now try building
echo ""
echo "=== Building Post Service ==="
docker build -t letsconnect-post-service:latest -f docker/post-service/Dockerfile . 2>&1 | tail -15
cd
cd /root/Letsconnect
# Set variables to avoid shell issues
DB_PASSWORD='YourPassword123!'
JWT_KEY='YourSuperSecretKeyThatIsAtLeast32BytesLong!@#$%^&*()'
# Start Post Service
docker run -d   --name letsconnect-post-service   --network letsconnect-network   -e "ConnectionStrings__DefaultConnection=server=letsconnect-mysql;port=3306;database=LetsConnectDB;user=root;password=${DB_PASSWORD};"   -e "Jwt__Key=${JWT_KEY}"   -e Jwt__Issuer=LetsConnect   -e Jwt__Audience=LetsConnect   -e ASPNETCORE_ENVIRONMENT=Production   -e ASPNETCORE_URLS=http://+:80   -p 5002:80   letsconnect-post-service:latest
echo "Waiting for Post Service (10 seconds)..."
sleep 10
# Check if running
echo ""
echo "=== Post Service Status ==="
docker ps --filter "name=letsconnect-post-service"
docker logs --tail 10 letsconnect-post-service
echo ""
echo "=== All Services Status ==="
docker ps --filter "name=letsconnect" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""
echo "=== Testing User Service API ==="
curl -s -X POST http://localhost:5001/api/auth/register   -H "Content-Type: application/json"   -d '{"username":"testuser2","email":"test2@example.com","password":"Test@123","fullName":"Test User Two"}'
echo ""
echo "=== Testing Post Service API ==="
curl -s http://localhost:5002/swagger/index.html | head -5
cd
cd /root/Letsconnect
# Check User Service logs for errors
echo "=== User Service Logs ==="
docker logs --tail 20 letsconnect-user-service
echo ""
echo "=== Testing User Service with verbose output ==="
curl -v -X POST http://localhost:5001/api/auth/register   -H "Content-Type: application/json"   -d '{"username":"testuser4","email":"test4@example.com","password":"Test@123","fullName":"Test User Four"}' 2>&1
# Check if MySQL is accessible and has the schema
echo ""
echo "=== Checking MySQL ==="
docker exec letsconnect-mysql mysql -uroot -pYourPassword123! -e "USE LetsConnectDB; SHOW TABLES;" 2>&1
# Check User Service directly
echo ""
echo "=== Testing User Service health ==="
curl -v http://localhost:5001/swagger/index.html 2>&1 | head -20
# Start Gateway if not running
echo ""
echo "=== Starting Gateway ==="
JWT_KEY='YourSuperSecretKeyThatIsAtLeast32BytesLong!@#$%^&*()'
docker stop letsconnect-gateway 2>/dev/null
docker rm letsconnect-gateway 2>/dev/null
docker run -d   --name letsconnect-gateway   --network letsconnect-network   -e "Jwt__Key=${JWT_KEY}"   -e Jwt__Issuer=LetsConnect   -e Jwt__Audience=LetsConnect   -e ASPNETCORE_ENVIRONMENT=Production   -e ASPNETCORE_URLS=http://+:80   -p 5000:80   letsconnect-gateway:latest
sleep 5
echo ""
echo "=== Gateway Logs ==="
docker logs --tail 10 letsconnect-gateway
echo ""
echo "=========================================="
echo "Final Status:"
echo "=========================================="
docker ps --filter "name=letsconnect" --format "table {{.Names}}\t{{.Status}}"
echo ""
echo "=========================================="
echo "Quick Test Commands:"
echo "=========================================="
echo ""
echo "# Register a user:"
echo "curl -X POST http://localhost:5001/api/auth/register \\"
echo "  -H 'Content-Type: application/json' \\"
echo '  -d '"'"'{"username":"demo","email":"demo@test.com","password":"Demo@123","fullName":"Demo User"}'"'"
echo ""
echo "# Login:"
echo "curl -X POST http://localhost:5001/api/auth/login \\"
echo "  -H 'Content-Type: application/json' \\"
echo '  -d '"'"'{"email":"demo@test.com","password":"Demo@123"}'"'"
echo ""
echo "# Swagger UIs:"
echo "http://localhost:5001/swagger (User Service)"
echo "http://localhost:5002/swagger (Post Service)"
echo "http://localhost:5003/swagger (Story Service)"
echo "http://localhost:5004/swagger (Message Service)"
echo "http://localhost:5005/swagger (Notification Service)"
echo "http://localhost:5006/swagger (Search Service)"
cd /root/Letsconnect
cat > test-api.sh << 'EOF'
#!/bin/bash

echo "=========================================="
echo "LetsConnect API Test Script"
echo "=========================================="

# Register
echo ""
echo "1. Registering user..."
REGISTER=$(curl -s -X POST http://localhost:5001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"demo","email":"demo@test.com","password":"Demo@123","fullName":"Demo User"}')
echo "$REGISTER"

# Extract token
TOKEN=$(echo "$REGISTER" | python3 -c "import sys, json; print(json.load(sys.stdin).get('token',''))" 2>/dev/null)

if [ -z "$TOKEN" ]; then
    echo ""
    echo "2. Registration may have failed, trying login..."
    LOGIN=$(curl -s -X POST http://localhost:5001/api/auth/login \
      -H "Content-Type: application/json" \
      -d '{"email":"demo@test.com","password":"Demo@123"}')
    echo "$LOGIN"
    TOKEN=$(echo "$LOGIN" | python3 -c "import sys, json; print(json.load(sys.stdin).get('token',''))" 2>/dev/null)
fi

if [ -n "$TOKEN" ]; then
    echo ""
    echo "✅ Authenticated! Token: ${TOKEN:0:30}..."
    
    echo ""
    echo "3. Getting Profile..."
    curl -s http://localhost:5001/api/auth/profile \
      -H "Authorization: Bearer $TOKEN"
    
    echo ""
    echo ""
    echo "4. Creating a Post..."
    curl -s -X POST http://localhost:5002/api/post/create \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $TOKEN" \
      -d '{"caption":"Hello LetsConnect! #firstpost","location":"Mumbai, India"}'
    
    echo ""
    echo ""
    echo "5. Getting Feed..."
    curl -s http://localhost:5002/api/post/feed \
      -H "Authorization: Bearer $TOKEN"
else
    echo "❌ Authentication failed"
fi

echo ""
echo ""
echo "=========================================="
echo "Test Complete!"
echo "=========================================="
EOF

chmod +x test-api.sh
echo ""
echo "✅ Created test-api.sh - Run with: ./test-api.sh"
ll
./test-api.sh 
cd /root/Letsconnect
echo "=========================================="
echo "Debugging User Service"
echo "=========================================="
# Check if User Service is actually running
echo "1. User Service Container Status:"
docker inspect letsconnect-user-service --format='{{.State.Status}}' 2>/dev/null || echo "Container not found"
# Check full logs
echo ""
echo "2. User Service Full Logs:"
docker logs letsconnect-user-service 2>&1 | tail -30
# Check if the port is actually listening
echo ""
echo "3. Testing port 5001:"
curl -v http://localhost:5001/ 2>&1 | head -15
# Test the Swagger endpoint
echo ""
echo "4. Testing Swagger:"
curl -s http://localhost:5001/swagger/index.html 2>&1 | head -10
# Test with explicit URL
echo ""
echo "5. Testing registration with verbose output:"
curl -v -X POST http://localhost:5001/api/auth/register   -H "Content-Type: application/json"   -d '{"username":"test1","email":"test1@test.com","password":"Test@123","fullName":"Test One"}' 2>&1
# Check if MySQL is accessible from User Service
echo ""
echo "6. Testing MySQL from User Service container:"
docker exec letsconnect-user-service wget -q -O- http://letsconnect-mysql:3306 2>&1 || echo "wget not available, trying ping..."
docker exec letsconnect-user-service ping -c 1 letsconnect-mysql 2>&1 || echo "ping not available"
# Check User Service environment variables
echo ""
echo "7. User Service Environment:"
docker exec letsconnect-user-service env | grep -i connection
docker exec letsconnect-user-service env | grep -i jwt
cd
cd /root/Letsconnect
# Set variables
DB_PASSWORD='YourPassword123!'
JWT_KEY='YourSuperSecretKeyThatIsAtLeast32BytesLong!@#$%^&*()'
REDIS_PASSWORD='YourRedisPassword'
# Stop and remove User Service
docker stop letsconnect-user-service
docker rm letsconnect-user-service
# Restart with ALL environment variables properly set
docker run -d   --name letsconnect-user-service   --network letsconnect-network   -e "ConnectionStrings__DefaultConnection=Server=letsconnect-mysql;Port=3306;Database=LetsConnectDB;User=root;Password=${DB_PASSWORD};"   -e "ConnectionStrings__Redis=letsconnect-redis:6379,password=${REDIS_PASSWORD}"   -e "Jwt__Key=${JWT_KEY}"   -e "Jwt__Issuer=LetsConnect"   -e "Jwt__Audience=LetsConnect"   -e "ASPNETCORE_ENVIRONMENT=Production"   -e "ASPNETCORE_URLS=http://+:80"   -e "Serilog__MinimumLevel=Information"   -p 5001:80   letsconnect-user-service:latest
echo "Waiting for User Service to start (15 seconds)..."
sleep 15
echo ""
echo "=== Check User Service Environment ==="
docker exec letsconnect-user-service env | grep -i connection
echo ""
echo "=== User Service Logs ==="
docker logs --tail 20 letsconnect-user-service 2>&1 | grep -E "error|Error|started|listening|Now listening|Application started|INF|WRN|FTL"
echo ""
echo "=== Testing Registration ==="
curl -v -X POST http://localhost:5001/api/auth/register   -H "Content-Type: application/json"   -d '{"username":"testuser99","email":"test99@example.com","password":"Test@123","fullName":"Test User 99"}' 2>&1
echo ""
# Also fix all other services that might have the same issue
echo "=== Fixing other services ==="
# Post Service
docker stop letsconnect-post-service 2>/dev/null
docker rm letsconnect-post-service 2>/dev/null
docker run -d   --name letsconnect-post-service   --network letsconnect-network   -e "ConnectionStrings__DefaultConnection=Server=letsconnect-mysql;Port=3306;Database=LetsConnectDB;User=root;Password=${DB_PASSWORD};"   -e "Jwt__Key=${JWT_KEY}"   -e "Jwt__Issuer=LetsConnect"   -e "Jwt__Audience=LetsConnect"   -e "ASPNETCORE_ENVIRONMENT=Production"   -e "ASPNETCORE_URLS=http://+:80"   -p 5002:80   letsconnect-post-service:latest
# Story Service
docker stop letsconnect-story-service 2>/dev/null
docker rm letsconnect-story-service 2>/dev/null
docker run -d   --name letsconnect-story-service   --network letsconnect-network   -e "ConnectionStrings__DefaultConnection=Server=letsconnect-mysql;Port=3306;Database=LetsConnectDB;User=root;Password=${DB_PASSWORD};"   -e "Jwt__Key=${JWT_KEY}"   -e "Jwt__Issuer=LetsConnect"   -e "Jwt__Audience=LetsConnect"   -e "ASPNETCORE_ENVIRONMENT=Production"   -e "ASPNETCORE_URLS=http://+:80"   -p 5003:80   letsconnect-story-service:latest
echo "Waiting for services (10 seconds)..."
sleep 10
echo ""
echo "=== Final Test ==="
curl -s -X POST http://localhost:5001/api/auth/register   -H "Content-Type: application/json"   -d '{"username":"finaltest","email":"final@test.com","password":"Test@123","fullName":"Final Test"}'
echo ""
echo "=== All Services Status ==="
docker ps --filter "name=letsconnect" --format "table {{.Names}}\t{{.Status}}"
