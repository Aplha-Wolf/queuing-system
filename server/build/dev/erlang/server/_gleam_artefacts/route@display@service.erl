-module(route@display@service).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/display/service.gleam").
-export([get_display_by_code/2, get_display_by_id/2, display_error_to_json/1]).
-export_type([display_error/0]).

-type display_error() :: {database_error, gleam@json:json()} | not_found.

-file("src/route/display/service.gleam", 24).
-spec getdisplaybycode_to_display(
    list(route@display@sql:get_display_by_code_row())
) -> shared@display:display().
getdisplaybycode_to_display(Display) ->
    Display@2 = case gleam@list:first(Display) of
        {ok, Display@1} -> Display@1;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"route/display/service"/utf8>>,
                        function => <<"getdisplaybycode_to_display"/utf8>>,
                        line => 27,
                        value => _assert_fail,
                        start => 688,
                        'end' => 732,
                        pattern_start => 699,
                        pattern_end => 710})
    end,
    {display,
        erlang:element(2, Display@2),
        erlang:element(3, Display@2),
        erlang:element(5, Display@2),
        erlang:element(6, Display@2),
        erlang:element(4, Display@2),
        erlang:element(7, Display@2),
        erlang:element(8, Display@2),
        erlang:element(9, Display@2),
        erlang:element(10, Display@2),
        erlang:element(11, Display@2),
        erlang:element(12, Display@2),
        erlang:element(13, Display@2),
        erlang:element(14, Display@2),
        erlang:element(15, Display@2)}.

-file("src/route/display/service.gleam", 13).
-spec get_display_by_code(pog:connection(), binary()) -> {ok,
        shared@display:display()} |
    {error, display_error()}.
get_display_by_code(Db, Code) ->
    case route@display@sql:get_display_by_code(Db, Code) of
        {ok, X} when erlang:element(2, X) =:= 1 ->
            {ok, getdisplaybycode_to_display(erlang:element(3, X))};

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}};

        _ ->
            {error, not_found}
    end.

-file("src/route/display/service.gleam", 58).
-spec getdisplaybyid_to_display(list(route@display@sql:get_display_by_id_row())) -> shared@display:display().
getdisplaybyid_to_display(Display) ->
    Display@2 = case gleam@list:first(Display) of
        {ok, Display@1} -> Display@1;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"route/display/service"/utf8>>,
                        function => <<"getdisplaybyid_to_display"/utf8>>,
                        line => 61,
                        value => _assert_fail,
                        start => 1689,
                        'end' => 1733,
                        pattern_start => 1700,
                        pattern_end => 1711})
    end,
    {display,
        erlang:element(2, Display@2),
        erlang:element(3, Display@2),
        erlang:element(5, Display@2),
        erlang:element(6, Display@2),
        erlang:element(4, Display@2),
        erlang:element(7, Display@2),
        erlang:element(8, Display@2),
        erlang:element(9, Display@2),
        erlang:element(10, Display@2),
        erlang:element(11, Display@2),
        erlang:element(12, Display@2),
        erlang:element(13, Display@2),
        erlang:element(14, Display@2),
        erlang:element(15, Display@2)}.

-file("src/route/display/service.gleam", 47).
-spec get_display_by_id(pog:connection(), integer()) -> {ok,
        shared@display:display()} |
    {error, display_error()}.
get_display_by_id(Db, Id) ->
    case route@display@sql:get_display_by_id(Db, Id) of
        {ok, X} when erlang:element(2, X) =:= 1 ->
            {ok, getdisplaybyid_to_display(erlang:element(3, X))};

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}};

        _ ->
            {error, not_found}
    end.

-file("src/route/display/service.gleam", 81).
-spec display_error_to_json(display_error()) -> gleam@json:json().
display_error_to_json(Error) ->
    case Error of
        {database_error, E} ->
            E;

        not_found ->
            gleam@json:object(
                [{<<"message"/utf8>>,
                        gleam@json:string(<<"Display not found"/utf8>>)}]
            )
    end.
