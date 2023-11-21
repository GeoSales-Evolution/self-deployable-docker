.PHONY: image

image:
	docker build . -t hestia:latest

debug: image
	./debug.sh

debug-no-mount: image
	docker run -it --entrypoint sh hestia:latest

clean-docker:
	../utils/dx/clean_docker.sh

hello-img-run: clean-docker image
	docker run -v /var/run/docker.sock:/var/run/docker.sock hestia --sleep 3 -- run -v /var/run/docker.sock:/var/run/docker.sock hello-world

gsolad: clean-docker image
	docker run -v /var/run/docker.sock:/var/run/docker.sock hestia -- run -p 8091:8091 --add-host=pumyra:10.0.0.82 -e BASE_USERNAME=backoffice -e BASE_PASSWORD=tantofaz -e HOST_BASE=10.0.0.82 -v /var/run/docker.sock:/var/run/docker.sock registry.gitlab.com/softsite/geosales/gsolad:2023.10.25
