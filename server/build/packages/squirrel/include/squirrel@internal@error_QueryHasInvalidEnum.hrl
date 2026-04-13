-record(query_has_invalid_enum, {
    file :: binary(),
    content :: binary(),
    starting_line :: integer(),
    enum_name :: binary(),
    reason :: squirrel@internal@error:enum_error()
}).
