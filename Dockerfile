FROM ubuntu:latest

ADD ./docker-install.sh /tmp/docker-install.sh
RUN /bin/bash /tmp/docker-install.sh

EXPOSE 80

CMD ["/usr/bin/swipl", "-s", "/example/main.pl", "--", "--fork=false", "--port=80"]
