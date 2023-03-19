@REM TODO: build images with custom username/groupname then push
@REM docker build --build-arg username=!username! --build-arg groupname=!groupname! -f ../docker/alpine/docker-compose.yaml -t dplay_msdot
@REM docker build --build-arg username=!username! --build-arg groupname=!groupname! -f ../docker/ubuntu/docker-compose.yaml -t dplay_msdot
@REM docker image push kindtek/dplay

@REM ubuntu
docker compose -f ../docker/ubuntu/docker-compose.yaml build
@REM alpine
@REM docker compose -f ../docker/alpine/docker-compose.yaml build

@REM both
@REM docker compose -f ../docker/ubuntu/docker-compose.yaml -f ../docker/alpine/docker-compose.yaml up -d

