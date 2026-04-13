-module(route@frontdesk@router).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/frontdesk/router.gleam").
-export([handle_frontdesk_request/4]).

-file("src/route/frontdesk/router.gleam", 22).
-spec hanfle_list_add_frontdesk(gleam@http:method(), route@web:context()) -> gleam@http@response:response(wisp:body()).
hanfle_list_add_frontdesk(Method, _) ->
    case Method of
        _ ->
            wisp:not_found()
    end.

-file("src/route/frontdesk/router.gleam", 39).
-spec get_frontdesk(pog:connection(), binary()) -> gleam@http@response:response(wisp:body()).
get_frontdesk(Db, Code) ->
    case route@frontdesk@service:get_frontdesk_by_code(Code, Db) of
        {ok, X} ->
            _pipe = wisp:ok(),
            wisp:json_body(
                _pipe,
                gleam@json:to_string(shared@frontdesk:to_json(X))
            );

        {error, Y} ->
            _pipe@1 = wisp:ok(),
            wisp:json_body(
                _pipe@1,
                gleam@json:to_string(
                    route@frontdesk@service:frontdesk_error_to_json(Y)
                )
            )
    end.

-file("src/route/frontdesk/router.gleam", 28).
-spec handle_update_delete_frontdesk(
    gleam@http:method(),
    route@web:context(),
    binary()
) -> gleam@http@response:response(wisp:body()).
handle_update_delete_frontdesk(Method, Ctx, Code) ->
    case Method of
        get ->
            get_frontdesk(erlang:element(2, Ctx), Code);

        _ ->
            wisp:not_found()
    end.

-file("src/route/frontdesk/router.gleam", 9).
-spec handle_frontdesk_request(
    gleam@http:method(),
    list(binary()),
    list({binary(), binary()}),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_frontdesk_request(Method, Path_segments, _, Ctx) ->
    case Path_segments of
        [] ->
            hanfle_list_add_frontdesk(Method, Ctx);

        [Code] ->
            handle_update_delete_frontdesk(Method, Ctx, Code);

        _ ->
            wisp:not_found()
    end.
