# docker/message-service/Dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["src/Services/MessageService/MessageService.csproj", "src/Services/MessageService/"]
COPY ["src/BuildingBlocks/Common/Common.csproj", "src/BuildingBlocks/Common/"]
RUN dotnet restore "src/Services/MessageService/MessageService.csproj"
COPY . .
WORKDIR "/src/src/Services/MessageService"
RUN dotnet build "MessageService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MessageService.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MessageService.dll"]
