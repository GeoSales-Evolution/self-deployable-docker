.PHONY: image

image:
	docker build . -t hestia:latest

debug: image
	./debug.sh

debug-no-mount: image
	docker run -it --entrypoint sh hestia:latest

clean-docker:
	./clean_docker_hestia

hello-img-run: clean-docker image
	docker run -v /var/run/docker.sock:/var/run/docker.sock hestia --sleep 3 -- run hello-world
