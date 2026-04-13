-record(typed_query, {
    file :: binary(),
    starting_line :: integer(),
    name :: squirrel@internal@gleam:value_identifier(),
    comment :: list(binary()),
    content :: binary(),
    params :: list(squirrel@internal@gleam:type()),
    returns :: list(squirrel@internal@gleam:field())
}).
