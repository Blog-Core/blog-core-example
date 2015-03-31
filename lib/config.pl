:- module(config, [
    config/2
]).

%! config(?Key, ?Value) is multidet.
%
% Configuration values that are read-only
% during runtime.

config(site, 'http://example.blog-core.net').
config(db, 'blog.docstore').
config(title, 'The Blog-Core example').