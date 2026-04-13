-module(route@que@router).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/que/router.gleam").
-export([handle_queue_request/2]).
-export_type([terminal_queue/0]).

-type terminal_queue() :: {terminal_queue, integer(), binary()}.

-file("src/route/que/router.gleam", 179).
-spec get_terminal_code_from_query(list({binary(), binary()})) -> {ok, binary()} |
    {error, nil}.
get_terminal_code_from_query(Query) ->
    Res = begin
        _pipe = maps:from_list(Query),
        gleam_stdlib:map_get(_pipe, <<"code"/utf8>>)
    end,
    Res.

-file("src/route/que/router.gleam", 93).
-spec show_terminal_info(
    gleam@http@request:request(wisp@internal:connection()),
    pog:connection()
) -> gleam@http@response:response(wisp:body()).
show_terminal_info(Req, Db) ->
    Query = begin
        _pipe = wisp:get_query(Req),
        get_terminal_code_from_query(_pipe)
    end,
    case Query of
        {ok, Code} ->
            case route@que@service:show_terminal_info(Code, Db) of
                {ok, X} ->
                    _pipe@1 = wisp:ok(),
                    wisp:json_body(
                        _pipe@1,
                        gleam@json:to_string(
                            route@que@service:terminal_info_to_json(X)
                        )
                    );

                {error, Y} ->
                    _pipe@2 = wisp:not_found(),
                    wisp:json_body(
                        _pipe@2,
                        gleam@json:to_string(
                            route@que@service:que_error_to_json(Y)
                        )
                    )
            end;

        {error, _} ->
            _pipe@3 = wisp:unprocessable_content(),
            wisp:json_body(
                _pipe@3,
                gleam@json:to_string(
                    gleam@json:object(
                        [{<<"current"/utf8>>,
                                gleam@json:string(
                                    <<"Error with code value"/utf8>>
                                )}]
                    )
                )
            )
    end.

-file("src/route/que/router.gleam", 30).
-spec handle_terminal_queues(
    gleam@http@request:request(wisp@internal:connection()),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_terminal_queues(Req, Ctx) ->
    case erlang:element(2, Req) of
        get ->
            show_terminal_info(Req, erlang:element(2, Ctx));

        _ ->
            wisp:method_not_allowed([get])
    end.

-file("src/route/que/router.gleam", 123).
-spec show_terminal_onquesues(
    gleam@http@request:request(wisp@internal:connection()),
    pog:connection()
) -> gleam@http@response:response(wisp:body()).
show_terminal_onquesues(Req, Db) ->
    Query = begin
        _pipe = wisp:get_query(Req),
        get_terminal_code_from_query(_pipe)
    end,
    case Query of
        {ok, Code} ->
            case route@que@service:get_terminal_queues_by_code(Code, Db) of
                {ok, X} ->
                    _pipe@1 = wisp:ok(),
                    wisp:json_body(
                        _pipe@1,
                        gleam@json:to_string(
                            route@que@service:que_list_to_json(X)
                        )
                    );

                {error, Y} ->
                    _pipe@2 = wisp:not_found(),
                    wisp:json_body(
                        _pipe@2,
                        gleam@json:to_string(
                            route@que@service:que_error_to_json(Y)
                        )
                    )
            end;

        {error, _} ->
            _pipe@3 = wisp:unprocessable_content(),
            wisp:json_body(
                _pipe@3,
                gleam@json:to_string(
                    gleam@json:object(
                        [{<<"current"/utf8>>,
                                gleam@json:string(
                                    <<"Error with code value"/utf8>>
                                )}]
                    )
                )
            )
    end.

-file("src/route/que/router.gleam", 37).
-spec handle_terminal_onqueues(
    gleam@http@request:request(wisp@internal:connection()),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_terminal_onqueues(Req, Ctx) ->
    case erlang:element(2, Req) of
        get ->
            show_terminal_onquesues(Req, erlang:element(2, Ctx));

        _ ->
            wisp:method_not_allowed([get])
    end.

-file("src/route/que/router.gleam", 151).
-spec show_terminal_current(
    gleam@http@request:request(wisp@internal:connection()),
    pog:connection()
) -> gleam@http@response:response(wisp:body()).
show_terminal_current(Req, Db) ->
    Query = begin
        _pipe = wisp:get_query(Req),
        get_terminal_code_from_query(_pipe)
    end,
    case Query of
        {ok, Code} ->
            case route@que@service:get_terminal_queue_by_code(Code, Db) of
                {ok, X} ->
                    _pipe@1 = wisp:ok(),
                    wisp:json_body(
                        _pipe@1,
                        gleam@json:to_string(shared@queue:to_json(X))
                    );

                {error, Y} ->
                    _pipe@2 = wisp:not_found(),
                    wisp:json_body(
                        _pipe@2,
                        gleam@json:to_string(
                            route@que@service:que_error_to_json(Y)
                        )
                    )
            end;

        {error, _} ->
            _pipe@3 = wisp:unprocessable_content(),
            wisp:json_body(
                _pipe@3,
                gleam@json:to_string(
                    gleam@json:object(
                        [{<<"current"/utf8>>,
                                gleam@json:string(
                                    <<"Error with code value"/utf8>>
                                )}]
                    )
                )
            )
    end.

-file("src/route/que/router.gleam", 44).
-spec handle_terminal_current(
    gleam@http@request:request(wisp@internal:connection()),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_terminal_current(Req, Ctx) ->
    case erlang:element(2, Req) of
        get ->
            show_terminal_current(Req, erlang:element(2, Ctx));

        _ ->
            wisp:method_not_allowed([get])
    end.

-file("src/route/que/router.gleam", 217).
-spec get_terminal_id_from_query(list({binary(), binary()})) -> {ok, integer()} |
    {error, nil}.
get_terminal_id_from_query(Query) ->
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

-file("src/route/que/router.gleam", 65).
-spec recall_queue(
    gleam@http@request:request(wisp@internal:connection()),
    pog:connection()
) -> gleam@http@response:response(wisp:body()).
recall_queue(Req, Db) ->
    Query = begin
        _pipe = wisp:get_query(Req),
        get_terminal_id_from_query(_pipe)
    end,
    case Query of
        {ok, Id} ->
            case route@que@service:get_terminal_queue_by_id(Id, Db) of
                {ok, X} ->
                    _pipe@1 = wisp:ok(),
                    wisp:json_body(
                        _pipe@1,
                        gleam@json:to_string(shared@queue:to_json(X))
                    );

                {error, Y} ->
                    _pipe@2 = wisp:not_found(),
                    wisp:json_body(
                        _pipe@2,
                        gleam@json:to_string(
                            route@que@service:que_error_to_json(Y)
                        )
                    )
            end;

        {error, _} ->
            _pipe@3 = wisp:unprocessable_content(),
            wisp:json_body(
                _pipe@3,
                gleam@json:to_string(
                    gleam@json:object(
                        [{<<"current"/utf8>>,
                                gleam@json:string(
                                    <<"Error with id value"/utf8>>
                                )}]
                    )
                )
            )
    end.

-file("src/route/que/router.gleam", 58).
-spec handle_recall_terminal_queues(
    gleam@http@request:request(wisp@internal:connection()),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_recall_terminal_queues(Req, Ctx) ->
    case erlang:element(2, Req) of
        get ->
            recall_queue(Req, erlang:element(2, Ctx));

        _ ->
            wisp:method_not_allowed([get])
    end.

-file("src/route/que/router.gleam", 189).
-spec next_queue(
    gleam@http@request:request(wisp@internal:connection()),
    pog:connection()
) -> gleam@http@response:response(wisp:body()).
next_queue(Req, Db) ->
    Query = begin
        _pipe = wisp:get_query(Req),
        get_terminal_id_from_query(_pipe)
    end,
    case Query of
        {ok, Id} ->
            case route@que@service:next_queue(Id, Db) of
                {ok, X} ->
                    _pipe@1 = wisp:ok(),
                    wisp:json_body(
                        _pipe@1,
                        gleam@json:to_string(shared@queue:to_json(X))
                    );

                {error, Y} ->
                    _pipe@2 = wisp:not_found(),
                    wisp:json_body(
                        _pipe@2,
                        gleam@json:to_string(
                            route@que@service:que_error_to_json(Y)
                        )
                    )
            end;

        {error, _} ->
            _pipe@3 = wisp:unprocessable_content(),
            wisp:json_body(
                _pipe@3,
                gleam@json:to_string(
                    gleam@json:object(
                        [{<<"current"/utf8>>,
                                gleam@json:string(
                                    <<"Error with id value"/utf8>>
                                )}]
                    )
                )
            )
    end.

-file("src/route/que/router.gleam", 51).
-spec handle_next_terminal_queues(
    gleam@http@request:request(wisp@internal:connection()),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_next_terminal_queues(Req, Ctx) ->
    case erlang:element(2, Req) of
        get ->
            next_queue(Req, erlang:element(2, Ctx));

        _ ->
            wisp:method_not_allowed([get])
    end.

-file("src/route/que/router.gleam", 15).
-spec handle_queue_request(
    gleam@http@request:request(wisp@internal:connection()),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_queue_request(Req, Ctx) ->
    case fun gleam@http@request:path_segments/1(Req) of
        [<<"api"/utf8>>, <<"queues"/utf8>>, <<"terminals"/utf8>>] ->
            handle_terminal_queues(Req, Ctx);

        [<<"api"/utf8>>,
            <<"queues"/utf8>>,
            <<"terminals"/utf8>>,
            <<"next"/utf8>>] ->
            handle_next_terminal_queues(Req, Ctx);

        [<<"api"/utf8>>,
            <<"queues"/utf8>>,
            <<"terminals"/utf8>>,
            <<"recall"/utf8>>] ->
            handle_recall_terminal_queues(Req, Ctx);

        [<<"api"/utf8>>,
            <<"queues"/utf8>>,
            <<"terminals"/utf8>>,
            <<"onqueues"/utf8>>] ->
            handle_terminal_onqueues(Req, Ctx);

        [<<"api"/utf8>>,
            <<"queues"/utf8>>,
            <<"terminals"/utf8>>,
            <<"current"/utf8>>] ->
            handle_terminal_current(Req, Ctx);

        _ ->
            wisp:not_found()
    end.
