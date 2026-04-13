-module(helpers@sql).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/helpers/sql.gleam").
-export([start_db_pool/0, db_connection/1, pgo_queryerror_tojson/1, pgo_transactionerror_tojson/1]).

-file("src/helpers/sql.gleam", 8).
-spec read_connection_uri() -> {ok, pog:config()} | {error, nil}.
read_connection_uri() ->
    case envoy_ffi:get(<<"DATABASE_URL"/utf8>>) of
        {ok, Config} ->
            Name = gleam_erlang_ffi:new_name(<<"db_pool"/utf8>>),
            pog:url_config(Name, Config);

        {error, _} ->
            {error, nil}
    end.

-file("src/helpers/sql.gleam", 18).
-spec start_db_pool() -> {ok, gleam@erlang@process:name(pog:message())} |
    {error, nil}.
start_db_pool() ->
    case read_connection_uri() of
        {ok, Config} ->
            Name = erlang:element(2, Config),
            Pool_child = begin
                _pipe = Config,
                _pipe@1 = pog:pool_size(_pipe, 15),
                pog:supervised(_pipe@1)
            end,
            case begin
                _pipe@2 = gleam@otp@static_supervisor:new(rest_for_one),
                _pipe@3 = gleam@otp@static_supervisor:add(_pipe@2, Pool_child),
                gleam@otp@static_supervisor:start(_pipe@3)
            end of
                {ok, _} -> nil;
                _assert_fail ->
                    erlang:error(#{gleam_error => let_assert,
                                message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                file => <<?FILEPATH/utf8>>,
                                module => <<"helpers/sql"/utf8>>,
                                function => <<"start_db_pool"/utf8>>,
                                line => 27,
                                value => _assert_fail,
                                start => 635,
                                'end' => 793,
                                pattern_start => 646,
                                pattern_end => 651})
            end,
            {ok, Name};

        {error, _} ->
            {error, nil}
    end.

-file("src/helpers/sql.gleam", 38).
-spec db_connection(gleam@erlang@process:name(pog:message())) -> pog:connection().
db_connection(Pool) ->
    pog:named_connection(Pool).

-file("src/helpers/sql.gleam", 42).
-spec pgo_queryerror_tojson(pog:query_error()) -> gleam@json:json().
pgo_queryerror_tojson(Error) ->
    case Error of
        {constraint_violated, Message, Constraint, Detail} ->
            gleam@json:object(
                [{<<"status"/utf8>>,
                        gleam@json:int(
                            common@common:api_status_to_int(api_status_err)
                        )},
                    {<<"message"/utf8>>,
                        gleam@json:string(<<"SQL Error"/utf8>>)},
                    {<<"errors"/utf8>>,
                        gleam@json:preprocessed_array(
                            [gleam@json:object(
                                    [{<<"error1"/utf8>>,
                                            gleam@json:string(Message)},
                                        {<<"error2"/utf8>>,
                                            gleam@json:string(Constraint)},
                                        {<<"error3"/utf8>>,
                                            gleam@json:string(Detail)}]
                                )]
                        )}]
            );

        {postgresql_error, Code, Message@1, Name} ->
            gleam@json:object(
                [{<<"status"/utf8>>,
                        gleam@json:int(
                            common@common:api_status_to_int(api_status_err)
                        )},
                    {<<"message"/utf8>>,
                        gleam@json:string(<<"SQL Error"/utf8>>)},
                    {<<"errors"/utf8>>,
                        gleam@json:preprocessed_array(
                            [gleam@json:object(
                                    [{<<"code"/utf8>>, gleam@json:string(Code)},
                                        {<<"message"/utf8>>,
                                            gleam@json:string(Message@1)},
                                        {<<"name"/utf8>>,
                                            gleam@json:string(Name)}]
                                )]
                        )}]
            );

        {unexpected_argument_count, Expected, Get} ->
            gleam@json:object(
                [{<<"status"/utf8>>,
                        gleam@json:int(
                            common@common:api_status_to_int(api_status_err)
                        )},
                    {<<"message"/utf8>>,
                        gleam@json:string(<<"SQL Error"/utf8>>)},
                    {<<"errors"/utf8>>,
                        gleam@json:preprocessed_array(
                            [gleam@json:object(
                                    [{<<"error1"/utf8>>,
                                            gleam@json:int(Expected)},
                                        {<<"error2"/utf8>>, gleam@json:int(Get)},
                                        {<<"error3"/utf8>>,
                                            gleam@json:string(<<""/utf8>>)}]
                                )]
                        )}]
            );

        {unexpected_argument_type, Expected@1, Get@1} ->
            gleam@json:object(
                [{<<"status"/utf8>>,
                        gleam@json:int(
                            common@common:api_status_to_int(api_status_err)
                        )},
                    {<<"message"/utf8>>,
                        gleam@json:string(<<"SQL Error"/utf8>>)},
                    {<<"errors"/utf8>>,
                        gleam@json:preprocessed_array(
                            [gleam@json:object(
                                    [{<<"error1"/utf8>>,
                                            gleam@json:string(Expected@1)},
                                        {<<"error2"/utf8>>,
                                            gleam@json:string(Get@1)},
                                        {<<"error3"/utf8>>,
                                            gleam@json:string(<<""/utf8>>)}]
                                )]
                        )}]
            );

        {unexpected_result_type, _} ->
            gleam@json:object(
                [{<<"status"/utf8>>,
                        gleam@json:int(
                            common@common:api_status_to_int(api_status_err)
                        )},
                    {<<"message"/utf8>>,
                        gleam@json:string(<<"SQL Error"/utf8>>)},
                    {<<"errors"/utf8>>,
                        gleam@json:preprocessed_array(
                            [gleam@json:object(
                                    [{<<"error1"/utf8>>,
                                            gleam@json:string(
                                                <<"Decode error with expected type"/utf8>>
                                            )},
                                        {<<"error2"/utf8>>,
                                            gleam@json:string(<<""/utf8>>)},
                                        {<<"error3"/utf8>>,
                                            gleam@json:string(<<""/utf8>>)}]
                                )]
                        )}]
            );

        connection_unavailable ->
            gleam@json:object(
                [{<<"status"/utf8>>,
                        gleam@json:int(
                            common@common:api_status_to_int(api_status_err)
                        )},
                    {<<"message"/utf8>>,
                        gleam@json:string(<<"SQL Error"/utf8>>)},
                    {<<"errors"/utf8>>,
                        gleam@json:preprocessed_array(
                            [gleam@json:object(
                                    [{<<"error1"/utf8>>,
                                            gleam@json:string(
                                                <<"connection unavailable"/utf8>>
                                            )},
                                        {<<"error2"/utf8>>,
                                            gleam@json:string(<<""/utf8>>)},
                                        {<<"error3"/utf8>>,
                                            gleam@json:string(<<""/utf8>>)}]
                                )]
                        )}]
            );

        query_timeout ->
            gleam@json:object(
                [{<<"status"/utf8>>,
                        gleam@json:int(
                            common@common:api_status_to_int(api_status_err)
                        )},
                    {<<"message"/utf8>>,
                        gleam@json:string(<<"SQL Error"/utf8>>)},
                    {<<"errors"/utf8>>,
                        gleam@json:preprocessed_array(
                            [gleam@json:object(
                                    [{<<"error1"/utf8>>,
                                            gleam@json:string(
                                                <<"Connection Timeout"/utf8>>
                                            )},
                                        {<<"error2"/utf8>>,
                                            gleam@json:string(<<""/utf8>>)},
                                        {<<"error3"/utf8>>,
                                            gleam@json:string(<<""/utf8>>)}]
                                )]
                        )}]
            )
    end.

-file("src/helpers/sql.gleam", 152).
-spec pgo_transactionerror_tojson(pog:transaction_error(binary())) -> gleam@json:json().
pgo_transactionerror_tojson(Error) ->
    case Error of
        {transaction_query_error, Err} ->
            pgo_queryerror_tojson(Err);

        {transaction_rolled_back, Error@1} ->
            gleam@json:object(
                [{<<"status"/utf8>>,
                        gleam@json:int(
                            common@common:api_status_to_int(api_status_err)
                        )},
                    {<<"message"/utf8>>,
                        gleam@json:string(<<"SQL Error"/utf8>>)},
                    {<<"errors"/utf8>>,
                        gleam@json:preprocessed_array(
                            [gleam@json:object(
                                    [{<<"error1"/utf8>>,
                                            gleam@json:string(Error@1)},
                                        {<<"error2"/utf8>>,
                                            gleam@json:string(<<""/utf8>>)},
                                        {<<"error3"/utf8>>,
                                            gleam@json:string(<<""/utf8>>)}]
                                )]
                        )}]
            )
    end.
