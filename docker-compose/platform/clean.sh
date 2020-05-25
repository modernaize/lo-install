rm -rf data

rm -rf logs

rm -rf pgdata

version=P-v1.8.1

docker image rm liveobjects/postgres:$version
docker image rm liveobjects/service:$version
docker image rm liveobjects/learn:$version
docker image rm liveobjects/ui:$version
docker image rm liveobjects/license-service:$version