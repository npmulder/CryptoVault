$IMAGE_NAME_AND_TAG="cryptovault:v4"

Write-Output "Unit tests [build]"
docker build --target unit-test -t $IMAGE_NAME_AND_TAG .

Write-Output "Unit tests [run]"
docker run --rm -v "${pwd}\TestResults:/code/Tests/CryptoVault.Api.IntegrationTests/TestResults/" $IMAGE_NAME_AND_TAG