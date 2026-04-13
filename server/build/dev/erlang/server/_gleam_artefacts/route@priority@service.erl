-module(route@priority@service).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/priority/service.gleam").
-export([get_active_priority_with_limit_offset/3, priority_list_response_to_json/1, priority_error_to_json/1]).
-export_type([priority_list_response/0, priority_error/0]).

-type priority_list_response() :: {priority_list_response,
        integer(),
        binary(),
        shared@priority:page(),
        list(shared@priority:priority())}.

-type priority_error() :: {database_error, gleam@json:json()}.

-file("src/route/priority/service.gleam", 54).
-spec allactivepriorityrows_to_priority(
    route@priority@sql:get_all_active_priority_row()
) -> shared@priority:priority().
allactivepriorityrows_to_priority(Priority) ->
    {priority,
        erlang:element(2, Priority),
        erlang:element(3, Priority),
        erlang:element(4, Priority),
        erlang:element(5, Priority),
        erlang:element(7, Priority),
        erlang:element(6, Priority),
        erlang:element(8, Priority)}.

-file("src/route/priority/service.gleam", 40).
-spec getallactivepriorityrows_to_priority(
    list(route@priority@sql:get_all_active_priority_row()),
    list(shared@priority:priority())
) -> list(shared@priority:priority()).
getallactivepriorityrows_to_priority(In, Out) ->
    case In of
        [] ->
            Out;

        [X | Y] ->
            getallactivepriorityrows_to_priority(
                Y,
                lists:append(Out, [allactivepriorityrows_to_priority(X)])
            )
    end.

-file("src/route/priority/service.gleam", 68).
-spec get_no_of_active_priority(pog:connection()) -> integer().
get_no_of_active_priority(Db) ->
    case route@priority@sql:get_no_of_active_priority(Db) of
        {ok, X} when erlang:element(2, X) =:= 1 ->
            Row@1 = case gleam@list:first(erlang:element(3, X)) of
                {ok, Row} -> Row;
                _assert_fail ->
                    erlang:error(#{gleam_error => let_assert,
                                message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                file => <<?FILEPATH/utf8>>,
                                module => <<"route/priority/service"/utf8>>,
                                function => <<"get_no_of_active_priority"/utf8>>,
                                line => 71,
                                value => _assert_fail,
                                start => 1813,
                                'end' => 1852,
                                pattern_start => 1824,
                                pattern_end => 1831})
            end,
            erlang:element(2, Row@1);

        _ ->
            0
    end.

-file("src/route/priority/service.gleam", 21).
-spec get_active_priority_with_limit_offset(
    pog:connection(),
    integer(),
    integer()
) -> {ok, priority_list_response()} | {error, priority_error()}.
get_active_priority_with_limit_offset(Db, Limit, Offset) ->
    case route@priority@sql:get_all_active_priority(Db, Limit, Offset) of
        {ok, X} ->
            Total = get_no_of_active_priority(Db),
            {ok,
                {priority_list_response,
                    200,
                    <<""/utf8>>,
                    {page, erlang:element(2, X), Total},
                    getallactivepriorityrows_to_priority(
                        erlang:element(3, X),
                        []
                    )}};

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}}
    end.

-file("src/route/priority/service.gleam", 78).
-spec priority_list_response_to_json(priority_list_response()) -> gleam@json:json().
priority_list_response_to_json(Resp) ->
    gleam@json:object(
        [{<<"status"/utf8>>, gleam@json:int(erlang:element(2, Resp))},
            {<<"message"/utf8>>, gleam@json:string(erlang:element(3, Resp))},
            {<<"page"/utf8>>,
                shared@priority:page_to_json(erlang:element(4, Resp))},
            {<<"data"/utf8>>,
                gleam@json:preprocessed_array(
                    gleam@list:map(
                        erlang:element(5, Resp),
                        fun(P) -> shared@priority:to_json(P) end
                    )
                )}]
    ).

-file("src/route/priority/service.gleam", 92).
-spec priority_error_to_json(priority_error()) -> gleam@json:json().
priority_error_to_json(Error) ->
    case Error of
        {database_error, E} ->
            E
    end.
