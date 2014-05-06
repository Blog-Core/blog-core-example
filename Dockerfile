FROM ubuntu:latest

MAINTAINER Raivo Laanemets version: 0.1

ADD ./blog-core-example.tar /example

ADD ./docker-install.sh /tmp/docker-install.sh
RUN /bin/bash /tmp/docker-install.sh

EXPOSE 80

WORKDIR /example

ENV PL_ENV production

CMD ["/usr/bin/swipl", "-s", "/example/main.pl", "--", "--fork=false", "--port=80", "--user=nobody"]
