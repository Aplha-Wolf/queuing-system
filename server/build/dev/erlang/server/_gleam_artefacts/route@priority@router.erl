-module(route@priority@router).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/priority/router.gleam").
-export([handle_priority_request/4]).

-file("src/route/priority/router.gleam", 33).
-spec handle_update_delete_priority(
    gleam@http:method(),
    route@web:context(),
    binary(),
    list({binary(), binary()})
) -> gleam@http@response:response(wisp:body()).
handle_update_delete_priority(Method, _, _, _) ->
    case Method of
        _ ->
            wisp:not_found()
    end.

-file("src/route/priority/router.gleam", 44).
-spec list_all_active_priority_with_limit_offset(
    pog:connection(),
    list({binary(), binary()})
) -> gleam@http@response:response(wisp:body()).
list_all_active_priority_with_limit_offset(Db, Query) ->
    Limit = common@common:get_limit_from_query(Query),
    Offset = common@common:get_offset_from_query(Query),
    case route@priority@service:get_active_priority_with_limit_offset(
        Db,
        Limit,
        Offset
    ) of
        {ok, X} ->
            _pipe = wisp:ok(),
            wisp:json_body(
                _pipe,
                gleam@json:to_string(
                    route@priority@service:priority_list_response_to_json(X)
                )
            );

        {error, Y} ->
            _pipe@1 = wisp:ok(),
            wisp:json_body(
                _pipe@1,
                gleam@json:to_string(
                    route@priority@service:priority_error_to_json(Y)
                )
            )
    end.

-file("src/route/priority/router.gleam", 22).
-spec handle_list_add_priority(
    gleam@http:method(),
    route@web:context(),
    list({binary(), binary()})
) -> gleam@http@response:response(wisp:body()).
handle_list_add_priority(Method, Ctx, Query) ->
    case Method of
        get ->
            list_all_active_priority_with_limit_offset(
                erlang:element(2, Ctx),
                Query
            );

        _ ->
            wisp:not_found()
    end.

-file("src/route/priority/router.gleam", 9).
-spec handle_priority_request(
    gleam@http:method(),
    list(binary()),
    list({binary(), binary()}),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_priority_request(Method, Path_segments, Query, Ctx) ->
    case Path_segments of
        [] ->
            handle_list_add_priority(Method, Ctx, Query);

        [Id] ->
            handle_update_delete_priority(Method, Ctx, Id, Query);

        _ ->
            wisp:not_found()
    end.
