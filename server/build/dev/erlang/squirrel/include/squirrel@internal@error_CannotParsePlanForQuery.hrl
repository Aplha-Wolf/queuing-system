-record(cannot_parse_plan_for_query, {
    file :: binary(),
    reason :: gleam@json:decode_error()
}).
