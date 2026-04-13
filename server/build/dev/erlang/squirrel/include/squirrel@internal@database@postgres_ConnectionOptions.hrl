-record(connection_options, {
    host :: binary(),
    port :: integer(),
    user :: binary(),
    password :: binary(),
    database :: binary(),
    timeout_seconds :: integer()
}).
