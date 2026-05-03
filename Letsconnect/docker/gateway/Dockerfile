FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["src/Gateway/LetsConnect.Gateway/LetsConnect.Gateway.csproj", "src/Gateway/LetsConnect.Gateway/"]
RUN dotnet restore "src/Gateway/LetsConnect.Gateway/LetsConnect.Gateway.csproj"
COPY . .
WORKDIR "/src/src/Gateway/LetsConnect.Gateway"
RUN dotnet publish "LetsConnect.Gateway.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .

# List files to verify
RUN echo "=== Files in /app ===" && ls -la /app/ && echo "=== Looking for ocelot.json ===" && ls -la /app/ocelot.json /app/Ocelot.json 2>/dev/null || echo "ocelot.json check done"

ENTRYPOINT ["dotnet", "LetsConnect.Gateway.dll"]
