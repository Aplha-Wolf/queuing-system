-record(query_has_invalid_column, {
    file :: binary(),
    column_name :: binary(),
    suggested_name :: gleam@option:option(binary()),
    content :: binary(),
    starting_line :: integer(),
    reason :: squirrel@internal@error:value_identifier_error()
}).
