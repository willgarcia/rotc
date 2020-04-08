set -eu

docker search node
docker build -t dockercoins_webui .
docker images | grep dockercoins_webui
docker inspect dockercoins_webui
docker inspect -f '{{ .Config.ExposedPorts }}' dockercoins_webui
docker history dockercoins_webui:latest
export TEAM_NAME=sandbox
docker tag dockercoins_webui k8straining.azurecr.io/dockercoins_webui:${TEAM_NAME}
docker images | grep dockercoins_webui
az login
az account set --subscription <subscription-id>
az acr login --name k8straining
docker push k8straining.azurecr.io/dockercoins_webui:${TEAM_NAME}
docker rmi -f dockercoins_webui
docker rmi -f k8straining.azurecr.io/dockercoins_webui:${TEAM_NAME}
docker ps
docker run -d -p 80:80 --name dockercoins_webui k8straining.azurecr.io/dockercoins_webui:${TEAM_NAME}
docker ps
docker port dockercoins_webui
docker exec dockercoins_webui ps -ef
docker exec -ti dockercoins_webui bash -c "TERM=vt100 top -c"
docker logs --follow --tail=20 dockercoins_webui
docker kill dockercoins_webui
docker rm dockercoins_webui
