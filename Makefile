all: public/comment.min.js

linkcheck:
	linkchecker http://localhost:8080/

docker:
	tar --exclude=.git --exclude=*.tar -cvf blog-core-example.tar .
	docker build -t="rlaanemets/blog-core-example" .

check:
	jshint public/comment.js

public/comment.min.js: public/comment.js
	uglifyjs $< -o $@

.PHONY: linkcheck docker check
