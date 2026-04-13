-record(state, {
    process_id :: integer(),
    secret_key :: integer(),
    parameters :: gleam@dict:dict(binary(), binary()),
    oids :: gleam@dict:dict(integer(), fun((bitstring()) -> {ok, integer()} |
        {error, nil}))
}).
