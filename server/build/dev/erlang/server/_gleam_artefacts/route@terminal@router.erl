-module(route@terminal@router).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/terminal/router.gleam").
-export([handle_terminal_request/2]).
-export_type([terminal/0]).

-type terminal() :: {terminal,
        integer(),
        binary(),
        binary(),
        binary(),
        boolean()}.

-file("src/route/terminal/router.gleam", 50).
-spec list_terminals(pog:connection()) -> gleam@http@response:response(wisp:body()).
list_terminals(Db) ->
    case route@terminal@service:list_all_terminals(Db) of
        {ok, X} ->
            _pipe = wisp:ok(),
            wisp:json_body(
                _pipe,
                gleam@json:to_string(
                    route@terminal@service:terminal_list_to_json(X)
                )
            );

        {error, Y} ->
            _pipe@1 = wisp:internal_server_error(),
            wisp:json_body(
                _pipe@1,
                gleam@json:to_string(
                    route@terminal@service:terminal_error_to_json(Y)
                )
            )
    end.

-file("src/route/terminal/router.gleam", 63).
-spec add_terminal(
    gleam@http@request:request(wisp@internal:connection()),
    pog:connection()
) -> gleam@http@response:response(wisp:body()).
add_terminal(Req, Db) ->
    wisp:require_json(
        Req,
        fun(Req_body) ->
            Decoder = begin
                gleam@dynamic@decode:field(
                    <<"code"/utf8>>,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Code) ->
                        gleam@dynamic@decode:field(
                            <<"name"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Name) ->
                                gleam@dynamic@decode:success(
                                    {terminal, 0, <<""/utf8>>, Code, Name, true}
                                )
                            end
                        )
                    end
                )
            end,
            case gleam@dynamic@decode:run(Req_body, Decoder) of
                {ok, Json_body} ->
                    case route@terminal@service:add_terminal(
                        Db,
                        erlang:element(4, Json_body),
                        erlang:element(5, Json_body)
                    ) of
                        {ok, X} ->
                            _pipe = wisp:created(),
                            wisp:json_body(
                                _pipe,
                                gleam@json:to_string(
                                    route@terminal@service:add_terminal_result_to_json(
                                        X
                                    )
                                )
                            );

                        {error, Y} ->
                            _pipe@1 = wisp:internal_server_error(),
                            wisp:json_body(
                                _pipe@1,
                                gleam@json:to_string(
                                    route@terminal@service:terminal_error_to_json(
                                        Y
                                    )
                                )
                            )
                    end;

                {error, _} ->
                    wisp:unprocessable_content()
            end
        end
    ).

-file("src/route/terminal/router.gleam", 97).
-spec delete_terminal(pog:connection(), binary()) -> gleam@http@response:response(wisp:body()).
delete_terminal(Db, Id) ->
    case gleam_stdlib:parse_int(Id) of
        {ok, Id@1} ->
            case route@terminal@service:delete_terminal(Db, Id@1) of
                {ok, X} ->
                    _pipe = wisp:ok(),
                    wisp:json_body(
                        _pipe,
                        gleam@json:to_string(
                            route@terminal@service:delete_terminal_result_to_json(
                                X
                            )
                        )
                    );

                {error, Y} ->
                    _pipe@1 = wisp:not_found(),
                    wisp:json_body(
                        _pipe@1,
                        gleam@json:to_string(
                            route@terminal@service:terminal_error_to_json(Y)
                        )
                    )
            end;

        {error, _} ->
            wisp:unprocessable_content()
    end.

-file("src/route/terminal/router.gleam", 138).
-spec show_terminal_by_id(pog:connection(), binary()) -> gleam@http@response:response(wisp:body()).
show_terminal_by_id(Db, Id) ->
    case gleam_stdlib:parse_int(Id) of
        {ok, Id@1} ->
            case route@terminal@service:find_terminal_by_id(Db, Id@1) of
                {ok, X} ->
                    _pipe = wisp:ok(),
                    wisp:json_body(
                        _pipe,
                        gleam@json:to_string(shared@terminal:to_json(X))
                    );

                {error, Y} ->
                    _pipe@1 = wisp:not_found(),
                    wisp:json_body(
                        _pipe@1,
                        gleam@json:to_string(
                            route@terminal@service:terminal_error_to_json(Y)
                        )
                    )
            end;

        {error, _} ->
            wisp:unprocessable_content()
    end.

-file("src/route/terminal/router.gleam", 156).
-spec show_terminal_by_code(pog:connection(), binary()) -> gleam@http@response:response(wisp:body()).
show_terminal_by_code(Db, Code) ->
    case route@terminal@service:find_terminal_by_code(Db, Code) of
        {ok, X} ->
            _pipe = wisp:ok(),
            wisp:json_body(
                _pipe,
                gleam@json:to_string(shared@terminal:to_json(X))
            );

        {error, Y} ->
            _pipe@1 = wisp:not_found(),
            wisp:json_body(
                _pipe@1,
                gleam@json:to_string(
                    route@terminal@service:terminal_error_to_json(Y)
                )
            )
    end.

-file("src/route/terminal/router.gleam", 169).
-spec show_terminal_by_name(pog:connection(), binary()) -> gleam@http@response:response(wisp:body()).
show_terminal_by_name(Db, Name) ->
    case route@terminal@service:find_terminal_by_name(Db, Name) of
        {ok, X} ->
            _pipe = wisp:ok(),
            wisp:json_body(
                _pipe,
                gleam@json:to_string(shared@terminal:to_json(X))
            );

        {error, Y} ->
            _pipe@1 = wisp:not_found(),
            wisp:json_body(
                _pipe@1,
                gleam@json:to_string(
                    route@terminal@service:terminal_error_to_json(Y)
                )
            )
    end.

-file("src/route/terminal/router.gleam", 122).
-spec determine_show_query(list({binary(), binary()}), pog:connection()) -> gleam@http@response:response(wisp:body()).
determine_show_query(Query, Db) ->
    case Query of
        [] ->
            list_terminals(Db);

        [X | Y] ->
            case erlang:element(1, X) of
                <<"id"/utf8>> ->
                    show_terminal_by_id(Db, erlang:element(2, X));

                <<"code"/utf8>> ->
                    show_terminal_by_code(Db, erlang:element(2, X));

                <<"name"/utf8>> ->
                    show_terminal_by_name(Db, erlang:element(2, X));

                _ ->
                    determine_show_query(Y, Db)
            end
    end.

-file("src/route/terminal/router.gleam", 117).
-spec show_terminal(
    gleam@http@request:request(wisp@internal:connection()),
    pog:connection()
) -> gleam@http@response:response(wisp:body()).
show_terminal(Req, Db) ->
    Query = wisp:get_query(Req),
    determine_show_query(Query, Db).

-file("src/route/terminal/router.gleam", 29).
-spec handle_list_add_terminal(
    gleam@http@request:request(wisp@internal:connection()),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_list_add_terminal(Req, Ctx) ->
    case erlang:element(2, Req) of
        get ->
            show_terminal(Req, erlang:element(2, Ctx));

        post ->
            add_terminal(Req, erlang:element(2, Ctx));

        _ ->
            wisp:method_not_allowed([get, post])
    end.

-file("src/route/terminal/router.gleam", 182).
-spec update_terminal(
    gleam@http@request:request(wisp@internal:connection()),
    pog:connection(),
    binary()
) -> gleam@http@response:response(wisp:body()).
update_terminal(Req, Db, Id) ->
    case gleam_stdlib:parse_int(Id) of
        {ok, Int_id} ->
            wisp:require_json(
                Req,
                fun(Req_body) ->
                    Decoder = begin
                        gleam@dynamic@decode:field(
                            <<"code"/utf8>>,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Code) ->
                                gleam@dynamic@decode:field(
                                    <<"name"/utf8>>,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Name) ->
                                        gleam@dynamic@decode:field(
                                            <<"active"/utf8>>,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_bool/1},
                                            fun(Active) ->
                                                gleam@dynamic@decode:success(
                                                    {terminal,
                                                        Int_id,
                                                        <<""/utf8>>,
                                                        Code,
                                                        Name,
                                                        Active}
                                                )
                                            end
                                        )
                                    end
                                )
                            end
                        )
                    end,
                    case gleam@dynamic@decode:run(Req_body, Decoder) of
                        {ok, Json_body} ->
                            case route@terminal@service:update_terminal(
                                Db,
                                erlang:element(4, Json_body),
                                erlang:element(5, Json_body),
                                erlang:element(6, Json_body),
                                Int_id
                            ) of
                                {ok, X} ->
                                    _pipe = wisp:ok(),
                                    wisp:json_body(
                                        _pipe,
                                        gleam@json:to_string(
                                            route@terminal@service:update_terminal_result_to_json(
                                                X
                                            )
                                        )
                                    );

                                {error, Y} ->
                                    _pipe@1 = wisp:internal_server_error(),
                                    wisp:json_body(
                                        _pipe@1,
                                        gleam@json:to_string(
                                            route@terminal@service:terminal_error_to_json(
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
                                                    <<"Unprocessable request's body"/utf8>>
                                                )}]
                                    )
                                )
                            )
                    end
                end
            );

        {error, _} ->
            _pipe@3 = wisp:unprocessable_content(),
            wisp:json_body(
                _pipe@3,
                gleam@json:to_string(
                    gleam@json:object(
                        [{<<"error"/utf8>>,
                                gleam@json:string(
                                    <<"Unable to parse int value from request query"/utf8>>
                                )}]
                    )
                )
            )
    end.

-file("src/route/terminal/router.gleam", 37).
-spec handle_update_delete_terminal(
    gleam@http@request:request(wisp@internal:connection()),
    route@web:context(),
    binary()
) -> gleam@http@response:response(wisp:body()).
handle_update_delete_terminal(Req, Ctx, Id) ->
    case erlang:element(2, Req) of
        get ->
            show_terminal(Req, erlang:element(2, Ctx));

        post ->
            update_terminal(Req, erlang:element(2, Ctx), Id);

        delete ->
            delete_terminal(erlang:element(2, Ctx), Id);

        _ ->
            wisp:method_not_allowed([get, post, delete])
    end.

-file("src/route/terminal/router.gleam", 21).
-spec handle_terminal_request(
    gleam@http@request:request(wisp@internal:connection()),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_terminal_request(Req, Ctx) ->
    case fun gleam@http@request:path_segments/1(Req) of
        [<<"api"/utf8>>, <<"terminals"/utf8>>] ->
            handle_list_add_terminal(Req, Ctx);

        [<<"api"/utf8>>, <<"terminals"/utf8>>, Id] ->
            handle_update_delete_terminal(Req, Ctx, Id);

        _ ->
            wisp:not_found()
    end.
