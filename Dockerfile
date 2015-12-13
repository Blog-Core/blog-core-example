FROM mndrix/swipl:7.3.13

MAINTAINER Raivo Laanemets

RUN swipl -g "Os=[interactive(false)],pack_install('http://packs.rlaanemets.com/alternative-router/arouter-1.1.1.tgz',Os),halt" -t "halt(1)"
RUN swipl -g "Os=[interactive(false)],pack_install('http://packs.rlaanemets.com/dict-schema/dict_schema-0.0.2.tgz',Os),halt" -t "halt(1)"
RUN swipl -g "Os=[interactive(false)],pack_install('http://packs.rlaanemets.com/docstore/docstore-2.0.1.tgz',Os),halt" -t "halt(1)"
RUN swipl -g "Os=[interactive(false)],pack_install('http://packs.rlaanemets.com/markdown/markdown-0.0.2.tgz',Os),halt" -t "halt(1)"
RUN swipl -g "Os=[interactive(false)],pack_install('http://packs.rlaanemets.com/simple-template/simple_template-1.0.1.tgz',Os),halt" -t "halt(1)"
RUN swipl -g "Os=[interactive(false)],pack_install('http://packs.rlaanemets.com/sort-dict/sort_dict-0.0.3.tgz',Os),halt" -t "halt(1)"
RUN swipl -g "Os=[interactive(false)],pack_install('http://www.swi-prolog.org/download/pack/smtp-0.9.4.tgz',Os),halt" -t "halt(1)"
RUN swipl -g "Os=[interactive(false)],pack_install('http://packs.rlaanemets.com/blog-core/blog_core-0.0.14.tgz',Os),halt" -t "halt(1)"

ADD . /example

EXPOSE 80

WORKDIR /example

ENV PL_ENV production

CMD ["swipl", "-s", "/example/main.pl", "--", "--workers=16", "--port=80"]
