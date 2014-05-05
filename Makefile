linkcheck:
	linkchecker http://localhost:8080/

docker:
	docker build -t="rla/blog-core-example" .

.PHONY: linkcheck docker
