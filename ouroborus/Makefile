.PHONY: run debug debug-no-mount image prune

run: image
	docker run -it ouroborus:latest

debug: image
	docker run -it --entrypoint sh -v `pwd`:/app ouroborus:latest

debug-no-mount: image
	docker run -it --entrypoint sh ouroborus:latest

image: .image

.image : Dockerfile Gemfile ouroborus.gemspec
	docker build . -t ouroborus:latest
	touch .image
