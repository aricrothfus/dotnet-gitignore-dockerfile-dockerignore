#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0.0-rc.2-bullseye-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0.100-rc.2-bullseye-slim AS build
WORKDIR /src
COPY ["dotnet1.csproj", ""]
RUN dotnet restore "./dotnet1.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "dotnet1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dotnet1.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dotnet1.dll"]