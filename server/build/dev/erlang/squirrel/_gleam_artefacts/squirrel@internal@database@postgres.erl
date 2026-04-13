-module(squirrel@internal@database@postgres).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/squirrel/internal/database/postgres.gleam").
-export([main/2, connect_and_authenticate/1]).
-export_type([pg_type/0, context/0, nullability/0, plan/0, join_type/0, connection_options/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-type pg_type() :: {p_base, binary()} | {p_enum, binary(), list(binary())}.

-opaque context() :: {context,
        squirrel@internal@database@postgres_protocol:connection(),
        gleam@dict:dict(integer(), squirrel@internal@gleam:type()),
        gleam@dict:dict({integer(), integer()}, nullability())}.

-type nullability() :: nullable | not_nullable.

-type plan() :: {plan,
        gleam@option:option(join_type()),
        list(binary()),
        list(plan())}.

-type join_type() :: full_join | left_join | right_join | inner_join | semi_join.

-type connection_options() :: {connection_options,
        binary(),
        integer(),
        binary(),
        binary(),
        binary(),
        integer()}.

-file("src/squirrel/internal/database/postgres.gleam", 41).
?DOC(false).
-spec find_postgres_type_query() -> squirrel@internal@query:untyped_query().
find_postgres_type_query() ->
    Name@1 = case squirrel@internal@gleam:value_identifier(
        <<"find_postgres_type_query"/utf8>>
    ) of
        {ok, Name} -> Name;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"squirrel/internal/database/postgres"/utf8>>,
                        function => <<"find_postgres_type_query"/utf8>>,
                        line => 42,
                        value => _assert_fail,
                        start => 1456,
                        'end' => 1528,
                        pattern_start => 1467,
                        pattern_end => 1475})
    end,
    {untyped_query,
        <<""/utf8>>,
        1,
        Name@1,
        [],
        <<"
with recursive types as (
    -- This selects the initial type, it might be an array!
    select
      pg_type.oid as oid,
      pg_type.typname as name,
      pg_type.typelem as elem,
      pg_type.typtype as kind,
      0 as jumps
    from pg_type
    where pg_type.oid = $1
  union all
    -- So we keep selecting the type contained in it recursively until we
    -- reach a base type (where the `elem` field is 0 and can't be joined with
    -- any other type).
    select
      pg_type.oid as oid,
      pg_type.typname as name,
      pg_type.typelem as elem,
      pg_type.typtype as kind,
      types.jumps + 1 as jumps
    from pg_type
    join types
      on pg_type.oid = types.elem
      -- We need to special case the built-in `name` type: for some reason
      -- that's treated as a char array, so we have to stop the recursion
      -- earlier
      and types.name != 'name'
)
-- Finally we only get the last base type (keeping track of how many jumps we
-- did to properly wrap it in an array type the correct number of times)
select
  types.oid,
  types.name,
  types.kind,
  types.jumps
from types
order by types.jumps desc
limit 1
"/utf8>>}.

-file("src/squirrel/internal/database/postgres.gleam", 92).
?DOC(false).
-spec find_enum_variants_query() -> squirrel@internal@query:untyped_query().
find_enum_variants_query() ->
    Name@1 = case squirrel@internal@gleam:value_identifier(
        <<"find_enum_variants_query"/utf8>>
    ) of
        {ok, Name} -> Name;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"squirrel/internal/database/postgres"/utf8>>,
                        function => <<"find_enum_variants_query"/utf8>>,
                        line => 93,
                        value => _assert_fail,
                        start => 2841,
                        'end' => 2913,
                        pattern_start => 2852,
                        pattern_end => 2860})
    end,
    {untyped_query,
        <<""/utf8>>,
        1,
        Name@1,
        [],
        <<"
select enumlabel
from pg_enum
where enumtypid = $1
order by enumsortorder asc
"/utf8>>}.

-file("src/squirrel/internal/database/postgres.gleam", 109).
?DOC(false).
-spec find_column_nullability_query() -> squirrel@internal@query:untyped_query().
find_column_nullability_query() ->
    Name@1 = case squirrel@internal@gleam:value_identifier(
        <<"find_column_nullability_query"/utf8>>
    ) of
        {ok, Name} -> Name;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"squirrel/internal/database/postgres"/utf8>>,
                        function => <<"find_column_nullability_query"/utf8>>,
                        line => 110,
                        value => _assert_fail,
                        start => 3159,
                        'end' => 3236,
                        pattern_start => 3170,
                        pattern_end => 3178})
    end,
    {untyped_query,
        <<""/utf8>>,
        1,
        Name@1,
        [],
        <<"
select
  -- Whether the column has a not-null constraint.
  attnotnull
from pg_attribute
where
  -- The oid of the table the column comes from.
  attrelid = $1
  -- The index of the column we're looking for.
  and attnum = $2
"/utf8>>}.

-file("src/squirrel/internal/database/postgres.gleam", 131).
?DOC(false).
-spec find_postgres_version_query() -> squirrel@internal@query:untyped_query().
find_postgres_version_query() ->
    Name@1 = case squirrel@internal@gleam:value_identifier(
        <<"find_postgres_version_query"/utf8>>
    ) of
        {ok, Name} -> Name;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"squirrel/internal/database/postgres"/utf8>>,
                        function => <<"find_postgres_version_query"/utf8>>,
                        line => 132,
                        value => _assert_fail,
                        start => 3628,
                        'end' => 3703,
                        pattern_start => 3639,
                        pattern_end => 3647})
    end,
    {untyped_query,
        <<""/utf8>>,
        1,
        Name@1,
        [],
        <<"select current_setting('server_version_num')"/utf8>>}.

-file("src/squirrel/internal/database/postgres.gleam", 287).
?DOC(false).
-spec wrap_in_list(squirrel@internal@gleam:type(), integer()) -> squirrel@internal@gleam:type().
wrap_in_list(Value, Times) ->
    case Times =< 0 of
        true ->
            Value;

        _ ->
            wrap_in_list({list, Value}, Times - 1)
    end.

-file("src/squirrel/internal/database/postgres.gleam", 526).
?DOC(false).
-spec check_sasl_final_message(bitstring(), bitstring(), binary()) -> eval:eval(nil, squirrel@internal@error:error(), context()).
check_sasl_final_message(Msg, Expected_server_proof, User) ->
    case squirrel@internal@scram:parse_server_final(Msg) of
        {error, nil} ->
            eval:throw(pg_invalid_sha256_server_proof);

        {ok, {failed, _}} ->
            eval:throw({pg_invalid_password, User});

        {ok, {successful, Server_proof}} ->
            case Server_proof =:= Expected_server_proof of
                true ->
                    eval:return(nil);

                false ->
                    eval:throw(pg_invalid_sha256_server_proof)
            end
    end.

-file("src/squirrel/internal/database/postgres.gleam", 875).
?DOC(false).
-spec plan_outputs_indices(plan(), gleam@dict:dict(binary(), integer())) -> gleam@set:set(integer()).
plan_outputs_indices(Plan, Query_outputs) ->
    gleam@list:fold(
        erlang:element(3, Plan),
        gleam@set:new(),
        fun(Nullables, Output) ->
            case gleam_stdlib:map_get(Query_outputs, Output) of
                {ok, I} ->
                    gleam@set:insert(Nullables, I);

                {error, _} ->
                    Nullables
            end
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 822).
?DOC(false).
-spec do_nullables_from_plan(
    plan(),
    gleam@dict:dict(binary(), integer()),
    gleam@set:set(integer())
) -> gleam@set:set(integer()).
do_nullables_from_plan(Plan, Query_outputs, Nullables) ->
    case {erlang:element(2, Plan), erlang:element(4, Plan)} of
        {{some, full_join}, _} ->
            _pipe = plan_outputs_indices(Plan, Query_outputs),
            gleam@set:union(_pipe, Nullables);

        {{some, right_join}, [Left, Right]} ->
            Nullables@1 = begin
                _pipe@1 = plan_outputs_indices(Left, Query_outputs),
                gleam@set:union(_pipe@1, Nullables)
            end,
            do_nullables_from_plan(Right, Query_outputs, Nullables@1);

        {{some, left_join}, [Left@1, Right@1]} ->
            Nullables@2 = begin
                _pipe@2 = plan_outputs_indices(Right@1, Query_outputs),
                gleam@set:union(_pipe@2, Nullables)
            end,
            do_nullables_from_plan(Left@1, Query_outputs, Nullables@2);

        {{some, semi_join}, [Left@1, Right@1]} ->
            Nullables@2 = begin
                _pipe@2 = plan_outputs_indices(Right@1, Query_outputs),
                gleam@set:union(_pipe@2, Nullables)
            end,
            do_nullables_from_plan(Left@1, Query_outputs, Nullables@2);

        {{some, right_join}, Plans} ->
            gleam@list:fold(
                Plans,
                Nullables,
                fun(Nullables@3, Plan@1) ->
                    do_nullables_from_plan(Plan@1, Query_outputs, Nullables@3)
                end
            );

        {{some, left_join}, Plans} ->
            gleam@list:fold(
                Plans,
                Nullables,
                fun(Nullables@3, Plan@1) ->
                    do_nullables_from_plan(Plan@1, Query_outputs, Nullables@3)
                end
            );

        {{some, semi_join}, Plans} ->
            gleam@list:fold(
                Plans,
                Nullables,
                fun(Nullables@3, Plan@1) ->
                    do_nullables_from_plan(Plan@1, Query_outputs, Nullables@3)
                end
            );

        {none, Plans} ->
            gleam@list:fold(
                Plans,
                Nullables,
                fun(Nullables@3, Plan@1) ->
                    do_nullables_from_plan(Plan@1, Query_outputs, Nullables@3)
                end
            );

        {{some, inner_join}, Plans@1} ->
            gleam@list:fold(
                Plans@1,
                Nullables,
                fun(Nullables@4, Plan@2) ->
                    do_nullables_from_plan(Plan@2, Query_outputs, Nullables@4)
                end
            )
    end.

-file("src/squirrel/internal/database/postgres.gleam", 817).
?DOC(false).
-spec nullables_from_plan(plan()) -> gleam@set:set(integer()).
nullables_from_plan(Plan) ->
    Outputs = gleam@list:index_fold(
        erlang:element(3, Plan),
        maps:new(),
        fun gleam@dict:insert/3
    ),
    do_nullables_from_plan(Plan, Outputs, gleam@set:new()).

-file("src/squirrel/internal/database/postgres.gleam", 1125).
?DOC(false).
-spec fields_to_permission_denied_error(
    binary(),
    gleam@set:set(squirrel@internal@database@postgres_protocol:error_or_notice_field())
) -> {ok, squirrel@internal@error:error()} | {error, nil}.
fields_to_permission_denied_error(Query_file, Fields) ->
    {Code@2, Reason@2} = begin
        gleam@set:fold(
            Fields,
            {none, none},
            fun(_use0, Field) ->
                {Code, Reason} = _use0,
                case Field of
                    {code, Code@1} ->
                        {{some, Code@1}, Reason};

                    {message, Reason@1} ->
                        {Code, {some, Reason@1}};

                    _ ->
                        {Code, Reason}
                end
            end
        )
    end,
    case {Code@2, Reason@2} of
        {{some, <<"42501"/utf8>>}, {some, Reason@3}} ->
            {ok, {pg_permission_denied, Query_file, Reason@3}};

        {_, _} ->
            {error, nil}
    end.

-file("src/squirrel/internal/database/postgres.gleam", 1146).
?DOC(false).
-spec 'receive'() -> eval:eval(squirrel@internal@database@postgres_protocol:backend_message(), squirrel@internal@error:error(), context()).
'receive'() ->
    eval:from(
        fun(_use0) ->
            {context, Db, _, _} = Context = _use0,
            case squirrel@internal@database@postgres_protocol:'receive'(Db) of
                {ok, {Db@1, Msg}} ->
                    {{context,
                            Db@1,
                            erlang:element(3, Context),
                            erlang:element(4, Context)},
                        {ok, Msg}};

                {error, {read_decode_error, Error}} ->
                    {Context,
                        {error,
                            {pg_cannot_decode_received_message,
                                gleam@string:inspect(Error)}}};

                {error, {socket_error, Error@1}} ->
                    {Context,
                        {error,
                            {pg_cannot_receive_message,
                                gleam@string:inspect(Error@1)}}}
            end
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 1055).
?DOC(false).
-spec do_accumulate_data_rows_until_command_complete(
    binary(),
    list(list(bitstring()))
) -> eval:eval(list(list(bitstring())), squirrel@internal@error:error(), context()).
do_accumulate_data_rows_until_command_complete(Query_file, Acc) ->
    eval:'try'('receive'(), fun(Msg) -> case Msg of
                {be_command_complete, _, _} ->
                    eval:return(lists:reverse(Acc));

                {be_message_data_row, Data} ->
                    do_accumulate_data_rows_until_command_complete(
                        Query_file,
                        [Data | Acc]
                    );

                {be_error_response, Fields} ->
                    case fields_to_permission_denied_error(Query_file, Fields) of
                        {ok, Error} ->
                            eval:throw(Error);

                        {error, _} ->
                            erlang:error(#{gleam_error => panic,
                                    message => gleam@string:inspect(Msg),
                                    file => <<?FILEPATH/utf8>>,
                                    module => <<"squirrel/internal/database/postgres"/utf8>>,
                                    function => <<"do_accumulate_data_rows_until_command_complete"/utf8>>,
                                    line => 1067})
                    end;

                _ ->
                    erlang:error(#{gleam_error => panic,
                            message => gleam@string:inspect(Msg),
                            file => <<?FILEPATH/utf8>>,
                            module => <<"squirrel/internal/database/postgres"/utf8>>,
                            function => <<"do_accumulate_data_rows_until_command_complete"/utf8>>,
                            line => 1069})
            end end).

-file("src/squirrel/internal/database/postgres.gleam", 1051).
?DOC(false).
-spec accumulate_data_rows_until_command_complete(binary()) -> eval:eval(list(list(bitstring())), squirrel@internal@error:error(), context()).
accumulate_data_rows_until_command_complete(Query_file) ->
    do_accumulate_data_rows_until_command_complete(Query_file, []).

-file("src/squirrel/internal/database/postgres.gleam", 1163).
?DOC(false).
-spec send(squirrel@internal@database@postgres_protocol:frontend_message()) -> eval:eval(nil, squirrel@internal@error:error(), context()).
send(Message) ->
    eval:from(
        fun(_use0) ->
            {context, Db, _, _} = Context = _use0,
            Result = begin
                _pipe = Message,
                _pipe@1 = squirrel@internal@database@postgres_protocol:encode_frontend_message(
                    _pipe
                ),
                squirrel@internal@database@postgres_protocol:send(Db, _pipe@1)
            end,
            {Db@2, Result@1} = case Result of
                {ok, Db@1} ->
                    {Db@1, {ok, nil}};

                {error, Error} ->
                    {Db,
                        {error,
                            {pg_cannot_send_message,
                                gleam@string:inspect(Error)}}}
            end,
            {{context,
                    Db@2,
                    erlang:element(3, Context),
                    erlang:element(4, Context)},
                Result@1}
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 1184).
?DOC(false).
-spec send_all(
    list(squirrel@internal@database@postgres_protocol:frontend_message())
) -> eval:eval(nil, squirrel@internal@error:error(), context()).
send_all(Messages) ->
    squirrel@internal@eval_extra:try_fold(
        Messages,
        nil,
        fun(Acc, Msg) ->
            eval:'try'(send(Msg), fun(_) -> eval:return(Acc) end)
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 1198).
?DOC(false).
-spec do_wait_until_ready() -> eval:eval(nil, squirrel@internal@error:error(), context()).
do_wait_until_ready() ->
    eval:'try'('receive'(), fun(Msg) -> case Msg of
                {be_ready_for_query, _} ->
                    eval:return(nil);

                _ ->
                    do_wait_until_ready()
            end end).

-file("src/squirrel/internal/database/postgres.gleam", 1193).
?DOC(false).
-spec wait_until_ready() -> eval:eval(nil, squirrel@internal@error:error(), context()).
wait_until_ready() ->
    eval:'try'(send(fe_flush), fun(_) -> do_wait_until_ready() end).

-file("src/squirrel/internal/database/postgres.gleam", 1209).
?DOC(false).
-spec unexpected_message(
    fun((binary(), binary()) -> squirrel@internal@error:error()),
    binary(),
    squirrel@internal@database@postgres_protocol:backend_message()
) -> eval:eval(any(), squirrel@internal@error:error(), any()).
unexpected_message(Builder, Expected, Got) ->
    _pipe = Builder(Expected, gleam@string:inspect(Got)),
    eval:throw(_pipe).

-file("src/squirrel/internal/database/postgres.gleam", 419).
?DOC(false).
-spec cleartext_authenticate(binary(), binary()) -> eval:eval(nil, squirrel@internal@error:error(), context()).
cleartext_authenticate(User, Password) ->
    eval:'try'(
        send({fe_ambigous, {fe_password_message, Password}}),
        fun(_) -> eval:'try'('receive'(), fun(Msg) -> case Msg of
                        be_authentication_ok ->
                            eval:return(nil);

                        {be_error_response, _} ->
                            eval:throw({pg_invalid_password, User});

                        _ ->
                            unexpected_message(
                                fun(Field@0, Field@1) -> {pg_unexpected_cleartext_auth_message, Field@0, Field@1} end,
                                <<"AuthenticationOk ok ErrorRespose"/utf8>>,
                                Msg
                            )
                    end end) end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 486).
?DOC(false).
-spec expect_sasl_continue_message(
    squirrel@internal@database@postgres_protocol:backend_message()
) -> eval:eval(bitstring(), squirrel@internal@error:error(), context()).
expect_sasl_continue_message(Msg) ->
    case Msg of
        {be_authentication_s_a_s_l_continue, Server_first} ->
            eval:return(Server_first);

        _ ->
            unexpected_message(
                fun(Field@0, Field@1) -> {pg_unexpected_sha256_auth_message, Field@0, Field@1} end,
                <<"AuthenticationSASLContinue(server-first)"/utf8>>,
                Msg
            )
    end.

-file("src/squirrel/internal/database/postgres.gleam", 504).
?DOC(false).
-spec expect_sasl_final_message(
    squirrel@internal@database@postgres_protocol:backend_message(),
    binary()
) -> eval:eval(bitstring(), squirrel@internal@error:error(), any()).
expect_sasl_final_message(Msg, User) ->
    Unexpected_message = unexpected_message(
        fun(Field@0, Field@1) -> {pg_unexpected_sha256_auth_message, Field@0, Field@1} end,
        <<"AuthenticationSASLFinal or BeErrorResponse"/utf8>>,
        Msg
    ),
    case Msg of
        {be_authentication_s_a_s_l_final, Msg@1} ->
            eval:return(Msg@1);

        {be_error_response, Fields} ->
            case gleam@set:contains(Fields, {code, <<"28P01"/utf8>>}) of
                true ->
                    eval:throw({pg_invalid_password, User});

                false ->
                    Unexpected_message
            end;

        _ ->
            Unexpected_message
    end.

-file("src/squirrel/internal/database/postgres.gleam", 437).
?DOC(false).
-spec sha_256_authenticate(binary(), binary()) -> eval:eval(nil, squirrel@internal@error:error(), context()).
sha_256_authenticate(User, Password) ->
    Nonce = squirrel@internal@scram:nonce(),
    Client_first_msg = {client_first, User, Nonce},
    eval:'try'(
        begin
            _pipe = squirrel@internal@scram:encode_client_first(
                Client_first_msg
            ),
            _pipe@1 = {fe_sasl_initial_response,
                <<"SCRAM-SHA-256"/utf8>>,
                _pipe},
            _pipe@2 = {fe_ambigous, _pipe@1},
            send(_pipe@2)
        end,
        fun(_) ->
            eval:'try'(
                'receive'(),
                fun(Msg) ->
                    eval:'try'(
                        expect_sasl_continue_message(Msg),
                        fun(Raw_server_first_msg) ->
                            Server_first_msg@1 = case squirrel@internal@scram:parse_server_first(
                                Raw_server_first_msg,
                                Nonce
                            ) of
                                {ok, Server_first_msg} -> Server_first_msg;
                                _assert_fail ->
                                    erlang:error(#{gleam_error => let_assert,
                                                message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                                file => <<?FILEPATH/utf8>>,
                                                module => <<"squirrel/internal/database/postgres"/utf8>>,
                                                function => <<"sha_256_authenticate"/utf8>>,
                                                line => 456,
                                                value => _assert_fail,
                                                start => 14313,
                                                'end' => 14404,
                                                pattern_start => 14324,
                                                pattern_end => 14344})
                            end,
                            Client_last_msg = {client_last,
                                Client_first_msg,
                                Server_first_msg@1,
                                Password},
                            {Client_last_msg@1, Expected_server_proof} = squirrel@internal@scram:encode_client_last(
                                Client_last_msg
                            ),
                            eval:'try'(
                                begin
                                    _pipe@3 = Client_last_msg@1,
                                    _pipe@4 = {fe_sasl_response, _pipe@3},
                                    _pipe@5 = {fe_ambigous, _pipe@4},
                                    send(_pipe@5)
                                end,
                                fun(_) ->
                                    eval:'try'(
                                        'receive'(),
                                        fun(Msg@1) ->
                                            eval:'try'(
                                                expect_sasl_final_message(
                                                    Msg@1,
                                                    User
                                                ),
                                                fun(Msg@2) ->
                                                    check_sasl_final_message(
                                                        Msg@2,
                                                        Expected_server_proof,
                                                        User
                                                    )
                                                end
                                            )
                                        end
                                    )
                                end
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 1117).
?DOC(false).
-spec expect_ready_for_query_then_throw(
    squirrel@internal@error:error(),
    fun((binary(), binary()) -> squirrel@internal@error:error())
) -> eval:eval(any(), squirrel@internal@error:error(), context()).
expect_ready_for_query_then_throw(Error, To_error) ->
    eval:'try'('receive'(), fun(Msg) -> case Msg of
                {be_ready_for_query, _} ->
                    eval:throw(Error);

                _ ->
                    unexpected_message(
                        To_error,
                        <<"BeReadyForQuery(_)"/utf8>>,
                        Msg
                    )
            end end).

-file("src/squirrel/internal/database/postgres.gleam", 1219).
?DOC(false).
-spec unsupported_authentication(binary()) -> eval:eval(any(), squirrel@internal@error:error(), context()).
unsupported_authentication(Auth) ->
    eval:throw({pg_unsupported_authentication, Auth}).

-file("src/squirrel/internal/database/postgres.gleam", 358).
?DOC(false).
-spec authenticate(binary(), binary(), binary()) -> eval:eval(nil, squirrel@internal@error:error(), context()).
authenticate(User, Database, Password) ->
    Params = [{<<"user"/utf8>>, User}, {<<"database"/utf8>>, Database}],
    eval:'try'(
        send({fe_startup_message, Params}),
        fun(_) -> eval:'try'('receive'(), fun(Msg) -> eval:'try'(case Msg of
                            be_authentication_ok ->
                                eval:return(nil);

                            be_authentication_cleartext_password ->
                                cleartext_authenticate(User, Password);

                            {be_authentication_m_d5_password, _} ->
                                unsupported_authentication(<<"md5"/utf8>>);

                            be_authentication_g_s_s ->
                                unsupported_authentication(<<"GSS"/utf8>>);

                            {be_authentication_s_a_s_l, Methods} ->
                                case gleam@list:contains(
                                    Methods,
                                    <<"SCRAM-SHA-256"/utf8>>
                                ) of
                                    true ->
                                        sha_256_authenticate(User, Password);

                                    _ ->
                                        _pipe = case gleam@list:filter(
                                            Methods,
                                            fun(Method) ->
                                                Method /= <<""/utf8>>
                                            end
                                        ) of
                                            [_ | _] ->
                                                <<<<"SASL("/utf8,
                                                        (gleam@string:join(
                                                            Methods,
                                                            <<","/utf8>>
                                                        ))/binary>>/binary,
                                                    ")"/utf8>>;

                                            [] ->
                                                <<"SASL"/utf8>>
                                        end,
                                        unsupported_authentication(_pipe)
                                end;

                            be_authentication_s_s_p_i ->
                                unsupported_authentication(<<"SSPI"/utf8>>);

                            be_authentication_kerberos_v5 ->
                                unsupported_authentication(
                                    <<"KerberosV5"/utf8>>
                                );

                            _ ->
                                unexpected_message(
                                    fun(Field@0, Field@1) -> {pg_unexpected_auth_method_message, Field@0, Field@1} end,
                                    <<"AuthMethod"/utf8>>,
                                    Msg
                                )
                        end, fun(_) ->
                            eval:'try'(
                                begin
                                    _pipe@1 = wait_until_ready(),
                                    eval:replace_error(
                                        _pipe@1,
                                        {pg_invalid_user_database,
                                            User,
                                            Database}
                                    )
                                end,
                                fun(_) -> eval:return(nil) end
                            )
                        end) end) end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 1228).
?DOC(false).
-spec with_cached_gleam_type(
    integer(),
    fun(() -> eval:eval(squirrel@internal@gleam:type(), squirrel@internal@error:error(), context()))
) -> eval:eval(squirrel@internal@gleam:type(), squirrel@internal@error:error(), context()).
with_cached_gleam_type(Oid, Do) ->
    eval:from(
        fun(Context) ->
            case gleam_stdlib:map_get(erlang:element(3, Context), Oid) of
                {ok, Type_} ->
                    {Context, {ok, Type_}};

                {error, _} ->
                    case eval:step(Do(), Context) of
                        {_, {error, _}} = Result ->
                            Result;

                        {{context, _, Gleam_types, _} = Context@1,
                            {ok, Type_@1}} ->
                            Gleam_types@1 = gleam@dict:insert(
                                Gleam_types,
                                Oid,
                                Type_@1
                            ),
                            New_context = {context,
                                erlang:element(2, Context@1),
                                Gleam_types@1,
                                erlang:element(4, Context@1)},
                            {New_context, {ok, Type_@1}}
                    end
            end
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 1252).
?DOC(false).
-spec with_cached_column(
    integer(),
    integer(),
    fun(() -> eval:eval(nullability(), squirrel@internal@error:error(), context()))
) -> eval:eval(nullability(), squirrel@internal@error:error(), context()).
with_cached_column(Table_oid, Column, Do) ->
    eval:from(
        fun(Context) ->
            Key = {Table_oid, Column},
            case gleam_stdlib:map_get(erlang:element(4, Context), Key) of
                {ok, Type_} ->
                    {Context, {ok, Type_}};

                {error, _} ->
                    case eval:step(Do(), Context) of
                        {_, {error, _}} = Result ->
                            Result;

                        {{context, _, _, Column_nullability} = Context@1,
                            {ok, Type_@1}} ->
                            Column_nullability@1 = gleam@dict:insert(
                                Column_nullability,
                                Key,
                                Type_@1
                            ),
                            New_context = {context,
                                erlang:element(2, Context@1),
                                erlang:element(3, Context@1),
                                Column_nullability@1},
                            {New_context, {ok, Type_@1}}
                    end
            end
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 1275).
?DOC(false).
-spec unsupported_type_error(squirrel@internal@query:untyped_query(), binary()) -> squirrel@internal@error:error().
unsupported_type_error(Query, Type_) ->
    {untyped_query, File, Starting_line, Name, _, Content} = Query,
    {query_has_unsupported_type,
        File,
        squirrel@internal@gleam:value_identifier_to_string(Name),
        Content,
        Starting_line,
        Type_}.

-file("src/squirrel/internal/database/postgres.gleam", 1286).
?DOC(false).
-spec invalid_enum_error(
    squirrel@internal@query:untyped_query(),
    binary(),
    squirrel@internal@error:enum_error()
) -> squirrel@internal@error:error().
invalid_enum_error(Query, Enum_name, Reason) ->
    {untyped_query, File, Starting_line, _, _, Content} = Query,
    {query_has_invalid_enum, File, Content, Starting_line, Enum_name, Reason}.

-file("src/squirrel/internal/database/postgres.gleam", 251).
?DOC(false).
-spec pg_to_gleam_type(
    squirrel@internal@query:untyped_query(),
    pg_type(),
    integer()
) -> {ok, squirrel@internal@gleam:type()} |
    {error, squirrel@internal@error:error()}.
pg_to_gleam_type(Query, Type_, List_wrappings) ->
    _pipe@1 = case Type_ of
        {p_base, Name} ->
            case Name of
                <<"bool"/utf8>> ->
                    {ok, bool};

                <<"text"/utf8>> ->
                    {ok, string};

                <<"char"/utf8>> ->
                    {ok, string};

                <<"bpchar"/utf8>> ->
                    {ok, string};

                <<"varchar"/utf8>> ->
                    {ok, string};

                <<"citext"/utf8>> ->
                    {ok, string};

                <<"name"/utf8>> ->
                    {ok, string};

                <<"float4"/utf8>> ->
                    {ok, float};

                <<"float8"/utf8>> ->
                    {ok, float};

                <<"numeric"/utf8>> ->
                    {ok, numeric};

                <<"int2"/utf8>> ->
                    {ok, int};

                <<"int4"/utf8>> ->
                    {ok, int};

                <<"int8"/utf8>> ->
                    {ok, int};

                <<"json"/utf8>> ->
                    {ok, json};

                <<"jsonb"/utf8>> ->
                    {ok, json};

                <<"uuid"/utf8>> ->
                    {ok, uuid};

                <<"bytea"/utf8>> ->
                    {ok, bit_array};

                <<"date"/utf8>> ->
                    {ok, date};

                <<"time"/utf8>> ->
                    {ok, time_of_day};

                <<"timestamp"/utf8>> ->
                    {ok, timestamp};

                _ ->
                    {error, unsupported_type_error(Query, Name)}
            end;

        {p_enum, Name@1, Variants} ->
            _pipe = squirrel@internal@gleam:try_make_enum(Name@1, Variants),
            gleam@result:map_error(
                _pipe,
                fun(_capture) -> invalid_enum_error(Query, Name@1, _capture) end
            )
    end,
    gleam@result:map(
        _pipe@1,
        fun(_capture@1) -> wrap_in_list(_capture@1, List_wrappings) end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 1297).
?DOC(false).
-spec cannot_parse_error(
    squirrel@internal@query:untyped_query(),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(binary()),
    gleam@option:option(squirrel@internal@error:pointer())
) -> squirrel@internal@error:error().
cannot_parse_error(Query, Error_code, Hint, Additional_error_message, Pointer) ->
    {untyped_query, File, Starting_line, Name, _, Content} = Query,
    {cannot_parse_query,
        File,
        squirrel@internal@gleam:value_identifier_to_string(Name),
        Content,
        Starting_line,
        Error_code,
        Pointer,
        Additional_error_message,
        Hint}.

-file("src/squirrel/internal/database/postgres.gleam", 655).
?DOC(false).
-spec error_fields_to_parse_error(
    squirrel@internal@query:untyped_query(),
    gleam@set:set(squirrel@internal@database@postgres_protocol:error_or_notice_field())
) -> squirrel@internal@error:error().
error_fields_to_parse_error(Query, Errors) ->
    {Error_code, Message@2, Position@3, Hint@2} = begin
        gleam@set:fold(
            Errors,
            {none, none, none, none},
            fun(Acc, Error_field) ->
                {Code, Message, Position, Hint} = Acc,
                case Error_field of
                    {code, Code@1} ->
                        {{some, Code@1}, Message, Position, Hint};

                    {message, Message@1} ->
                        {Code, {some, Message@1}, Position, Hint};

                    {hint, Hint@1} ->
                        {Code, Message, Position, {some, Hint@1}};

                    {position, Position@1} ->
                        case gleam_stdlib:parse_int(Position@1) of
                            {ok, Position@2} ->
                                {Code, Message, {some, Position@2}, Hint};

                            {error, _} ->
                                Acc
                        end;

                    _ ->
                        Acc
                end
            end
        )
    end,
    {Pointer, Additional_error_message} = case {Message@2, Position@3} of
        {{some, Message@3}, {some, Position@4}} ->
            {{some, {pointer, {byte_index, Position@4}, Message@3}}, none};

        {{some, Message@4}, none} ->
            {none, {some, Message@4}};

        {_, _} ->
            {none, none}
    end,
    cannot_parse_error(
        Query,
        Error_code,
        Hint@2,
        Additional_error_message,
        Pointer
    ).

-file("src/squirrel/internal/database/postgres.gleam", 583).
?DOC(false).
-spec parameters_and_returns(squirrel@internal@query:untyped_query()) -> eval:eval({list(integer()),
    list(squirrel@internal@database@postgres_protocol:row_description_field())}, squirrel@internal@error:error(), context()).
parameters_and_returns(Query) ->
    eval:'try'(
        send_all(
            [{fe_parse, <<""/utf8>>, erlang:element(6, Query), []},
                {fe_describe, prepared_statement, <<""/utf8>>},
                fe_sync]
        ),
        fun(_) ->
            Cannot_describe = fun(Expected, Got) ->
                {pg_cannot_describe_query,
                    erlang:element(2, Query),
                    squirrel@internal@gleam:value_identifier_to_string(
                        erlang:element(4, Query)
                    ),
                    Expected,
                    Got}
            end,
            eval:'try'('receive'(), fun(Msg) -> case Msg of
                        {be_error_response, Errors} ->
                            eval:'try'('receive'(), fun(Msg@1) -> case Msg@1 of
                                        {be_ready_for_query, _} ->
                                            eval:throw(
                                                error_fields_to_parse_error(
                                                    Query,
                                                    Errors
                                                )
                                            );

                                        _ ->
                                            unexpected_message(
                                                Cannot_describe,
                                                <<"BeReadyForQuery(_)"/utf8>>,
                                                Msg@1
                                            )
                                    end end);

                        be_parse_complete ->
                            eval:'try'(
                                'receive'(),
                                fun(Msg@2) -> eval:'try'(case Msg@2 of
                                            {be_parameter_description,
                                                Parameters} ->
                                                eval:return(Parameters);

                                            be_no_data ->
                                                eval:return([]);

                                            _ ->
                                                unexpected_message(
                                                    Cannot_describe,
                                                    <<"ParameterDescription"/utf8>>,
                                                    Msg@2
                                                )
                                        end, fun(Parameters@1) ->
                                            eval:'try'(
                                                'receive'(),
                                                fun(Msg@3) ->
                                                    eval:'try'(case Msg@3 of
                                                            {be_row_descriptions,
                                                                Rows} ->
                                                                eval:return(
                                                                    Rows
                                                                );

                                                            be_no_data ->
                                                                eval:return([]);

                                                            _ ->
                                                                unexpected_message(
                                                                    Cannot_describe,
                                                                    <<"RowDescriptions"/utf8>>,
                                                                    Msg@3
                                                                )
                                                        end, fun(Rows@1) ->
                                                            eval:'try'(
                                                                'receive'(),
                                                                fun(Msg@4) ->
                                                                    eval:'try'(
                                                                        case Msg@4 of
                                                                            {be_ready_for_query,
                                                                                _} ->
                                                                                eval:return(
                                                                                    nil
                                                                                );

                                                                            _ ->
                                                                                unexpected_message(
                                                                                    Cannot_describe,
                                                                                    <<"ReadyForQuery"/utf8>>,
                                                                                    Msg@4
                                                                                )
                                                                        end,
                                                                        fun(_) ->
                                                                            eval:return(
                                                                                {Parameters@1,
                                                                                    Rows@1}
                                                                            )
                                                                        end
                                                                    )
                                                                end
                                                            )
                                                        end)
                                                end
                                            )
                                        end) end
                            );

                        _ ->
                            unexpected_message(
                                Cannot_describe,
                                <<"ParseComplete or ErrorResponse"/utf8>>,
                                Msg
                            )
                    end end)
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 1073).
?DOC(false).
-spec expect_parse_complete(
    squirrel@internal@database@postgres_protocol:backend_message(),
    squirrel@internal@query:untyped_query()
) -> eval:eval(nil, squirrel@internal@error:error(), context()).
expect_parse_complete(Msg, Query) ->
    case Msg of
        be_parse_complete ->
            eval:return(nil);

        {be_error_response, Fields} ->
            {untyped_query, File, _, Name, _, _} = Query,
            Query_name = squirrel@internal@gleam:value_identifier_to_string(
                Name
            ),
            Unexpected = fun(Expected, Got) ->
                {pg_cannot_describe_query, File, Query_name, Expected, Got}
            end,
            Parse_error = error_fields_to_parse_error(Query, Fields),
            expect_ready_for_query_then_throw(Parse_error, Unexpected);

        _ ->
            erlang:error(#{gleam_error => panic,
                    message => gleam@string:inspect(Msg),
                    file => <<?FILEPATH/utf8>>,
                    module => <<"squirrel/internal/database/postgres"/utf8>>,
                    function => <<"expect_parse_complete"/utf8>>,
                    line => 1087})
    end.

-file("src/squirrel/internal/database/postgres.gleam", 991).
?DOC(false).
-spec run_query(
    squirrel@internal@query:untyped_query(),
    list(squirrel@internal@database@postgres_protocol:parameter_value()),
    list(integer())
) -> eval:eval(list(list(bitstring())), squirrel@internal@error:error(), context()).
run_query(Query, Parameters, Parameters_object_ids) ->
    eval:'try'(
        send_all(
            [{fe_parse,
                    <<""/utf8>>,
                    erlang:element(6, Query),
                    Parameters_object_ids},
                {fe_bind,
                    <<""/utf8>>,
                    <<""/utf8>>,
                    {format_all, binary},
                    Parameters,
                    {format_all, binary}},
                {fe_execute, <<""/utf8>>, 0},
                {fe_close, prepared_statement, <<""/utf8>>},
                {fe_close, portal, <<""/utf8>>},
                fe_sync]
        ),
        fun(_) ->
            eval:'try'(
                'receive'(),
                fun(Msg) ->
                    eval:'try'(
                        expect_parse_complete(Msg, Query),
                        fun(_) ->
                            eval:'try'(
                                'receive'(),
                                fun(Msg@1) ->
                                    case Msg@1 of
                                        be_bind_complete -> nil;
                                        _assert_fail ->
                                            erlang:error(
                                                    #{gleam_error => let_assert,
                                                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                                        file => <<?FILEPATH/utf8>>,
                                                        module => <<"squirrel/internal/database/postgres"/utf8>>,
                                                        function => <<"run_query"/utf8>>,
                                                        line => 1036,
                                                        value => _assert_fail,
                                                        start => 35387,
                                                        'end' => 35421,
                                                        pattern_start => 35398,
                                                        pattern_end => 35415}
                                                )
                                    end,
                                    eval:'try'(
                                        accumulate_data_rows_until_command_complete(
                                            erlang:element(2, Query)
                                        ),
                                        fun(Res) ->
                                            eval:'try'(
                                                'receive'(),
                                                fun(Msg@2) ->
                                                    case Msg@2 of
                                                        be_close_complete -> nil;
                                                        _assert_fail@1 ->
                                                            erlang:error(
                                                                    #{gleam_error => let_assert,
                                                                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                                                        file => <<?FILEPATH/utf8>>,
                                                                        module => <<"squirrel/internal/database/postgres"/utf8>>,
                                                                        function => <<"run_query"/utf8>>,
                                                                        line => 1039,
                                                                        value => _assert_fail@1,
                                                                        start => 35536,
                                                                        'end' => 35571,
                                                                        pattern_start => 35547,
                                                                        pattern_end => 35565}
                                                                )
                                                    end,
                                                    eval:'try'(
                                                        'receive'(),
                                                        fun(Msg@3) ->
                                                            case Msg@3 of
                                                                be_close_complete -> nil;
                                                                _assert_fail@2 ->
                                                                    erlang:error(
                                                                            #{gleam_error => let_assert,
                                                                                message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                                                                file => <<?FILEPATH/utf8>>,
                                                                                module => <<"squirrel/internal/database/postgres"/utf8>>,
                                                                                function => <<"run_query"/utf8>>,
                                                                                line => 1041,
                                                                                value => _assert_fail@2,
                                                                                start => 35607,
                                                                                'end' => 35642,
                                                                                pattern_start => 35618,
                                                                                pattern_end => 35636}
                                                                        )
                                                            end,
                                                            eval:'try'(
                                                                'receive'(),
                                                                fun(Msg@4) ->
                                                                    case Msg@4 of
                                                                        {be_ready_for_query,
                                                                            _} -> nil;
                                                                        _assert_fail@3 ->
                                                                            erlang:error(
                                                                                    #{gleam_error => let_assert,
                                                                                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                                                                        file => <<?FILEPATH/utf8>>,
                                                                                        module => <<"squirrel/internal/database/postgres"/utf8>>,
                                                                                        function => <<"run_query"/utf8>>,
                                                                                        line => 1043,
                                                                                        value => _assert_fail@3,
                                                                                        start => 35678,
                                                                                        'end' => 35716,
                                                                                        pattern_start => 35689,
                                                                                        pattern_end => 35710}
                                                                                )
                                                                    end,
                                                                    eval:return(
                                                                        Res
                                                                    )
                                                                end
                                                            )
                                                        end
                                                    )
                                                end
                                            )
                                        end
                                    )
                                end
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 747).
?DOC(false).
-spec resolve_enum_type(binary(), integer()) -> eval:eval(pg_type(), squirrel@internal@error:error(), context()).
resolve_enum_type(Name, Oid) ->
    Params = [{parameter, <<Oid:32>>}],
    eval:'try'(
        run_query(find_enum_variants_query(), Params, [23]),
        fun(Rows) ->
            Variants = gleam@list:map(
                Rows,
                fun(Row) ->
                    Variant@1 = case Row of
                        [Variant] -> Variant;
                        _assert_fail ->
                            erlang:error(#{gleam_error => let_assert,
                                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                        file => <<?FILEPATH/utf8>>,
                                        module => <<"squirrel/internal/database/postgres"/utf8>>,
                                        function => <<"resolve_enum_type"/utf8>>,
                                        line => 754,
                                        value => _assert_fail,
                                        start => 25397,
                                        'end' => 25423,
                                        pattern_start => 25408,
                                        pattern_end => 25417})
                    end,
                    Variant@3 = case gleam@bit_array:to_string(Variant@1) of
                        {ok, Variant@2} -> Variant@2;
                        _assert_fail@1 ->
                            erlang:error(#{gleam_error => let_assert,
                                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                        file => <<?FILEPATH/utf8>>,
                                        module => <<"squirrel/internal/database/postgres"/utf8>>,
                                        function => <<"resolve_enum_type"/utf8>>,
                                        line => 755,
                                        value => _assert_fail@1,
                                        start => 25430,
                                        'end' => 25483,
                                        pattern_start => 25441,
                                        pattern_end => 25452})
                    end,
                    Variant@3
                end
            ),
            eval:return({p_enum, Name, Variants})
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 718).
?DOC(false).
-spec find_gleam_type(squirrel@internal@query:untyped_query(), integer()) -> eval:eval(squirrel@internal@gleam:type(), squirrel@internal@error:error(), context()).
find_gleam_type(Query, Oid) ->
    with_cached_gleam_type(
        Oid,
        fun() ->
            Params = [{parameter, <<Oid:32>>}],
            eval:'try'(
                run_query(find_postgres_type_query(), Params, [23]),
                fun(Res) ->
                    {Oid@2, Name@1, Kind@1, List_wrappings@1} = case Res of
                        [[Oid@1, Name, Kind, List_wrappings]] -> {
                        Oid@1,
                            Name,
                            Kind,
                            List_wrappings};
                        _assert_fail ->
                            erlang:error(#{gleam_error => let_assert,
                                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                        file => <<?FILEPATH/utf8>>,
                                        module => <<"squirrel/internal/database/postgres"/utf8>>,
                                        function => <<"find_gleam_type"/utf8>>,
                                        line => 732,
                                        value => _assert_fail,
                                        start => 24617,
                                        'end' => 24669,
                                        pattern_start => 24628,
                                        pattern_end => 24663})
                    end,
                    Oid@4 = case Oid@2 of
                        <<Oid@3:32>> -> Oid@3;
                        _assert_fail@1 ->
                            erlang:error(#{gleam_error => let_assert,
                                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                        file => <<?FILEPATH/utf8>>,
                                        module => <<"squirrel/internal/database/postgres"/utf8>>,
                                        function => <<"find_gleam_type"/utf8>>,
                                        line => 733,
                                        value => _assert_fail@1,
                                        start => 24672,
                                        'end' => 24705,
                                        pattern_start => 24683,
                                        pattern_end => 24699})
                    end,
                    Name@3 = case gleam@bit_array:to_string(Name@1) of
                        {ok, Name@2} -> Name@2;
                        _assert_fail@2 ->
                            erlang:error(#{gleam_error => let_assert,
                                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                        file => <<?FILEPATH/utf8>>,
                                        module => <<"squirrel/internal/database/postgres"/utf8>>,
                                        function => <<"find_gleam_type"/utf8>>,
                                        line => 734,
                                        value => _assert_fail@2,
                                        start => 24708,
                                        'end' => 24755,
                                        pattern_start => 24719,
                                        pattern_end => 24727})
                    end,
                    Kind@3 = case gleam@bit_array:to_string(Kind@1) of
                        {ok, Kind@2} -> Kind@2;
                        _assert_fail@3 ->
                            erlang:error(#{gleam_error => let_assert,
                                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                        file => <<?FILEPATH/utf8>>,
                                        module => <<"squirrel/internal/database/postgres"/utf8>>,
                                        function => <<"find_gleam_type"/utf8>>,
                                        line => 735,
                                        value => _assert_fail@3,
                                        start => 24758,
                                        'end' => 24805,
                                        pattern_start => 24769,
                                        pattern_end => 24777})
                    end,
                    List_wrappings@3 = case List_wrappings@1 of
                        <<List_wrappings@2:32>> -> List_wrappings@2;
                        _assert_fail@4 ->
                            erlang:error(#{gleam_error => let_assert,
                                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                        file => <<?FILEPATH/utf8>>,
                                        module => <<"squirrel/internal/database/postgres"/utf8>>,
                                        function => <<"find_gleam_type"/utf8>>,
                                        line => 736,
                                        value => _assert_fail@4,
                                        start => 24808,
                                        'end' => 24863,
                                        pattern_start => 24819,
                                        pattern_end => 24846})
                    end,
                    eval:'try'(case Kind@3 of
                            <<"e"/utf8>> ->
                                resolve_enum_type(Name@3, Oid@4);

                            _ ->
                                eval:return({p_base, Name@3})
                        end, fun(Type_) ->
                            _pipe = pg_to_gleam_type(
                                Query,
                                Type_,
                                List_wrappings@3
                            ),
                            eval:from_result(_pipe)
                        end)
                end
            )
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 704).
?DOC(false).
-spec resolve_parameters(
    squirrel@internal@query:untyped_query(),
    list(integer())
) -> eval:eval(list(squirrel@internal@gleam:type()), squirrel@internal@error:error(), context()).
resolve_parameters(Query, Parameters) ->
    squirrel@internal@eval_extra:try_map(
        Parameters,
        fun(Oid) -> find_gleam_type(Query, Oid) end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 1317).
?DOC(false).
-spec invalid_column_error(
    squirrel@internal@query:untyped_query(),
    binary(),
    squirrel@internal@error:value_identifier_error()
) -> squirrel@internal@error:error().
invalid_column_error(Query, Column_name, Reason) ->
    {untyped_query, File, Starting_line, _, _, Content} = Query,
    {query_has_invalid_column,
        File,
        Column_name,
        begin
            _pipe = squirrel@internal@gleam:similar_value_identifier_string(
                Column_name
            ),
            gleam@option:from_result(_pipe)
        end,
        Content,
        Starting_line,
        Reason}.

-file("src/squirrel/internal/database/postgres.gleam", 1353).
?DOC(false).
-spec adjust_parse_error_for_explain(squirrel@internal@error:error()) -> squirrel@internal@error:error().
adjust_parse_error_for_explain(Error) ->
    case Error of
        {cannot_parse_query, _, _, _, _, _, Pointer, _, _} ->
            Pointer@1 = case Pointer of
                {some, {pointer, {byte_index, Index}, Message}} ->
                    {some, {pointer, {byte_index, Index - 45}, Message}};

                _ ->
                    Pointer
            end,
            {cannot_parse_query,
                erlang:element(2, Error),
                erlang:element(3, Error),
                erlang:element(4, Error),
                erlang:element(5, Error),
                erlang:element(6, Error),
                Pointer@1,
                erlang:element(8, Error),
                erlang:element(9, Error)};

        _ ->
            Error
    end.

-file("src/squirrel/internal/database/postgres.gleam", 1091).
?DOC(false).
-spec expect_query_plan_row_description(
    squirrel@internal@database@postgres_protocol:backend_message(),
    squirrel@internal@query:untyped_query()
) -> eval:eval(nil, squirrel@internal@error:error(), context()).
expect_query_plan_row_description(Msg, Query) ->
    case Msg of
        {be_row_descriptions,
            [{row_description_field, <<"QUERY PLAN"/utf8>>, _, _, _, _, _, _}]} ->
            eval:return(nil);

        {be_error_response, Fields} ->
            {untyped_query, File, _, Name, _, _} = Query,
            Query_name = squirrel@internal@gleam:value_identifier_to_string(
                Name
            ),
            Unexpected = fun(Expected, Got) ->
                {pg_cannot_explain_query, File, Query_name, Expected, Got}
            end,
            Parse_error = begin
                _pipe = error_fields_to_parse_error(Query, Fields),
                adjust_parse_error_for_explain(_pipe)
            end,
            expect_ready_for_query_then_throw(Parse_error, Unexpected);

        _ ->
            erlang:error(#{gleam_error => panic,
                    message => gleam@string:inspect(Msg),
                    file => <<?FILEPATH/utf8>>,
                    module => <<"squirrel/internal/database/postgres"/utf8>>,
                    function => <<"expect_query_plan_row_description"/utf8>>,
                    line => 1113})
    end.

-file("src/squirrel/internal/database/postgres.gleam", 797).
?DOC(false).
-spec run_explain_query(squirrel@internal@query:untyped_query()) -> eval:eval(bitstring(), squirrel@internal@error:error(), context()).
run_explain_query(Query) ->
    Explain_query = <<"explain (format json, verbose, generic_plan) "/utf8,
        (erlang:element(6, Query))/binary>>,
    eval:'try'(
        send_all([{fe_query, Explain_query}]),
        fun(_) ->
            eval:'try'(
                'receive'(),
                fun(Msg) ->
                    eval:'try'(
                        expect_query_plan_row_description(Msg, Query),
                        fun(_) ->
                            eval:'try'(
                                'receive'(),
                                fun(Msg@1) ->
                                    Query_plan@1 = case Msg@1 of
                                        {be_message_data_row, [Query_plan]} -> Query_plan;
                                        _assert_fail ->
                                            erlang:error(
                                                    #{gleam_error => let_assert,
                                                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                                        file => <<?FILEPATH/utf8>>,
                                                        module => <<"squirrel/internal/database/postgres"/utf8>>,
                                                        function => <<"run_explain_query"/utf8>>,
                                                        line => 806,
                                                        value => _assert_fail,
                                                        start => 27049,
                                                        'end' => 27099,
                                                        pattern_start => 27060,
                                                        pattern_end => 27093}
                                                )
                                    end,
                                    eval:'try'(
                                        'receive'(),
                                        fun(Msg@2) ->
                                            case Msg@2 of
                                                {be_command_complete, _, _} -> nil;
                                                _assert_fail@1 ->
                                                    erlang:error(
                                                            #{gleam_error => let_assert,
                                                                message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                                                file => <<?FILEPATH/utf8>>,
                                                                module => <<"squirrel/internal/database/postgres"/utf8>>,
                                                                function => <<"run_explain_query"/utf8>>,
                                                                line => 808,
                                                                value => _assert_fail@1,
                                                                start => 27135,
                                                                'end' => 27178,
                                                                pattern_start => 27146,
                                                                pattern_end => 27172}
                                                        )
                                            end,
                                            eval:'try'(
                                                'receive'(),
                                                fun(Msg@3) ->
                                                    case Msg@3 of
                                                        {be_ready_for_query, _} -> nil;
                                                        _assert_fail@2 ->
                                                            erlang:error(
                                                                    #{gleam_error => let_assert,
                                                                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                                                        file => <<?FILEPATH/utf8>>,
                                                                        module => <<"squirrel/internal/database/postgres"/utf8>>,
                                                                        function => <<"run_explain_query"/utf8>>,
                                                                        line => 810,
                                                                        value => _assert_fail@2,
                                                                        start => 27214,
                                                                        'end' => 27252,
                                                                        pattern_start => 27225,
                                                                        pattern_end => 27246}
                                                                )
                                                    end,
                                                    eval:return(Query_plan@1)
                                                end
                                            )
                                        end
                                    )
                                end
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 1384).
?DOC(false).
-spec join_type_decoder() -> gleam@dynamic@decode:decoder(gleam@option:option(join_type())).
join_type_decoder() ->
    gleam@dynamic@decode:then(
        {decoder, fun gleam@dynamic@decode:decode_string/1},
        fun(Data) -> case Data of
                <<"Full"/utf8>> ->
                    gleam@dynamic@decode:success({some, full_join});

                <<"Left"/utf8>> ->
                    gleam@dynamic@decode:success({some, left_join});

                <<"Right"/utf8>> ->
                    gleam@dynamic@decode:success({some, right_join});

                <<"Inner"/utf8>> ->
                    gleam@dynamic@decode:success({some, inner_join});

                <<"Semi"/utf8>> ->
                    gleam@dynamic@decode:success({some, semi_join});

                _ ->
                    gleam@dynamic@decode:failure(none, <<"JoinType"/utf8>>)
            end end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 1377).
?DOC(false).
-spec plan_decoder() -> gleam@dynamic@decode:decoder(plan()).
plan_decoder() ->
    gleam@dynamic@decode:optional_field(
        <<"Join Type"/utf8>>,
        none,
        join_type_decoder(),
        fun(Join_type) ->
            gleam@dynamic@decode:optional_field(
                <<"Output"/utf8>>,
                [],
                gleam@dynamic@decode:list(
                    {decoder, fun gleam@dynamic@decode:decode_string/1}
                ),
                fun(Output) ->
                    gleam@dynamic@decode:optional_field(
                        <<"Plans"/utf8>>,
                        [],
                        gleam@dynamic@decode:list(plan_decoder()),
                        fun(Plans) ->
                            gleam@dynamic@decode:success(
                                {plan, Join_type, Output, Plans}
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 1373).
?DOC(false).
-spec json_plans_decoder() -> gleam@dynamic@decode:decoder(list(plan())).
json_plans_decoder() ->
    gleam@dynamic@decode:list(
        gleam@dynamic@decode:at([<<"Plan"/utf8>>], plan_decoder())
    ).

-file("src/squirrel/internal/database/postgres.gleam", 765).
?DOC(false).
-spec query_plan(squirrel@internal@query:untyped_query()) -> eval:eval(plan(), squirrel@internal@error:error(), context()).
query_plan(Query) ->
    eval:'try'(
        run_explain_query(Query),
        fun(Plan) -> case gleam@json:parse_bits(Plan, json_plans_decoder()) of
                {ok, [Plan@1 | _]} ->
                    eval:return(Plan@1);

                {ok, []} ->
                    erlang:error(#{gleam_error => panic,
                            message => <<"unreachable: no query plan"/utf8>>,
                            file => <<?FILEPATH/utf8>>,
                            module => <<"squirrel/internal/database/postgres"/utf8>>,
                            function => <<"query_plan"/utf8>>,
                            line => 772});

                {error, Reason} ->
                    eval:throw(
                        {cannot_parse_plan_for_query,
                            erlang:element(2, Query),
                            Reason}
                    )
            end end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 1401).
?DOC(false).
-spec bit_array_to_bool(bitstring()) -> boolean().
bit_array_to_bool(Bit_array) ->
    case Bit_array of
        <<0, Rest/bitstring>> ->
            bit_array_to_bool(Rest);

        <<>> ->
            false;

        _ ->
            true
    end.

-file("src/squirrel/internal/database/postgres.gleam", 949).
?DOC(false).
-spec column_nullability(integer(), integer()) -> eval:eval(nullability(), squirrel@internal@error:error(), context()).
column_nullability(Table, Column) ->
    with_cached_column(
        Table,
        Column,
        fun() ->
            gleam@bool:guard(
                Table =:= 0,
                eval:return(not_nullable),
                fun() ->
                    Params = [{parameter, <<Table:32>>},
                        {parameter, <<Column:32>>}],
                    Run_query = run_query(
                        find_column_nullability_query(),
                        Params,
                        [23, 23]
                    ),
                    eval:'try'(
                        Run_query,
                        fun(Res) ->
                            Has_non_null_constraint@1 = case Res of
                                [[Has_non_null_constraint]] -> Has_non_null_constraint;
                                _assert_fail ->
                                    erlang:error(#{gleam_error => let_assert,
                                                message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                                file => <<?FILEPATH/utf8>>,
                                                module => <<"squirrel/internal/database/postgres"/utf8>>,
                                                function => <<"column_nullability"/utf8>>,
                                                line => 967,
                                                value => _assert_fail,
                                                start => 32594,
                                                'end' => 32638,
                                                pattern_start => 32605,
                                                pattern_end => 32632})
                            end,
                            case bit_array_to_bool(Has_non_null_constraint@1) of
                                true ->
                                    eval:return(not_nullable);

                                false ->
                                    eval:return(nullable)
                            end
                        end
                    )
                end
            )
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 897).
?DOC(false).
-spec resolve_returns(
    squirrel@internal@query:untyped_query(),
    list(squirrel@internal@database@postgres_protocol:row_description_field()),
    gleam@set:set(integer())
) -> eval:eval(list(squirrel@internal@gleam:field()), squirrel@internal@error:error(), context()).
resolve_returns(Query, Returns, Nullables) ->
    squirrel@internal@eval_extra:try_index_map(
        Returns,
        fun(Column, I) ->
            {row_description_field, Name, Table, Column@1, Type_oid, _, _, _} = Column,
            eval:'try'(
                find_gleam_type(Query, Type_oid),
                fun(Type_) ->
                    Ends_with_exclamation_mark = gleam_stdlib:string_ends_with(
                        Name,
                        <<"!"/utf8>>
                    ),
                    Ends_with_question_mark = gleam_stdlib:string_ends_with(
                        Name,
                        <<"?"/utf8>>
                    ),
                    eval:'try'(case Ends_with_exclamation_mark of
                            true ->
                                eval:return(not_nullable);

                            false ->
                                case Ends_with_question_mark of
                                    true ->
                                        eval:return(nullable);

                                    false ->
                                        case gleam@set:contains(Nullables, I) of
                                            true ->
                                                eval:return(nullable);

                                            false ->
                                                column_nullability(
                                                    Table,
                                                    Column@1
                                                )
                                        end
                                end
                        end, fun(Nullability) ->
                            Type_@1 = case Nullability of
                                nullable ->
                                    {option, Type_};

                                not_nullable ->
                                    Type_
                            end,
                            Try_convert_name = begin
                                _pipe = case Ends_with_exclamation_mark orelse Ends_with_question_mark of
                                    true ->
                                        gleam@string:drop_end(Name, 1);

                                    false ->
                                        Name
                                end,
                                _pipe@1 = squirrel@internal@gleam:value_identifier(
                                    _pipe
                                ),
                                gleam@result:map_error(
                                    _pipe@1,
                                    fun(_capture) ->
                                        invalid_column_error(
                                            Query,
                                            Name,
                                            _capture
                                        )
                                    end
                                )
                            end,
                            eval:'try'(
                                eval:from_result(Try_convert_name),
                                fun(Name@1) ->
                                    Field = {field, Name@1, Type_@1},
                                    eval:return(Field)
                                end
                            )
                        end)
                end
            )
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 544).
?DOC(false).
-spec infer_types(squirrel@internal@query:untyped_query()) -> eval:eval(squirrel@internal@query:typed_query(), squirrel@internal@error:error(), context()).
infer_types(Query) ->
    eval:'try'(
        parameters_and_returns(Query),
        fun(_use0) ->
            {Parameters, Returns} = _use0,
            eval:'try'(
                resolve_parameters(Query, Parameters),
                fun(Parameters@1) ->
                    eval:'try'(
                        eval:attempt(
                            eval:map(
                                query_plan(Query),
                                fun nullables_from_plan/1
                            ),
                            fun(_, _) -> eval:return(gleam@set:new()) end
                        ),
                        fun(Nullables) ->
                            eval:'try'(
                                resolve_returns(Query, Returns, Nullables),
                                fun(Returns@1) -> _pipe = Query,
                                    _pipe@1 = squirrel@internal@query:add_types(
                                        _pipe,
                                        Parameters@1,
                                        Returns@1
                                    ),
                                    eval:from_result(_pipe@1) end
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 347).
?DOC(false).
-spec main(list(squirrel@internal@query:untyped_query()), context()) -> {ok,
        {list(squirrel@internal@query:typed_query()),
            list(squirrel@internal@error:error())}} |
    {error, squirrel@internal@error:error()}.
main(Queries, Context) ->
    _pipe = gleam@list:map(Queries, fun infer_types/1),
    _pipe@1 = squirrel@internal@eval_extra:run_all(_pipe, Context),
    _pipe@2 = gleam@result:partition(_pipe@1),
    {ok, _pipe@2}.

-file("src/squirrel/internal/database/postgres.gleam", 407).
?DOC(false).
-spec ensure_postgres_version() -> eval:eval(nil, squirrel@internal@error:error(), context()).
ensure_postgres_version() ->
    eval:'try'(
        run_query(find_postgres_version_query(), [], []),
        fun(Version) ->
            Version@2 = case Version of
                [[Version@1 | _] | _] -> Version@1;
                _assert_fail ->
                    erlang:error(#{gleam_error => let_assert,
                                message => <<"select version should always return at least one row"/utf8>>,
                                file => <<?FILEPATH/utf8>>,
                                module => <<"squirrel/internal/database/postgres"/utf8>>,
                                function => <<"ensure_postgres_version"/utf8>>,
                                line => 409,
                                value => _assert_fail,
                                start => 12473,
                                'end' => 12513,
                                pattern_start => 12484,
                                pattern_end => 12503})
            end,
            case gleam@result:'try'(
                gleam@bit_array:to_string(Version@2),
                fun gleam_stdlib:parse_int/1
            ) of
                {error, _} ->
                    eval:throw({postgres_version_has_invalid_format, Version@2});

                {ok, Version@3} when Version@3 >= 160000 ->
                    eval:return(nil);

                {ok, _} ->
                    eval:throw(postgres_version_is_too_old)
            end
        end
    ).

-file("src/squirrel/internal/database/postgres.gleam", 296).
?DOC(false).
-spec connect_and_authenticate(connection_options()) -> {ok, context()} |
    {error, squirrel@internal@error:error()}.
connect_and_authenticate(Connection) ->
    {connection_options, Host, Port, User, Password, Database, Timeout_seconds} = Connection,
    gleam@result:'try'(
        begin
            _pipe = squirrel@internal@database@postgres_protocol:connect(
                Host,
                Port,
                Timeout_seconds * 1000
            ),
            gleam@result:map_error(
                _pipe,
                fun(_capture) ->
                    {pg_cannot_establish_tcp_connection, Host, Port, _capture}
                end
            )
        end,
        fun(Db) ->
            Context = {context, Db, maps:new(), maps:new()},
            Setup_script = begin
                eval:'try'(
                    authenticate(User, Database, Password),
                    fun(_) ->
                        eval:'try'(
                            ensure_postgres_version(),
                            fun(_) -> eval:return(nil) end
                        )
                    end
                )
            end,
            {Context@1, Connection@1} = eval:step(Setup_script, Context),
            gleam@result:'try'(Connection@1, fun(_) -> {ok, Context@1} end)
        end
    ).
