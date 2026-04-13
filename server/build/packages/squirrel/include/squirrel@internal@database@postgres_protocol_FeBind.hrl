-record(fe_bind, {
    portal :: binary(),
    statement_name :: binary(),
    parameter_format :: squirrel@internal@database@postgres_protocol:format_value(),
    parameters :: list(squirrel@internal@database@postgres_protocol:parameter_value()),
    result_format :: squirrel@internal@database@postgres_protocol:format_value()
}).
