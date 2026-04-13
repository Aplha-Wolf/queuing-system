-module(route@quetype@router).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/quetype/router.gleam").
-export([handle_priority_request/4]).

-file("src/route/quetype/router.gleam", 33).
-spec handle_update_delete_quetype(
    gleam@http:method(),
    route@web:context(),
    binary(),
    list({binary(), binary()})
) -> gleam@http@response:response(wisp:body()).
handle_update_delete_quetype(Method, _, _, _) ->
    case Method of
        _ ->
            wisp:not_found()
    end.

-file("src/route/quetype/router.gleam", 44).
-spec list_all_active_quetype(pog:connection(), list({binary(), binary()})) -> gleam@http@response:response(wisp:body()).
list_all_active_quetype(Db, Query) ->
    case common@common:get_limit_result_from_query(Query) of
        {ok, X} ->
            case common@common:get_offset_result_from_query(Query) of
                {ok, Y} ->
                    case route@quetype@service:get_all_quetype_with_limit_offset(
                        Db,
                        X,
                        Y
                    ) of
                        {ok, Z} ->
                            _pipe = wisp:ok(),
                            wisp:json_body(
                                _pipe,
                                gleam@json:to_string(
                                    route@quetype@service:quetype_list_response_to_json(
                                        Z
                                    )
                                )
                            );

                        {error, Err} ->
                            _pipe@1 = wisp:ok(),
                            wisp:json_body(
                                _pipe@1,
                                gleam@json:to_string(
                                    route@quetype@service:quetype_error_to_json(
                                        Err
                                    )
                                )
                            )
                    end;

                {error, _} ->
                    wisp:not_found()
            end;

        {error, _} ->
            wisp:not_found()
    end.

-file("src/route/quetype/router.gleam", 22).
-spec handle_list_add_quetype(
    gleam@http:method(),
    route@web:context(),
    list({binary(), binary()})
) -> gleam@http@response:response(wisp:body()).
handle_list_add_quetype(Method, Ctx, Query) ->
    case Method of
        get ->
            list_all_active_quetype(erlang:element(2, Ctx), Query);

        _ ->
            wisp:not_found()
    end.

-file("src/route/quetype/router.gleam", 9).
-spec handle_priority_request(
    gleam@http:method(),
    list(binary()),
    list({binary(), binary()}),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_priority_request(Method, Path_segments, Query, Ctx) ->
    case Path_segments of
        [] ->
            handle_list_add_quetype(Method, Ctx, Query);

        [Id] ->
            handle_update_delete_quetype(Method, Ctx, Id, Query);

        _ ->
            wisp:not_found()
    end.
