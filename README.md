# Blog-Core example project

Codebase for [Blog-Core demo](http://blog-core.net/page/demo). Requires SWI-Prolog version 7.1.34 or newer.

## Installing dependecies

    swipl -g 'Os=[interactive(false)],pack_install(blog_core,Os),pack_install(list_util,Os),halt' -t 'halt(1)'

## Running

    swipl -s main.pl -- --port=8080

The site can be accessed from <http://localhost:8080>.

## Building a docker container

    make docker

## Running with docker

    docker run -t -p 8080:80 blog_core/demo

The site can be accessed from <http://localhost:8080>.

Note that the database `blog.docstore` should not be included in Git as journal
changes will cause merge conflicts.

## License

The MIT License.
