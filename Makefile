.PHONY: all

all:
ifndef VER
        $(must specify a target.)
endif



REGISTRY=${MY_IP}:5000

stop_registry:
	docker stop registry

start_registry:
	docker run -d -p 5000:5000 --restart=always --name registry registry:2.7


build_docker-dev-python3: Makefile
	docker build -t docker-dev-python3 .
	docker tag docker-dev-python3 ${REGISTRY}/docker-dev-python3
	docker push ${REGISTRY}/docker-dev-python3:latest

stop_docker-dev-python3: Makefile
	docker-compose down

run_docker-dev-python3: Makefile
	#docker-compose up
	#docker run -it ${REGISTRY}/docker-dev-python3
	docker run -ti --rm -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix ${REGISTRY}/docker-dev-python3 /usr/bin/brave-browser --no-sandbox --verbose  --disable-dev-shm-usage


clean:
	docker rm -f "$(docker container ls -aq)" 2>/dev/null || true
	docker system prune -a -f 2>/dev/null || true
	docker rmi -f "$(docker image ls -aq)" 2>/dev/null || true

