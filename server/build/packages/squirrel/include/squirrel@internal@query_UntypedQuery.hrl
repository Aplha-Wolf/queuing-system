-record(untyped_query, {
    file :: binary(),
    starting_line :: integer(),
    name :: squirrel@internal@gleam:value_identifier(),
    comment :: list(binary()),
    content :: binary()
}).
