set -eu

docker search node
docker build -t twkoins_webui .
docker images | grep twkoins_webui
docker inspect twkoins_webui
docker inspect -f '{{ .Config.ExposedPorts }}' twkoins_webui
docker history twkoins_webui:latest
export TEAM_NAME=sandbox
docker tag twkoins_webui k8straining.azurecr.io/twkoins_webui:${TEAM_NAME}
docker images | grep twkoins_webui
az login
az account set --subscription <subscription-id>
az acr login --name k8straining
docker push k8straining.azurecr.io/twkoins_webui:${TEAM_NAME}
docker rmi -f twkoins_webui
docker rmi -f k8straining.azurecr.io/twkoins_webui:${TEAM_NAME}
docker ps
docker run -d -p 80:80 --name twkoins_webui k8straining.azurecr.io/twkoins_webui:${TEAM_NAME}
docker ps
docker port twkoins_webui
docker exec twkoins_webui ps -ef
docker exec -ti twkoins_webui bash -c "TERM=vt100 top -c"
docker logs --follow --tail=20 twkoins_webui
docker kill twkoins_webui
docker rm twkoins_webui
