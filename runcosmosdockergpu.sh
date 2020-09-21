#
# example: when a controller image had docker enabled through a docker socket fs mount, the controller can call docker worker instances.
#
#

docker pull twobombs/qracknet:cosmos-gpu1
docker pull twobombs/qracknet:cosmos-gpu2

docker rm $(docker ps -aq)

docker run --name cosmosgpu1a --gpus all --device=/dev/dri:/dev/dri -d --mount type=bind,source=/var/log/qrack/1,target=/var/log/qrack twobombs/qracknet:cosmos-gpu1
docker run --name cosmosgpu2a --gpus all --device=/dev/dri:/dev/dri -d --mount type=bind,source=/var/log/qrack/2,target=/var/log/qrack twobombs/qracknet:cosmos-gpu2
docker run --name cosmosgpu1b --gpus all --device=/dev/dri:/dev/dri -d --mount type=bind,source=/var/log/qrack/3,target=/var/log/qrack twobombs/qracknet:cosmos-gpu1
docker run --name cosmosgpu2b --gpus all --device=/dev/dri:/dev/dri -d --mount type=bind,source=/var/log/qrack/4,target=/var/log/qrack twobombs/qracknet:cosmos-gpu2

docker logs --follow cosmosgpu2b

docker rm cosmosgpu1a
docker rm cosmosgpu2a
docker rm cosmosgpu1b
docker rm cosmosgpu2b

# run again
./runcosmosdockergpu.sh
