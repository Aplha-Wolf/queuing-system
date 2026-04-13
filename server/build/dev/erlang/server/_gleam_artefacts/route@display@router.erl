-module(route@display@router).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/display/router.gleam").
-export([handle_display_request/4]).
-export_type([quety_tyoe/0]).

-type quety_tyoe() :: all | {id, integer()} | {code, binary()}.

-file("src/route/display/router.gleam", 55).
-spec get_all_display(route@web:context()) -> gleam@http@response:response(wisp:body()).
get_all_display(_) ->
    _pipe = wisp:not_found(),
    wisp:json_body(
        _pipe,
        gleam@json:to_string(
            gleam@json:object(
                [{<<"message"/utf8>>,
                        gleam@json:string(<<"Not implemented yet"/utf8>>)}]
            )
        )
    ).

-file("src/route/display/router.gleam", 45).
-spec handle_getalldisplay_request(gleam@http:method(), route@web:context()) -> gleam@http@response:response(wisp:body()).
handle_getalldisplay_request(Method, Ctx) ->
    case Method of
        get ->
            get_all_display(Ctx);

        _ ->
            wisp:method_not_allowed([get])
    end.

-file("src/route/display/router.gleam", 75).
-spec get_display_by_code(binary(), pog:connection()) -> gleam@http@response:response(wisp:body()).
get_display_by_code(Code, Db) ->
    case route@display@service:get_display_by_code(Db, Code) of
        {ok, X} ->
            _pipe = wisp:ok(),
            wisp:json_body(
                _pipe,
                gleam@json:to_string(shared@display:to_json(X))
            );

        {error, Y} ->
            _pipe@1 = wisp:not_found(),
            wisp:json_body(
                _pipe@1,
                gleam@json:to_string(
                    route@display@service:display_error_to_json(Y)
                )
            )
    end.

-file("src/route/display/router.gleam", 64).
-spec handle_getdisplaybycode_request(
    gleam@http:method(),
    binary(),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_getdisplaybycode_request(Method, Code, Ctx) ->
    case Method of
        get ->
            get_display_by_code(Code, erlang:element(2, Ctx));

        _ ->
            wisp:method_not_allowed([get])
    end.

-file("src/route/display/router.gleam", 101).
-spec get_display_by_id(integer(), pog:connection()) -> gleam@http@response:response(wisp:body()).
get_display_by_id(Id, Db) ->
    case route@display@service:get_display_by_id(Db, Id) of
        {ok, X} ->
            _pipe = wisp:ok(),
            wisp:json_body(
                _pipe,
                gleam@json:to_string(shared@display:to_json(X))
            );

        {error, Y} ->
            _pipe@1 = wisp:not_found(),
            wisp:json_body(
                _pipe@1,
                gleam@json:to_string(
                    route@display@service:display_error_to_json(Y)
                )
            )
    end.

-file("src/route/display/router.gleam", 90).
-spec handle_getdisplaybyid_request(
    gleam@http:method(),
    integer(),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_getdisplaybyid_request(Method, Id, Ctx) ->
    case Method of
        get ->
            get_display_by_id(Id, erlang:element(2, Ctx));

        _ ->
            wisp:method_not_allowed([get])
    end.

-file("src/route/display/router.gleam", 116).
-spec get_code_from_path(list({binary(), binary()})) -> {ok, binary()} |
    {error, nil}.
get_code_from_path(Query) ->
    Res = begin
        _pipe = maps:from_list(Query),
        gleam_stdlib:map_get(_pipe, <<"code"/utf8>>)
    end,
    Res.

-file("src/route/display/router.gleam", 124).
-spec get_id_from_query(list({binary(), binary()})) -> {ok, integer()} |
    {error, nil}.
get_id_from_query(Query) ->
    Res = begin
        _pipe = maps:from_list(Query),
        _pipe@1 = gleam_stdlib:map_get(_pipe, <<"id"/utf8>>),
        (fun(X) -> case X of
                {ok, Id} ->
                    gleam_stdlib:parse_int(Id);

                {error, _} ->
                    {error, nil}
            end end)(_pipe@1)
    end,
    Res.

-file("src/route/display/router.gleam", 34).
-spec determine_display_request(list({binary(), binary()})) -> quety_tyoe().
determine_display_request(Query) ->
    Id = get_id_from_query(Query),
    Code = get_code_from_path(Query),
    case {Id, Code} of
        {{ok, Id@1}, _} ->
            {id, Id@1};

        {_, {ok, Code@1}} ->
            {code, Code@1};

        {_, _} ->
            all
    end.

-file("src/route/display/router.gleam", 17).
-spec handle_display_request(
    gleam@http:method(),
    list(binary()),
    list({binary(), binary()}),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_display_request(Method, Path_segments, Query, Ctx) ->
    case Path_segments of
        [] ->
            case determine_display_request(Query) of
                {id, Id} ->
                    handle_getdisplaybyid_request(Method, Id, Ctx);

                {code, Code} ->
                    handle_getdisplaybycode_request(Method, Code, Ctx);

                _ ->
                    handle_getalldisplay_request(Method, Ctx)
            end;

        _ ->
            wisp:not_found()
    end.
