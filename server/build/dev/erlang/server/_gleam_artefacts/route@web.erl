-module(route@web).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/web.gleam").
-export([middleware/2]).
-export_type([context/0]).

-type context() :: {context, pog:connection()}.

-file("src/route/web.gleam", 10).
-spec cors(
    gleam@http@request:request(wisp@internal:connection()),
    gleam@http@response:response(wisp:body())
) -> gleam@http@response:response(wisp:body()).
cors(Req, Res) ->
    Origin@1 = case gleam@list:find(
        erlang:element(3, Req),
        fun(H) -> erlang:element(1, H) =:= <<"origin"/utf8>> end
    ) of
        {ok, {_, Origin}} ->
            Origin;

        {error, _} ->
            <<"*"/utf8>>
    end,
    _pipe = Res,
    _pipe@1 = fun gleam@http@response:set_header/3(
        _pipe,
        <<"access-control-allow-origin"/utf8>>,
        Origin@1
    ),
    _pipe@2 = fun gleam@http@response:set_header/3(
        _pipe@1,
        <<"access-control-allow-methods"/utf8>>,
        <<"GET, POST, PUT, PATCH, DELETE, OPTIONS"/utf8>>
    ),
    _pipe@3 = fun gleam@http@response:set_header/3(
        _pipe@2,
        <<"access-control-allow-headers"/utf8>>,
        <<"content-type, authorization, accept"/utf8>>
    ),
    fun gleam@http@response:set_header/3(
        _pipe@3,
        <<"access-control-max-age"/utf8>>,
        <<"86400"/utf8>>
    ).

-file("src/route/web.gleam", 28).
-spec middleware(
    gleam@http@request:request(wisp@internal:connection()),
    fun((gleam@http@request:request(wisp@internal:connection())) -> gleam@http@response:response(wisp:body()))
) -> gleam@http@response:response(wisp:body()).
middleware(Req, Handle_request) ->
    Priv_directory@1 = case fun gleam_erlang_ffi:priv_directory/1(
        <<"server"/utf8>>
    ) of
        {ok, Priv_directory} -> Priv_directory;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"route/web"/utf8>>,
                        function => <<"middleware"/utf8>>,
                        line => 32,
                        value => _assert_fail,
                        start => 759,
                        'end' => 820,
                        pattern_start => 770,
                        pattern_end => 788})
    end,
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
                                <<"/"/utf8>>,
                                Priv_directory@1,
                                fun() -> case erlang:element(2, Req@2) of
                                        options ->
                                            cors(Req@2, wisp:no_content());

                                        _ ->
                                            _pipe = Handle_request(Req@2),
                                            cors(Req@2, _pipe)
                                    end end
                            )
                        end
                    )
                end
            )
        end
    ).
