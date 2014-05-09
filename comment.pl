% Overrides standard comment to include
% email and site.

:- register_schema(comment, _{
    type: dict,
    tag: comment,
    keys: _{
        author: _{ type: string, min_length: 1 },
        content: _{ type: string, min_length: 1 },
        question: integer,
        answer: atom,
        email: string,
        site: string
    }
}).
