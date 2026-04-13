-module(route@quetype@service).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/quetype/service.gleam").
-export([get_all_quetype_with_limit_offset/3, quetype_list_response_to_json/1, quetype_error_to_json/1]).
-export_type([quetype_list_response/0, quetype_error/0]).

-type quetype_list_response() :: {quetype_list_response,
        integer(),
        binary(),
        shared@quetype:page(),
        list(shared@quetype:que_type())}.

-type quetype_error() :: {database_error, gleam@json:json()}.

-file("src/route/quetype/service.gleam", 40).
-spec quetypelistwithlimitoffsetrow_to_quetype(
    route@quetype@sql:get_quetype_with_limit_offset_row()
) -> shared@quetype:que_type().
quetypelistwithlimitoffsetrow_to_quetype(Row) ->
    {que_type,
        erlang:element(2, Row),
        erlang:element(3, Row),
        erlang:element(4, Row),
        erlang:element(5, Row),
        erlang:element(6, Row),
        erlang:element(7, Row)}.

-file("src/route/quetype/service.gleam", 53).
-spec quetypelistwithlimitoffsetrows_to_quetype(
    list(route@quetype@sql:get_quetype_with_limit_offset_row()),
    list(shared@quetype:que_type())
) -> list(shared@quetype:que_type()).
quetypelistwithlimitoffsetrows_to_quetype(In, Out) ->
    case In of
        [] ->
            Out;

        [X | Y] ->
            quetypelistwithlimitoffsetrows_to_quetype(
                Y,
                lists:append(Out, [quetypelistwithlimitoffsetrow_to_quetype(X)])
            )
    end.

-file("src/route/quetype/service.gleam", 67).
-spec get_no_of_active_quetype(pog:connection()) -> integer().
get_no_of_active_quetype(Db) ->
    case route@quetype@sql:get_no_of_active_quetype(Db) of
        {ok, X} when erlang:element(2, X) =:= 1 ->
            Row@1 = case gleam@list:first(erlang:element(3, X)) of
                {ok, Row} -> Row;
                _assert_fail ->
                    erlang:error(#{gleam_error => let_assert,
                                message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                file => <<?FILEPATH/utf8>>,
                                module => <<"route/quetype/service"/utf8>>,
                                function => <<"get_no_of_active_quetype"/utf8>>,
                                line => 70,
                                value => _assert_fail,
                                start => 1763,
                                'end' => 1802,
                                pattern_start => 1774,
                                pattern_end => 1781})
            end,
            erlang:element(2, Row@1);

        _ ->
            0
    end.

-file("src/route/quetype/service.gleam", 21).
-spec get_all_quetype_with_limit_offset(pog:connection(), integer(), integer()) -> {ok,
        quetype_list_response()} |
    {error, quetype_error()}.
get_all_quetype_with_limit_offset(Db, Limit, Offset) ->
    case route@quetype@sql:get_quetype_with_limit_offset(Db, Limit, Offset) of
        {ok, X} ->
            Total = get_no_of_active_quetype(Db),
            {ok,
                {quetype_list_response,
                    200,
                    <<""/utf8>>,
                    {page, erlang:element(2, X), Total},
                    quetypelistwithlimitoffsetrows_to_quetype(
                        erlang:element(3, X),
                        []
                    )}};

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}}
    end.

-file("src/route/quetype/service.gleam", 77).
-spec quetype_list_response_to_json(quetype_list_response()) -> gleam@json:json().
quetype_list_response_to_json(Resp) ->
    gleam@json:object(
        [{<<"status"/utf8>>, gleam@json:int(erlang:element(2, Resp))},
            {<<"message"/utf8>>, gleam@json:string(erlang:element(3, Resp))},
            {<<"page"/utf8>>,
                shared@quetype:page_to_json(erlang:element(4, Resp))},
            {<<"data"/utf8>>,
                gleam@json:preprocessed_array(
                    gleam@list:map(
                        erlang:element(5, Resp),
                        fun(Q) -> shared@quetype:to_json(Q) end
                    )
                )}]
    ).

-file("src/route/quetype/service.gleam", 91).
-spec quetype_error_to_json(quetype_error()) -> gleam@json:json().
quetype_error_to_json(Error) ->
    case Error of
        {database_error, E} ->
            E
    end.
