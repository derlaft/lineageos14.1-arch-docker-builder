.PHONY: default
default:
	docker build -f Dockerfile . -t androidbuilder
	docker run --rm -it -u $(shell id -u):$(shell id -g) -v $(PWD)/android:/home/user/android/ androidbuilder bash

