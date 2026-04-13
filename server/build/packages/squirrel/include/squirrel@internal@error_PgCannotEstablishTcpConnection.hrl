-record(pg_cannot_establish_tcp_connection, {
    host :: binary(),
    port :: integer(),
    reason :: mug:connect_error()
}).
