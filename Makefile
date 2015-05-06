all: public/comment.min.js

linkcheck:
	linkchecker http://localhost:8080/

docker:
	docker build -t="blogcore/demo" .

check:
	jshint public/comment.js

public/comment.min.js: public/comment.js
	uglifyjs $< -o $@

.PHONY: linkcheck docker check
