-module(lustre_dev_tools@dev@proxy).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/lustre_dev_tools/dev/proxy.gleam").
-export([new/2, get_proxies_from_config/2, handle/3]).
-export_type([proxy/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-type proxy() :: {proxy, binary(), gleam@uri:uri()}.

-file("src/lustre_dev_tools/dev/proxy.gleam", 26).
?DOC(false).
-spec new(binary(), binary()) -> {ok, proxy()} |
    {error, lustre_dev_tools@error:error()}.
new(From, To) ->
    case {From, To} of
        {<<""/utf8>>, <<""/utf8>>} ->
            {error, proxy_missing_from_to};

        {<<""/utf8>>, _} ->
            {error, proxy_missing_from};

        {_, <<""/utf8>>} ->
            {error, proxy_missing_to};

        {<<"/"/utf8, _/binary>>, _} ->
            case gleam_stdlib:uri_parse(To) of
                {ok, Uri} ->
                    {ok, {proxy, From, Uri}};

                {error, _} ->
                    {error, proxy_invalid_to}
            end;

        {_, _} ->
            case gleam_stdlib:uri_parse(To) of
                {ok, Uri@1} ->
                    {ok, {proxy, <<"/"/utf8, From/binary>>, Uri@1}};

                {error, _} ->
                    {error, proxy_invalid_to}
            end
    end.

-file("src/lustre_dev_tools/dev/proxy.gleam", 46).
?DOC(false).
-spec parse_proxy(gleam@dict:dict(binary(), tom:toml())) -> {ok, proxy()} |
    {error, lustre_dev_tools@error:error()}.
parse_proxy(Options) ->
    gleam@result:'try'(
        begin
            _pipe = tom:get_string(Options, [<<"from"/utf8>>]),
            gleam@result:replace_error(_pipe, proxy_missing_from)
        end,
        fun(From) ->
            gleam@result:'try'(
                begin
                    _pipe@1 = tom:get_string(Options, [<<"to"/utf8>>]),
                    gleam@result:replace_error(_pipe@1, proxy_missing_to)
                end,
                fun(To) -> new(From, To) end
            )
        end
    ).

-file("src/lustre_dev_tools/dev/proxy.gleam", 58).
?DOC(false).
-spec get_proxies_from_config(
    gleam@dict:dict(binary(), tom:toml()),
    list(binary())
) -> {ok, list(proxy())} | {error, lustre_dev_tools@error:error()}.
get_proxies_from_config(Config, Path) ->
    case tom:get(Config, Path) of
        {ok, Proxy_toml} ->
            case Proxy_toml of
                {inline_table, Table} ->
                    _pipe = Table,
                    _pipe@1 = parse_proxy(_pipe),
                    gleam@result:map(_pipe@1, fun gleam@list:wrap/1);

                {array, Array} ->
                    _pipe@2 = Array,
                    _pipe@3 = gleam@list:map(
                        _pipe@2,
                        fun(Table@1) -> case Table@1 of
                                {inline_table, Proxy} ->
                                    parse_proxy(Proxy);

                                _ ->
                                    {error, proxy_invalid_config}
                            end end
                    ),
                    gleam@result:all(_pipe@3);

                _ ->
                    {error, proxy_invalid_config}
            end;

        {error, E} ->
            case E of
                {not_found, _} ->
                    {ok, []};

                {wrong_type, _, _, _} ->
                    {error, proxy_invalid_config}
            end
    end.

-file("src/lustre_dev_tools/dev/proxy.gleam", 93).
?DOC(false).
-spec handle(
    gleam@http@request:request(wisp@internal:connection()),
    list(proxy()),
    fun(() -> gleam@http@response:response(wisp:body()))
) -> gleam@http@response:response(wisp:body()).
handle(Request, Proxies, Next) ->
    Response_result = begin
        gleam@list:find_map(
            Proxies,
            fun(_use0) ->
                {proxy, From, To} = _use0,
                case gleam@string:split_once(erlang:element(8, Request), From) of
                    {ok, {<<""/utf8>>, Path}} ->
                        Internal_error = begin
                            _pipe = gleam@http@response:new(500),
                            gleam@http@response:set_body(
                                _pipe,
                                {bytes, gleam@bytes_tree:new()}
                            )
                        end,
                        Path@1 = filepath:join(erlang:element(6, To), Path),
                        Host@1 = case erlang:element(4, To) of
                            {some, Host} -> Host;
                            _assert_fail ->
                                erlang:error(#{gleam_error => let_assert,
                                            message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                            file => <<?FILEPATH/utf8>>,
                                            module => <<"lustre_dev_tools/dev/proxy"/utf8>>,
                                            function => <<"handle"/utf8>>,
                                            line => 107,
                                            value => _assert_fail,
                                            start => 2907,
                                            'end' => 2938,
                                            pattern_start => 2918,
                                            pattern_end => 2928})
                        end,
                        Body@1 = case wisp:read_body_bits(Request) of
                            {ok, Body} -> Body;
                            _assert_fail@1 ->
                                erlang:error(#{gleam_error => let_assert,
                                            message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                            file => <<?FILEPATH/utf8>>,
                                            module => <<"lustre_dev_tools/dev/proxy"/utf8>>,
                                            function => <<"handle"/utf8>>,
                                            line => 108,
                                            value => _assert_fail@1,
                                            start => 2947,
                                            'end' => 2997,
                                            pattern_start => 2958,
                                            pattern_end => 2966})
                        end,
                        _pipe@1 = {request,
                            erlang:element(2, Request),
                            erlang:element(3, Request),
                            Body@1,
                            erlang:element(5, Request),
                            Host@1,
                            erlang:element(5, To),
                            Path@1,
                            erlang:element(9, Request)},
                        _pipe@2 = gleam@httpc:send_bits(_pipe@1),
                        _pipe@3 = gleam@result:map(
                            _pipe@2,
                            fun(_capture) ->
                                gleam@http@response:map(
                                    _capture,
                                    fun gleam@bytes_tree:from_bit_array/1
                                )
                            end
                        ),
                        _pipe@4 = gleam@result:map(
                            _pipe@3,
                            fun(_capture@1) ->
                                gleam@http@response:map(
                                    _capture@1,
                                    fun(Field@0) -> {bytes, Field@0} end
                                )
                            end
                        ),
                        _pipe@5 = gleam@result:unwrap(_pipe@4, Internal_error),
                        {ok, _pipe@5};

                    _ ->
                        {error, nil}
                end
            end
        )
    end,
    case Response_result of
        {ok, R} ->
            R;

        _ ->
            Next()
    end.
