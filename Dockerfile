ARG VERSION=5.0-alpine

FROM mcr.microsoft.com/dotnet/runtime-deps:${VERSION} AS base
WORKDIR /app
EXPOSE 8080
# HEALTHCHECK --interval=60s --timeout=3s --retries=3 \
#     CMD wget localhost:80/health -q -O - > /dev/null 2>&1
ENV ASPNETCORE_URLS=http://+:80
RUN addgroup -g 1000 dotnet && \
    adduser -u 1000 -G dotnet -s /bin/sh -D dotnet
USER dotnet

FROM mcr.microsoft.com/dotnet/sdk:${VERSION} AS build
WORKDIR /code
COPY ["src/CryptoVault.Api/CryptoVault.Api.csproj", "src/CryptoVault.Api/CryptoVault.Api.csproj"]
COPY ["Tests/CryptoVault.Api.IntegrationTests/CryptoVault.Api.IntegrationTests.csproj", "Tests/CryptoVault.Api.IntegrationTests/CryptoVault.Api.IntegrationTests.csproj"]

RUN dotnet restore "src/CryptoVault.Api/CryptoVault.Api.csproj" -r linux-musl-x64
RUN dotnet restore "Tests/CryptoVault.Api.IntegrationTests/CryptoVault.Api.IntegrationTests.csproj" -r linux-musl-x64
COPY . .

RUN dotnet build \
    "src/CryptoVault.Api/CryptoVault.Api.csproj" \
    -c Release \
    -r linux-musl-x64 \
    --no-restore

RUN dotnet build \
    "Tests/CryptoVault.Api.IntegrationTests/CryptoVault.Api.IntegrationTests.csproj" \
    -c Release \
    -r linux-musl-x64 \
    --no-restore

# Unit test runner
FROM build AS unit-test
WORKDIR /code/Tests/CryptoVault.Api.IntegrationTests
ENTRYPOINT dotnet test \
    -c Release \
    --runtime linux-musl-x64 \
    --no-restore \
    --no-build \
    --logger "trx;LogFileName=test_results_unit_test.trx" \
    -p:CollectCoverage=true \
    -p:CoverletOutput="TestResults/coverage.info" \
    -p:CoverletOutputFormat=lcov

FROM build AS publish
WORKDIR /code/src/CryptoVault.Api
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
COPY --chown=dotnet:dotnet --from=publish /out .
ENTRYPOINT ["./CryptoVault.Api"]
