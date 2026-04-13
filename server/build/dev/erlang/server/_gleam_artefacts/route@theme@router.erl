-module(route@theme@router).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/theme/router.gleam").
-export([handle_theme_request/3]).

-file("src/route/theme/router.gleam", 59).
-spec list_themes(pog:connection()) -> gleam@http@response:response(wisp:body()).
list_themes(Db) ->
    case route@theme@service:list_all_themes(Db) of
        {ok, Result} ->
            _pipe = wisp:ok(),
            wisp:json_body(
                _pipe,
                gleam@json:to_string(
                    route@theme@service:theme_list_to_json(Result)
                )
            );

        {error, Err} ->
            _pipe@1 = wisp:internal_server_error(),
            wisp:json_body(
                _pipe@1,
                gleam@json:to_string(
                    route@theme@service:theme_error_to_json(Err)
                )
            )
    end.

-file("src/route/theme/router.gleam", 23).
-spec handle_list_themes(gleam@http:method(), route@web:context()) -> gleam@http@response:response(wisp:body()).
handle_list_themes(Method, Ctx) ->
    case Method of
        get ->
            list_themes(erlang:element(2, Ctx));

        _ ->
            wisp:method_not_allowed([get])
    end.

-file("src/route/theme/router.gleam", 74).
-spec get_active_theme(pog:connection()) -> gleam@http@response:response(wisp:body()).
get_active_theme(Db) ->
    case route@theme@service:get_active_theme(Db) of
        {ok, Result} ->
            _pipe = wisp:ok(),
            wisp:json_body(
                _pipe,
                gleam@json:to_string(
                    route@theme@service:theme_with_colors_to_json(Result)
                )
            );

        {error, Err} ->
            case Err of
                not_found ->
                    _pipe@1 = wisp:not_found(),
                    wisp:json_body(
                        _pipe@1,
                        gleam@json:to_string(
                            route@theme@service:theme_error_to_json(Err)
                        )
                    );

                _ ->
                    _pipe@2 = wisp:internal_server_error(),
                    wisp:json_body(
                        _pipe@2,
                        gleam@json:to_string(
                            route@theme@service:theme_error_to_json(Err)
                        )
                    )
            end
    end.

-file("src/route/theme/router.gleam", 30).
-spec handle_active_theme(gleam@http:method(), route@web:context()) -> gleam@http@response:response(wisp:body()).
handle_active_theme(Method, Ctx) ->
    case Method of
        get ->
            get_active_theme(erlang:element(2, Ctx));

        _ ->
            wisp:method_not_allowed([get])
    end.

-file("src/route/theme/router.gleam", 101).
-spec get_theme_by_id(pog:connection(), binary()) -> gleam@http@response:response(wisp:body()).
get_theme_by_id(Db, Id) ->
    case gleam_stdlib:parse_int(Id) of
        {ok, Parsed_id} ->
            case route@theme@service:get_theme_by_id(Db, Parsed_id) of
                {ok, Result} ->
                    _pipe = wisp:ok(),
                    wisp:json_body(
                        _pipe,
                        gleam@json:to_string(
                            route@theme@service:theme_with_colors_to_json(
                                Result
                            )
                        )
                    );

                {error, Err} ->
                    case Err of
                        not_found ->
                            _pipe@1 = wisp:not_found(),
                            wisp:json_body(
                                _pipe@1,
                                gleam@json:to_string(
                                    route@theme@service:theme_error_to_json(Err)
                                )
                            );

                        _ ->
                            _pipe@2 = wisp:internal_server_error(),
                            wisp:json_body(
                                _pipe@2,
                                gleam@json:to_string(
                                    route@theme@service:theme_error_to_json(Err)
                                )
                            )
                    end
            end;

        {error, _} ->
            wisp:unprocessable_content()
    end.

-file("src/route/theme/router.gleam", 37).
-spec handle_theme_by_id(gleam@http:method(), binary(), route@web:context()) -> gleam@http@response:response(wisp:body()).
handle_theme_by_id(Method, Id, Ctx) ->
    case Method of
        get ->
            get_theme_by_id(erlang:element(2, Ctx), Id);

        _ ->
            wisp:method_not_allowed([get])
    end.

-file("src/route/theme/router.gleam", 133).
-spec activate_theme(pog:connection(), binary()) -> gleam@http@response:response(wisp:body()).
activate_theme(Db, Id) ->
    case gleam_stdlib:parse_int(Id) of
        {ok, Parsed_id} ->
            case route@theme@service:activate_theme(Db, Parsed_id) of
                {ok, Result} ->
                    _pipe = wisp:ok(),
                    wisp:json_body(
                        _pipe,
                        gleam@json:to_string(
                            route@theme@service:activate_result_to_json(Result)
                        )
                    );

                {error, Err} ->
                    case Err of
                        not_found ->
                            _pipe@1 = wisp:not_found(),
                            wisp:json_body(
                                _pipe@1,
                                gleam@json:to_string(
                                    route@theme@service:theme_error_to_json(Err)
                                )
                            );

                        _ ->
                            _pipe@2 = wisp:internal_server_error(),
                            wisp:json_body(
                                _pipe@2,
                                gleam@json:to_string(
                                    route@theme@service:theme_error_to_json(Err)
                                )
                            )
                    end
            end;

        {error, _} ->
            wisp:unprocessable_content()
    end.

-file("src/route/theme/router.gleam", 48).
-spec handle_activate_theme(gleam@http:method(), binary(), route@web:context()) -> gleam@http@response:response(wisp:body()).
handle_activate_theme(Method, Id, Ctx) ->
    case Method of
        put ->
            activate_theme(erlang:element(2, Ctx), Id);

        _ ->
            wisp:method_not_allowed([put])
    end.

-file("src/route/theme/router.gleam", 9).
-spec handle_theme_request(
    gleam@http:method(),
    list(binary()),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_theme_request(Method, Path_segments, Ctx) ->
    case Path_segments of
        [] ->
            handle_list_themes(Method, Ctx);

        [<<"active"/utf8>>] ->
            handle_active_theme(Method, Ctx);

        [Id] ->
            handle_theme_by_id(Method, Id, Ctx);

        [Id@1, <<"activate"/utf8>>] ->
            handle_activate_theme(Method, Id@1, Ctx);

        _ ->
            wisp:not_found()
    end.
