.PHONY: run debug debug-no-mount image prune debug-as-ruby

PORT=8000
PORT_BIND=-p $(PORT):$(PORT)

run: image
	docker run -it $(PORT_BIND) ouroborus:latest

debug: image
	docker run -it $(PORT_BIND) --entrypoint sh -v `pwd`:/app ouroborus:latest

debug-as-ruby:
	docker run -it $(PORT_BIND) --entrypoint sh -v `pwd`:/app ruby:3-alpine

debug-no-mount: image
	docker run -it $(PORT_BIND) --entrypoint sh ouroborus:latest

image: Dockerfile Gemfile Gemfile.lock ouroborus.gemspec
	docker build . -t ouroborus:latest

Gemfile.lock: Gemfile
	docker run -it --entrypoint sh -w /app -v `pwd`:/app ruby:3-alpine -c ./update

