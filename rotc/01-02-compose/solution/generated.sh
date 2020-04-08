set -eu 

docker-compose up -d
docker-compose ps
docker-compose logs -f
docker-compose exec webui ping redis
docker-compose up -d --scale worker=10
docker ps
docker-compose down
