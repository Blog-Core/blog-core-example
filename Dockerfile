FROM mndrix/swipl:7.1.37

MAINTAINER Raivo Laanemets

RUN swipl -g 'Os=[interactive(false)],pack_install(blog_core,Os),pack_install(list_util,Os),halt' -t 'halt(1)'

ADD . /example

EXPOSE 80

WORKDIR /example

ENV PL_ENV production

CMD ["swipl", "-s", "/example/main.pl", "--", "--workers=16", "--port=80"]
