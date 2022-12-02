.PHONY: run debug debug-no-mount image prune debug-as-ruby

run: image
	docker run -it -p 8000:8000 ouroborus:latest

debug: image
	docker run -it -p 8000:8000 --entrypoint sh -v `pwd`:/app ouroborus:latest

debug-as-ruby:
	docker run -it -p 8000:8000 --entrypoint sh -v `pwd`:/app ruby:3-alpine

debug-no-mount: image
	docker run -it -p 8000:8000 --entrypoint sh ouroborus:latest

image: .image

.image : Dockerfile Gemfile ouroborus.gemspec
	docker build . -t ouroborus:latest
	touch .image
