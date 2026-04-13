-module(server).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/server.gleam").
-export([main/0]).

-file("src/server.gleam", 10).
-spec main() -> nil.
main() ->
    helpers@env_loader:load_env_file(<<"./.env"/utf8>>),
    wisp:configure_logger(),
    Secret_key_base = wisp:random_string(64),
    Pool@1 = case helpers@sql:start_db_pool() of
        {ok, Pool} -> Pool;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"server"/utf8>>,
                        function => <<"main"/utf8>>,
                        line => 15,
                        value => _assert_fail,
                        start => 300,
                        'end' => 348,
                        pattern_start => 311,
                        pattern_end => 319})
    end,
    Db = helpers@sql:db_connection(Pool@1),
    Context = {context, Db},
    case begin
        _pipe = fun(_capture) ->
            route@router:handle_request(_capture, Context)
        end,
        _pipe@1 = wisp@wisp_mist:handler(_pipe, Secret_key_base),
        _pipe@2 = mist:new(_pipe@1),
        _pipe@3 = mist:port(_pipe@2, 3001),
        mist:start(_pipe@3)
    end of
        {ok, _} -> nil;
        _assert_fail@1 ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"server"/utf8>>,
                        function => <<"main"/utf8>>,
                        line => 19,
                        value => _assert_fail@1,
                        start => 430,
                        'end' => 585,
                        pattern_start => 441,
                        pattern_end => 446})
    end,
    gleam_erlang_ffi:sleep_forever().
