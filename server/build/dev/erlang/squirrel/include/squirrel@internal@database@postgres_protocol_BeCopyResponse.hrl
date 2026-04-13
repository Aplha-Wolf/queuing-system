-record(be_copy_response, {
    direction :: squirrel@internal@database@postgres_protocol:copy_direction(),
    overall_format :: squirrel@internal@database@postgres_protocol:format(),
    codes :: list(squirrel@internal@database@postgres_protocol:format())
}).
