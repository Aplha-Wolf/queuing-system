-record(cannot_parse_query, {
    file :: binary(),
    name :: binary(),
    content :: binary(),
    starting_line :: integer(),
    error_code :: gleam@option:option(binary()),
    pointer :: gleam@option:option(squirrel@internal@error:pointer()),
    additional_error_message :: gleam@option:option(binary()),
    hint :: gleam@option:option(binary())
}).
