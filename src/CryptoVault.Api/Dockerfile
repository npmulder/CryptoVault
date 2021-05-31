FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["src/CryptoVault.Api/CryptoVault.Api.csproj", "src/CryptoVault.Api/"]
RUN dotnet restore "src/CryptoVault.Api/CryptoVault.Api.csproj"
COPY . .
WORKDIR "/src/src/CryptoVault.Api"
RUN dotnet build "CryptoVault.Api.csproj" -c Release -o /app/build --no-restore

FROM build AS publish
RUN dotnet publish "CryptoVault.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CryptoVault.Api.dll"]
