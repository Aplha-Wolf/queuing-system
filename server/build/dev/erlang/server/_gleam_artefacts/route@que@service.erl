-module(route@que@service).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/que/service.gleam").
-export([get_terminal_queues_by_code/2, get_terminal_queues_by_id/2, get_terminal_queue_by_code/2, show_terminal_info/2, get_terminal_queue_by_id/2, next_queue/2, terminal_info_to_json/1, que_list_to_json/1, que_error_to_json/1]).
-export_type([terminal_info/0, que_error/0]).

-type terminal_info() :: {terminal_info,
        shared@terminal:terminal(),
        shared@queue:queue(),
        list(shared@queue:queue())}.

-type que_error() :: {database_error, gleam@json:json()} |
    terminal_not_found |
    queue_not_found.

-file("src/route/que/service.gleam", 84).
-spec listallterminalqueuesbycode_to_queue(
    route@que@sql:get_queues_using_terminal_code_row()
) -> shared@queue:queue().
listallterminalqueuesbycode_to_queue(Queue) ->
    {queue, erlang:element(2, Queue), erlang:element(3, Queue)}.

-file("src/route/que/service.gleam", 90).
-spec terminalquecoderow_to_queues(
    list(route@que@sql:get_queues_using_terminal_code_row()),
    list(shared@queue:queue())
) -> list(shared@queue:queue()).
terminalquecoderow_to_queues(In, Out) ->
    case In of
        [] ->
            Out;

        [X | Y] ->
            terminalquecoderow_to_queues(
                Y,
                lists:append(Out, [listallterminalqueuesbycode_to_queue(X)])
            )
    end.

-file("src/route/que/service.gleam", 50).
-spec get_terminal_queues_by_code(binary(), pog:connection()) -> {ok,
        list(shared@queue:queue())} |
    {error, que_error()}.
get_terminal_queues_by_code(Code, Db) ->
    case route@que@sql:get_queues_using_terminal_code(Db, Code) of
        {ok, X} ->
            {ok, terminalquecoderow_to_queues(erlang:element(3, X), [])};

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}}
    end.

-file("src/route/que/service.gleam", 104).
-spec listallterminalqueuesbyid_to_queue(
    route@que@sql:get_queues_using_terminal_id_row()
) -> shared@queue:queue().
listallterminalqueuesbyid_to_queue(Queue) ->
    {queue, erlang:element(2, Queue), erlang:element(3, Queue)}.

-file("src/route/que/service.gleam", 70).
-spec terminalqueidrow_to_queues(
    list(route@que@sql:get_queues_using_terminal_id_row()),
    list(shared@queue:queue())
) -> list(shared@queue:queue()).
terminalqueidrow_to_queues(In, Out) ->
    case In of
        [] ->
            Out;

        [X | Y] ->
            terminalqueidrow_to_queues(
                Y,
                lists:append(Out, [listallterminalqueuesbyid_to_queue(X)])
            )
    end.

-file("src/route/que/service.gleam", 60).
-spec get_terminal_queues_by_id(integer(), pog:connection()) -> {ok,
        list(shared@queue:queue())} |
    {error, que_error()}.
get_terminal_queues_by_id(Id, Db) ->
    case route@que@sql:get_queues_using_terminal_id(Db, Id) of
        {ok, X} ->
            {ok, terminalqueidrow_to_queues(erlang:element(3, X), [])};

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}}
    end.

-file("src/route/que/service.gleam", 121).
-spec getterminalqueuecoderow_to_queue(
    list(route@que@sql:get_terminal_queue_by_code_row())
) -> shared@queue:queue().
getterminalqueuecoderow_to_queue(Current_queues) ->
    Row@1 = case gleam@list:first(Current_queues) of
        {ok, Row} -> Row;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"route/que/service"/utf8>>,
                        function => <<"getterminalqueuecoderow_to_queue"/utf8>>,
                        line => 124,
                        value => _assert_fail,
                        start => 3388,
                        'end' => 3435,
                        pattern_start => 3399,
                        pattern_end => 3406})
    end,
    {queue, erlang:element(2, Row@1), erlang:element(3, Row@1)}.

-file("src/route/que/service.gleam", 110).
-spec get_terminal_queue_by_code(binary(), pog:connection()) -> {ok,
        shared@queue:queue()} |
    {error, que_error()}.
get_terminal_queue_by_code(Code, Db) ->
    case route@que@sql:get_terminal_queue_by_code(Db, Code) of
        {ok, X} when erlang:element(2, X) =:= 1 ->
            {ok, getterminalqueuecoderow_to_queue(erlang:element(3, X))};

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}};

        _ ->
            {ok, {queue, 0, <<""/utf8>>}}
    end.

-file("src/route/que/service.gleam", 24).
-spec show_terminal_info(binary(), pog:connection()) -> {ok, terminal_info()} |
    {error, que_error()}.
show_terminal_info(Code, Db) ->
    case route@terminal@service:find_terminal_by_code(Db, Code) of
        {ok, Terminal} ->
            case {get_terminal_queue_by_code(Code, Db),
                get_terminal_queues_by_code(Code, Db)} of
                {{ok, Current}, {ok, Queues}} ->
                    {ok, {terminal_info, Terminal, Current, Queues}};

                {{error, E}, _} ->
                    {error, E};

                {_, {error, E@1}} ->
                    {error, E@1}
            end;

        {error, not_found} ->
            {error, terminal_not_found};

        {error, insert_failed} ->
            {error,
                {database_error,
                    gleam@json:object(
                        [{<<"error"/utf8>>,
                                gleam@json:string(<<"Insert failed!"/utf8>>)}]
                    )}};

        {error, {database_error, E@2}} ->
            {error, {database_error, E@2}}
    end.

-file("src/route/que/service.gleam", 139).
-spec getterminalqueueidrow_to_queue(
    list(route@que@sql:get_terminal_queue_by_id_row())
) -> shared@queue:queue().
getterminalqueueidrow_to_queue(Current_queues) ->
    Row@1 = case gleam@list:first(Current_queues) of
        {ok, Row} -> Row;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"route/que/service"/utf8>>,
                        function => <<"getterminalqueueidrow_to_queue"/utf8>>,
                        line => 142,
                        value => _assert_fail,
                        start => 3989,
                        'end' => 4036,
                        pattern_start => 4000,
                        pattern_end => 4007})
    end,
    {queue, erlang:element(2, Row@1), erlang:element(3, Row@1)}.

-file("src/route/que/service.gleam", 128).
-spec get_terminal_queue_by_id(integer(), pog:connection()) -> {ok,
        shared@queue:queue()} |
    {error, que_error()}.
get_terminal_queue_by_id(Id, Db) ->
    case route@que@sql:get_terminal_queue_by_id(Db, Id) of
        {ok, X} when erlang:element(2, X) =:= 1 ->
            {ok, getterminalqueueidrow_to_queue(erlang:element(3, X))};

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}};

        _ ->
            {ok, {queue, 0, <<""/utf8>>}}
    end.

-file("src/route/que/service.gleam", 162).
-spec nextquerow_to_queue(list(route@que@sql:next_queue_row())) -> shared@queue:queue().
nextquerow_to_queue(Rows) ->
    Row@1 = case gleam@list:first(Rows) of
        {ok, Row} -> Row;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"route/que/service"/utf8>>,
                        function => <<"nextquerow_to_queue"/utf8>>,
                        line => 163,
                        value => _assert_fail,
                        start => 4685,
                        'end' => 4722,
                        pattern_start => 4696,
                        pattern_end => 4703})
    end,
    {queue, erlang:element(2, Row@1), erlang:element(3, Row@1)}.

-file("src/route/que/service.gleam", 146).
-spec next_queue(integer(), pog:connection()) -> {ok, shared@queue:queue()} |
    {error, que_error()}.
next_queue(Id, Db) ->
    case route@que@sql:clear_terminal_queue(Db, Id) of
        {ok, _} ->
            case route@que@sql:next_queue(Db, Id) of
                {ok, X} when erlang:element(2, X) =:= 1 ->
                    {ok, nextquerow_to_queue(erlang:element(3, X))};

                {error, Err} ->
                    {error,
                        {database_error, helpers@sql:pgo_queryerror_tojson(Err)}};

                _ ->
                    {ok, {queue, 0, <<""/utf8>>}}
            end;

        {error, Err@1} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err@1)}}
    end.

-file("src/route/que/service.gleam", 167).
-spec terminal_info_to_json(terminal_info()) -> gleam@json:json().
terminal_info_to_json(Info) ->
    gleam@json:object(
        [{<<"terminal"/utf8>>, shared@terminal:to_json(erlang:element(2, Info))},
            {<<"current"/utf8>>, shared@queue:to_json(erlang:element(3, Info))},
            {<<"queues"/utf8>>,
                gleam@json:preprocessed_array(
                    gleam@list:map(
                        erlang:element(4, Info),
                        fun(Q) -> shared@queue:to_json(Q) end
                    )
                )}]
    ).

-file("src/route/que/service.gleam", 180).
-spec que_list_to_json(list(shared@queue:queue())) -> gleam@json:json().
que_list_to_json(Queues) ->
    gleam@json:preprocessed_array(
        gleam@list:map(Queues, fun(Q) -> shared@queue:to_json(Q) end)
    ).

-file("src/route/que/service.gleam", 184).
-spec que_error_to_json(que_error()) -> gleam@json:json().
que_error_to_json(Error) ->
    case Error of
        {database_error, E} ->
            E;

        terminal_not_found ->
            gleam@json:object(
                [{<<"message"/utf8>>,
                        gleam@json:string(<<"Terminal not found"/utf8>>)}]
            );

        queue_not_found ->
            gleam@json:object(
                [{<<"message"/utf8>>,
                        gleam@json:string(<<"Queue not found"/utf8>>)}]
            )
    end.
