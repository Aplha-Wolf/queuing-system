-record(context, {
    db :: squirrel@internal@database@postgres_protocol:connection(),
    gleam_types :: gleam@dict:dict(integer(), squirrel@internal@gleam:type()),
    column_nullability :: gleam@dict:dict({integer(), integer()}, squirrel@internal@database@postgres:nullability())
}).
