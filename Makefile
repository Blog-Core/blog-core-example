linkcheck:
	linkchecker http://localhost:8080/

docker:
	tar --exclude=.git --exclude=*.tar -cvf blog-core-example.tar .
	docker build -t="rlaanemets/blog-core-example" .

.PHONY: linkcheck docker
