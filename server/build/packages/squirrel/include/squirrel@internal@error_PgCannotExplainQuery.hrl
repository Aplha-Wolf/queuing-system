-record(pg_cannot_explain_query, {
    file :: binary(),
    query_name :: binary(),
    expected :: binary(),
    got :: binary()
}).
