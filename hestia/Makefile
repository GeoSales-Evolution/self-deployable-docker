.PHONY: image

image:
	docker build . -t hestia:latest

debug: image
	docker run -it --entrypoint sh -v `pwd`:/app hestia:latest

debug-no-mount: image
	docker run -it --entrypoint sh hestia:latest
