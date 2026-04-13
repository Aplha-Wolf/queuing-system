-module(route@display_terminal@router).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/display_terminal/router.gleam").
-export([handle_display_terminal_request/4]).

-file("src/route/display_terminal/router.gleam", 79).
-spec get_limit_from_query(list({binary(), binary()})) -> {ok, integer()} |
    {error, nil}.
get_limit_from_query(Query) ->
    Res = begin
        _pipe = maps:from_list(Query),
        _pipe@1 = gleam_stdlib:map_get(_pipe, <<"limit"/utf8>>),
        (fun(X) -> case X of
                {ok, Limit} ->
                    gleam_stdlib:parse_int(Limit);

                {error, _} ->
                    {error, nil}
            end end)(_pipe@1)
    end,
    Res.

-file("src/route/display_terminal/router.gleam", 34).
-spec get_display_terminals(
    pog:connection(),
    binary(),
    list({binary(), binary()})
) -> gleam@http@response:response(wisp:body()).
get_display_terminals(Db, Id, Query) ->
    case gleam_stdlib:parse_int(Id) of
        {ok, Id@1} ->
            case get_limit_from_query(Query) of
                {ok, Limit} ->
                    case route@display_terminal@service:get_display_terminals(
                        Db,
                        Id@1,
                        Limit
                    ) of
                        {ok, X} ->
                            _pipe = wisp:ok(),
                            wisp:json_body(
                                _pipe,
                                gleam@json:to_string(
                                    route@display_terminal@service:display_terminal_list_to_json(
                                        X
                                    )
                                )
                            );

                        {error, Y} ->
                            _pipe@1 = wisp:not_found(),
                            wisp:json_body(
                                _pipe@1,
                                gleam@json:to_string(
                                    route@display_terminal@service:display_terminal_error_to_json(
                                        Y
                                    )
                                )
                            )
                    end;

                {error, _} ->
                    _pipe@2 = wisp:unprocessable_content(),
                    wisp:json_body(
                        _pipe@2,
                        gleam@json:to_string(
                            gleam@json:object(
                                [{<<"error"/utf8>>,
                                        gleam@json:string(
                                            <<"Error with limit value"/utf8>>
                                        )}]
                            )
                        )
                    )
            end;

        {error, _} ->
            _pipe@3 = wisp:unprocessable_content(),
            wisp:json_body(
                _pipe@3,
                gleam@json:to_string(
                    gleam@json:object(
                        [{<<"error"/utf8>>,
                                gleam@json:string(
                                    <<"Error with display id value"/utf8>>
                                )}]
                    )
                )
            )
    end.

-file("src/route/display_terminal/router.gleam", 22).
-spec handle_display_terminals(
    gleam@http:method(),
    list({binary(), binary()}),
    route@web:context(),
    binary()
) -> gleam@http@response:response(wisp:body()).
handle_display_terminals(Method, Query, Ctx, Id) ->
    case Method of
        get ->
            get_display_terminals(erlang:element(2, Ctx), Id, Query);

        _ ->
            wisp:method_not_allowed([get])
    end.

-file("src/route/display_terminal/router.gleam", 10).
-spec handle_display_terminal_request(
    gleam@http:method(),
    list(binary()),
    list({binary(), binary()}),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_display_terminal_request(Method, Path_segments, Query, Ctx) ->
    case Path_segments of
        [Id] ->
            handle_display_terminals(Method, Query, Ctx, Id);

        _ ->
            wisp:not_found()
    end.
