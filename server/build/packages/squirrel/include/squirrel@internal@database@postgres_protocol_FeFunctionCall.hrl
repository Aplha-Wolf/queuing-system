-record(fe_function_call, {
    object_id :: integer(),
    argument_format :: squirrel@internal@database@postgres_protocol:format_value(),
    arguments :: list(squirrel@internal@database@postgres_protocol:parameter_value()),
    result_format :: squirrel@internal@database@postgres_protocol:format()
}).
