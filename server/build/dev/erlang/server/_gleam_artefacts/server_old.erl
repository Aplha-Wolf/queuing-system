-module(server_old).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/server_old.gleam").
-export([main_old/0]).

-file("src/server_old.gleam", 36).
-spec app_middleware(
    gleam@http@request:request(wisp@internal:connection()),
    binary(),
    fun((gleam@http@request:request(wisp@internal:connection())) -> gleam@http@response:response(wisp:body()))
) -> gleam@http@response:response(wisp:body()).
app_middleware(Req, Static_directory, Next) ->
    Req@1 = wisp:method_override(Req),
    wisp:log_request(
        Req@1,
        fun() ->
            wisp:rescue_crashes(
                fun() ->
                    wisp:handle_head(
                        Req@1,
                        fun(Req@2) ->
                            wisp:serve_static(
                                Req@2,
                                <<"/static"/utf8>>,
                                Static_directory,
                                fun() -> Next(Req@2) end
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/server_old.gleam", 69).
-spec serve_index(storail:collection(list(shared@groceries:grocery_item()))) -> gleam@http@response:response(wisp:body()).
serve_index(Db) ->
    Html = lustre@element@html:html(
        [],
        [lustre@element@html:head(
                [],
                [lustre@element@html:title([], <<"Grocery List"/utf8>>),
                    lustre@element@html:script(
                        [lustre@attribute:type_(<<"module"/utf8>>),
                            lustre@attribute:src(<<"/static/client.js"/utf8>>)],
                        <<""/utf8>>
                    )]
            ),
            lustre@element@html:body(
                [],
                [lustre@element@html:'div'(
                        [lustre@attribute:id(<<"app"/utf8>>)],
                        []
                    )]
            )]
    ),
    _pipe = Html,
    _pipe@1 = lustre@element:to_document_string(_pipe),
    wisp:html_response(_pipe@1, 200).

-file("src/server_old.gleam", 105).
-spec setup_database() -> {ok,
        storail:collection(list(shared@groceries:grocery_item()))} |
    {error, nil}.
setup_database() ->
    Config = {config, <<"./data"/utf8>>},
    Items = {collection,
        <<"grocery_list"/utf8>>,
        fun shared@groceries:grocery_list_to_json/1,
        shared@groceries:grocery_list_decoder(),
        Config},
    {ok, Items}.

-file("src/server_old.gleam", 119).
-spec grocery_list_key(
    storail:collection(list(shared@groceries:grocery_item()))
) -> storail:key(list(shared@groceries:grocery_item())).
grocery_list_key(Db) ->
    storail:key(Db, <<"grocery_list"/utf8>>).

-file("src/server_old.gleam", 127).
-spec save_items_to_db(
    storail:collection(list(shared@groceries:grocery_item())),
    list(shared@groceries:grocery_item())
) -> {ok, nil} | {error, storail:storail_error()}.
save_items_to_db(Db, Items) ->
    storail:write(grocery_list_key(Db), Items).

-file("src/server_old.gleam", 87).
-spec handle_save_groceries(
    storail:collection(list(shared@groceries:grocery_item())),
    gleam@http@request:request(wisp@internal:connection())
) -> gleam@http@response:response(wisp:body()).
handle_save_groceries(Db, Req) ->
    wisp:require_json(
        Req,
        fun(Json) ->
            case gleam@dynamic@decode:run(
                Json,
                shared@groceries:grocery_list_decoder()
            ) of
                {ok, Items} ->
                    case save_items_to_db(Db, Items) of
                        {ok, _} ->
                            wisp:ok();

                        {error, _} ->
                            wisp:internal_server_error()
                    end;

                {error, _} ->
                    wisp:bad_request(<<"Request failed"/utf8>>)
            end
        end
    ).

-file("src/server_old.gleam", 50).
-spec handle_request(
    storail:collection(list(shared@groceries:grocery_item())),
    binary(),
    gleam@http@request:request(wisp@internal:connection())
) -> gleam@http@response:response(wisp:body()).
handle_request(Db, Static_directory, Req) ->
    app_middleware(
        Req,
        Static_directory,
        fun(Req@1) ->
            case {erlang:element(2, Req@1),
                fun gleam@http@request:path_segments/1(Req@1)} of
                {post, [<<"api"/utf8>>, <<"groceries"/utf8>>]} ->
                    handle_save_groceries(Db, Req@1);

                {get, _} ->
                    serve_index(Db);

                {_, _} ->
                    wisp:not_found()
            end
        end
    ).

-file("src/server_old.gleam", 14).
-spec main_old() -> nil.
main_old() ->
    wisp:configure_logger(),
    Secret_key_base = wisp:random_string(64),
    Db@1 = case setup_database() of
        {ok, Db} -> Db;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"server_old"/utf8>>,
                        function => <<"main_old"/utf8>>,
                        line => 19,
                        value => _assert_fail,
                        start => 416,
                        'end' => 452,
                        pattern_start => 427,
                        pattern_end => 433})
    end,
    Priv_directory@1 = case fun gleam_erlang_ffi:priv_directory/1(
        <<"server"/utf8>>
    ) of
        {ok, Priv_directory} -> Priv_directory;
        _assert_fail@1 ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"server_old"/utf8>>,
                        function => <<"main_old"/utf8>>,
                        line => 21,
                        value => _assert_fail@1,
                        start => 456,
                        'end' => 517,
                        pattern_start => 467,
                        pattern_end => 485})
    end,
    Static_directory = <<Priv_directory@1/binary, "/static"/utf8>>,
    case begin
        _pipe = fun(_capture) ->
            handle_request(Db@1, Static_directory, _capture)
        end,
        _pipe@1 = wisp@wisp_mist:handler(_pipe, Secret_key_base),
        _pipe@2 = mist:new(_pipe@1),
        _pipe@3 = mist:port(_pipe@2, 3000),
        mist:start(_pipe@3)
    end of
        {ok, _} -> nil;
        _assert_fail@2 ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"server_old"/utf8>>,
                        function => <<"main_old"/utf8>>,
                        line => 24,
                        value => _assert_fail@2,
                        start => 574,
                        'end' => 735,
                        pattern_start => 585,
                        pattern_end => 590})
    end,
    gleam_erlang_ffi:sleep_forever().
