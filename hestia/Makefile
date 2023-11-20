.PHONY: image

image:
	docker build . -t hestia:latest

debug: image
	docker run -it --entrypoint sh -v `pwd`:/app hestia:latest

debug-no-mount: image
	docker run -it --entrypoint sh hestia:latest

clean-docker:
	../utils/dx/clean_docker.sh

hello-img-run: clean-docker image
	docker run -v /var/run/docker.sock:/var/run/docker.sock hestia --sleep 3 -- run -v /var/run/docker.sock:/var/run/docker.sock hello-world