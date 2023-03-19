@REM TODO: build images with custom username/groupname then push
@REM docker build --build-arg username=!username! --build-arg groupname=!groupname! -f ../docker/alpine/docker-compose.yaml -t dplay_msdot
@REM docker build --build-arg username=!username! --build-arg groupname=!groupname! -f ../docker/ubuntu/docker-compose.yaml -t dplay_msdot
@REM docker image push kindtek/dplay

@REM ubuntu
docker compose -f ../docker/ubuntu/docker-compose.yaml down
@REM alpine
@REM docker compose -f ../ddocker/alpine/docker-compose.yaml down


