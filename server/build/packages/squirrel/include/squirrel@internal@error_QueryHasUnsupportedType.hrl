-record(query_has_unsupported_type, {
    file :: binary(),
    name :: binary(),
    content :: binary(),
    starting_line :: integer(),
    type_ :: binary()
}).
