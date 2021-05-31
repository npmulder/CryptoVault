$IMAGE_NAME_AND_TAG="cryptovault:v4"

Write-Output "App [build]"
docker build -t $IMAGE_NAME_AND_TAG .