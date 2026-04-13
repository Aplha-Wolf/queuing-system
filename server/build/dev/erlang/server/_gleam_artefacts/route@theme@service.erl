-module(route@theme@service).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/theme/service.gleam").
-export([list_all_themes/1, get_theme_by_id/2, get_active_theme/1, activate_theme/2, theme_error_to_json/1, theme_list_to_json/1, theme_with_colors_to_json/1, activate_result_to_json/1]).
-export_type([theme_error/0, theme_with_colors_result/0, theme_list_result/0, activate_result/0]).

-type theme_error() :: {database_error, gleam@json:json()} |
    not_found |
    update_failed.

-type theme_with_colors_result() :: {theme_with_colors_result,
        integer(),
        binary(),
        binary(),
        binary(),
        boolean(),
        boolean(),
        list(shared@theme:theme_color())}.

-type theme_list_result() :: {theme_list_result,
        integer(),
        list(shared@theme:theme())}.

-type activate_result() :: {activate_result, binary()}.

-file("src/route/theme/service.gleam", 48).
-spec row_to_theme(route@theme@sql:list_themes_row()) -> shared@theme:theme().
row_to_theme(Row) ->
    {theme,
        erlang:element(2, Row),
        erlang:element(3, Row),
        erlang:element(4, Row),
        erlang:element(5, Row),
        erlang:element(6, Row),
        erlang:element(7, Row)}.

-file("src/route/theme/service.gleam", 34).
-spec list_all_themes(pog:connection()) -> {ok, theme_list_result()} |
    {error, theme_error()}.
list_all_themes(Db) ->
    case route@theme@sql:list_themes(Db) of
        {ok, X} ->
            {ok,
                {theme_list_result,
                    erlang:length(erlang:element(3, X)),
                    gleam@list:map(erlang:element(3, X), fun row_to_theme/1)}};

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}}
    end.

-file("src/route/theme/service.gleam", 114).
-spec color_row_to_color(route@theme@sql:get_theme_colors_row()) -> shared@theme:theme_color().
color_row_to_color(Row) ->
    {theme_color,
        erlang:element(2, Row),
        erlang:element(3, Row),
        erlang:element(4, Row)}.

-file("src/route/theme/service.gleam", 59).
-spec get_theme_by_id(pog:connection(), integer()) -> {ok,
        theme_with_colors_result()} |
    {error, theme_error()}.
get_theme_by_id(Db, Id) ->
    case route@theme@sql:get_theme_by_id(Db, Id) of
        {ok, X} when erlang:element(2, X) =:= 1 ->
            case route@theme@sql:get_theme_colors(Db, Id) of
                {ok, Colors_result} ->
                    Row@1 = case gleam@list:first(erlang:element(3, X)) of
                        {ok, Row} -> Row;
                        _assert_fail ->
                            erlang:error(#{gleam_error => let_assert,
                                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                        file => <<?FILEPATH/utf8>>,
                                        module => <<"route/theme/service"/utf8>>,
                                        function => <<"get_theme_by_id"/utf8>>,
                                        line => 67,
                                        value => _assert_fail,
                                        start => 1497,
                                        'end' => 1536,
                                        pattern_start => 1508,
                                        pattern_end => 1515})
                    end,
                    {ok,
                        {theme_with_colors_result,
                            erlang:element(2, Row@1),
                            erlang:element(3, Row@1),
                            erlang:element(4, Row@1),
                            erlang:element(5, Row@1),
                            erlang:element(6, Row@1),
                            erlang:element(7, Row@1),
                            gleam@list:map(
                                erlang:element(3, Colors_result),
                                fun color_row_to_color/1
                            )}};

                {error, Err} ->
                    {error,
                        {database_error, helpers@sql:pgo_queryerror_tojson(Err)}}
            end;

        {ok, _} ->
            {error, not_found};

        {error, Err@1} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err@1)}}
    end.

-file("src/route/theme/service.gleam", 87).
-spec get_active_theme(pog:connection()) -> {ok, theme_with_colors_result()} |
    {error, theme_error()}.
get_active_theme(Db) ->
    case route@theme@sql:get_active_theme(Db) of
        {ok, X} when erlang:element(2, X) =:= 1 ->
            Row@1 = case gleam@list:first(erlang:element(3, X)) of
                {ok, Row} -> Row;
                _assert_fail ->
                    erlang:error(#{gleam_error => let_assert,
                                message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                file => <<?FILEPATH/utf8>>,
                                module => <<"route/theme/service"/utf8>>,
                                function => <<"get_active_theme"/utf8>>,
                                line => 92,
                                value => _assert_fail,
                                start => 2269,
                                'end' => 2308,
                                pattern_start => 2280,
                                pattern_end => 2287})
            end,
            case route@theme@sql:get_theme_colors(Db, erlang:element(2, Row@1)) of
                {ok, Colors_result} ->
                    {ok,
                        {theme_with_colors_result,
                            erlang:element(2, Row@1),
                            erlang:element(3, Row@1),
                            erlang:element(4, Row@1),
                            erlang:element(5, Row@1),
                            erlang:element(6, Row@1),
                            erlang:element(7, Row@1),
                            gleam@list:map(
                                erlang:element(3, Colors_result),
                                fun color_row_to_color/1
                            )}};

                {error, Err} ->
                    {error,
                        {database_error, helpers@sql:pgo_queryerror_tojson(Err)}}
            end;

        {ok, _} ->
            {error, not_found};

        {error, Err@1} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err@1)}}
    end.

-file("src/route/theme/service.gleam", 124).
-spec activate_theme(pog:connection(), integer()) -> {ok, activate_result()} |
    {error, theme_error()}.
activate_theme(Db, Id) ->
    case route@theme@sql:get_theme_by_id(Db, Id) of
        {ok, X} when erlang:element(2, X) =:= 1 ->
            case route@theme@sql:deactivate_all_themes(Db) of
                {ok, _} ->
                    case route@theme@sql:activate_theme(Db, Id) of
                        {ok, _} ->
                            {ok,
                                {activate_result,
                                    <<"Theme activated successfully"/utf8>>}};

                        {error, Err} ->
                            {error,
                                {database_error,
                                    helpers@sql:pgo_queryerror_tojson(Err)}}
                    end;

                {error, Err@1} ->
                    {error,
                        {database_error,
                            helpers@sql:pgo_queryerror_tojson(Err@1)}}
            end;

        {ok, _} ->
            {error, not_found};

        {error, Err@2} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err@2)}}
    end.

-file("src/route/theme/service.gleam", 147).
-spec theme_error_to_json(theme_error()) -> gleam@json:json().
theme_error_to_json(Error) ->
    case Error of
        {database_error, E} ->
            E;

        not_found ->
            gleam@json:object(
                [{<<"message"/utf8>>,
                        gleam@json:string(<<"Theme not found"/utf8>>)}]
            );

        update_failed ->
            gleam@json:object(
                [{<<"message"/utf8>>,
                        gleam@json:string(<<"Failed to update theme"/utf8>>)}]
            )
    end.

-file("src/route/theme/service.gleam", 156).
-spec theme_list_to_json(theme_list_result()) -> gleam@json:json().
theme_list_to_json(Result) ->
    gleam@json:object(
        [{<<"count"/utf8>>, gleam@json:int(erlang:element(2, Result))},
            {<<"themes"/utf8>>,
                gleam@json:preprocessed_array(
                    gleam@list:map(
                        erlang:element(3, Result),
                        fun shared@theme:to_json/1
                    )
                )}]
    ).

-file("src/route/theme/service.gleam", 166).
-spec theme_with_colors_to_json(theme_with_colors_result()) -> gleam@json:json().
theme_with_colors_to_json(Result) ->
    gleam@json:object(
        [{<<"id"/utf8>>, gleam@json:int(erlang:element(2, Result))},
            {<<"name"/utf8>>, gleam@json:string(erlang:element(3, Result))},
            {<<"display_name"/utf8>>,
                gleam@json:string(erlang:element(4, Result))},
            {<<"description"/utf8>>,
                gleam@json:string(erlang:element(5, Result))},
            {<<"is_active"/utf8>>, gleam@json:bool(erlang:element(6, Result))},
            {<<"is_dark"/utf8>>, gleam@json:bool(erlang:element(7, Result))},
            {<<"colors"/utf8>>,
                gleam@json:preprocessed_array(
                    gleam@list:map(
                        erlang:element(8, Result),
                        fun shared@theme:color_to_json/1
                    )
                )}]
    ).

-file("src/route/theme/service.gleam", 184).
-spec activate_result_to_json(activate_result()) -> gleam@json:json().
activate_result_to_json(Result) ->
    gleam@json:object(
        [{<<"message"/utf8>>, gleam@json:string(erlang:element(2, Result))}]
    ).
