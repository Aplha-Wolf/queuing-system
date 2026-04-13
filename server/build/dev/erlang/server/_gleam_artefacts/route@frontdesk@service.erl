-module(route@frontdesk@service).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/frontdesk/service.gleam").
-export([get_frontdesk_by_code/2, frontdesk_error_to_json/1]).
-export_type([front_desk_error/0]).

-type front_desk_error() :: {database_error, gleam@json:json()} | not_found.

-file("src/route/frontdesk/service.gleam", 24).
-spec getfrontdeskbycoderow_to_frontdesk(
    list(route@frontdesk@sql:get_frontdesk_by_code_row())
) -> shared@frontdesk:front_desk().
getfrontdeskbycoderow_to_frontdesk(Frontdesk) ->
    Row@1 = case gleam@list:first(Frontdesk) of
        {ok, Row} -> Row;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"route/frontdesk/service"/utf8>>,
                        function => <<"getfrontdeskbycoderow_to_frontdesk"/utf8>>,
                        line => 27,
                        value => _assert_fail,
                        start => 734,
                        'end' => 776,
                        pattern_start => 745,
                        pattern_end => 752})
    end,
    {front_desk,
        erlang:element(2, Row@1),
        erlang:element(3, Row@1),
        erlang:element(4, Row@1),
        erlang:element(5, Row@1),
        erlang:element(6, Row@1),
        erlang:element(7, Row@1),
        erlang:element(8, Row@1),
        erlang:element(9, Row@1),
        erlang:element(10, Row@1),
        erlang:element(11, Row@1),
        erlang:element(12, Row@1),
        erlang:element(13, Row@1),
        erlang:element(14, Row@1)}.

-file("src/route/frontdesk/service.gleam", 13).
-spec get_frontdesk_by_code(binary(), pog:connection()) -> {ok,
        shared@frontdesk:front_desk()} |
    {error, front_desk_error()}.
get_frontdesk_by_code(Code, Db) ->
    case route@frontdesk@sql:get_frontdesk_by_code(Db, Code) of
        {ok, X} when erlang:element(2, X) =:= 1 ->
            {ok, getfrontdeskbycoderow_to_frontdesk(erlang:element(3, X))};

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}};

        _ ->
            {error, not_found}
    end.

-file("src/route/frontdesk/service.gleam", 46).
-spec frontdesk_error_to_json(front_desk_error()) -> gleam@json:json().
frontdesk_error_to_json(Error) ->
    case Error of
        {database_error, E} ->
            E;

        not_found ->
            gleam@json:object(
                [{<<"message"/utf8>>,
                        gleam@json:string(<<"Frontdesk not found"/utf8>>)}]
            )
    end.
