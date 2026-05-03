# docker/story-service/Dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["src/Services/StoryService/StoryService.csproj", "src/Services/StoryService/"]
COPY ["src/BuildingBlocks/Common/Common.csproj", "src/BuildingBlocks/Common/"]
RUN dotnet restore "src/Services/StoryService/StoryService.csproj"
COPY . .
WORKDIR "/src/src/Services/StoryService"
RUN dotnet build "StoryService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "StoryService.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "StoryService.dll"]
