ARG VERSION=5.0-alpine

FROM mcr.microsoft.com/dotnet/runtime-deps:${VERSION} AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

RUN addgroup -g 1000 dotnet && \
    adduser -u 1000 -G dotnet -s /bin/sh -D dotnet

FROM mcr.microsoft.com/dotnet/sdk:${VERSION} AS build
WORKDIR /app
COPY . .

WORKDIR "/app/src/CryptoVault.Api"

#COPY ["src/CryptoVault.Api/CryptoVault.Api.csproj", "src/CryptoVault.Api/"]
RUN dotnet restore "CryptoVault.Api.csproj" -r linux-musl-x64

RUN dotnet build "CryptoVault.Api.csproj" -c Release -o /app/build --no-restore

FROM build AS publish
RUN dotnet publish \
    -c Release \
    -o /out \
    -r linux-musl-x64 \
    --self-contained=true \
    --no-restore \
    -p:PublishReadyToRun=true \
    -p:PublishTrimmed=true

FROM base AS final
WORKDIR /app
COPY --chown=dotnet:dotnetgroup --from=publish /out .
ENTRYPOINT ["./CryptoVault.Api"]
