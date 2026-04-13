-record(query_file_has_invalid_name, {
    file :: binary(),
    suggested_name :: gleam@option:option(binary()),
    reason :: squirrel@internal@error:value_identifier_error()
}).
