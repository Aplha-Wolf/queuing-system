-record(pg_cannot_describe_query, {
    file :: binary(),
    query_name :: binary(),
    expected :: binary(),
    got :: binary()
}).
