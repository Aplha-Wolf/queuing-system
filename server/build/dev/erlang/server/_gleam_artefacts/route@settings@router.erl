-module(route@settings@router).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/settings/router.gleam").
-export([handle_settings_request/3]).

-file("src/route/settings/router.gleam", 27).
-spec get_settings(pog:connection()) -> gleam@http@response:response(wisp:body()).
get_settings(Db) ->
    case route@settings@service:get_settings(Db) of
        {ok, Settings} ->
            _pipe = wisp:ok(),
            wisp:json_body(
                _pipe,
                gleam@json:to_string(
                    route@settings@service:settings_to_json(Settings)
                )
            );

        {error, Err} ->
            case Err of
                not_found ->
                    wisp:not_found();

                {database_error, E} ->
                    _pipe@1 = wisp:internal_server_error(),
                    wisp:json_body(_pipe@1, gleam@json:to_string(E))
            end
    end.

-file("src/route/settings/router.gleam", 46).
-spec update_settings(pog:connection()) -> gleam@http@response:response(wisp:body()).
update_settings(_) ->
    wisp:ok().

-file("src/route/settings/router.gleam", 19).
-spec handle_colors_request(gleam@http:method(), route@web:context()) -> gleam@http@response:response(wisp:body()).
handle_colors_request(Method, Ctx) ->
    case Method of
        get ->
            get_settings(erlang:element(2, Ctx));

        put ->
            update_settings(erlang:element(2, Ctx));

        _ ->
            wisp:method_not_allowed([get, put])
    end.

-file("src/route/settings/router.gleam", 8).
-spec handle_settings_request(
    gleam@http:method(),
    list(binary()),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_settings_request(Method, Path_segments, Ctx) ->
    case Path_segments of
        [<<"colors"/utf8>>] ->
            handle_colors_request(Method, Ctx);

        _ ->
            wisp:not_found()
    end.
