-module(lustre@runtime@app).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/lustre/runtime/app.gleam").
-export([configure_server_component/1, configure/1]).
-export_type([app/3, config/1, option/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-type app(SJG, SJH, SJI) :: {app,
        gleam@option:option(gleam@erlang@process:name(lustre@runtime@server@runtime:message(SJI))),
        fun((SJG) -> {SJH, lustre@effect:effect(SJI)}),
        fun((SJH, SJI) -> {SJH, lustre@effect:effect(SJI)}),
        fun((SJH) -> lustre@vdom@vnode:element(SJI)),
        config(SJI)}.

-type config(SJJ) :: {config,
        boolean(),
        boolean(),
        boolean(),
        list({binary(), fun((binary()) -> {ok, SJJ} | {error, nil})}),
        list({binary(), gleam@dynamic@decode:decoder(SJJ)}),
        list({binary(), gleam@dynamic@decode:decoder(SJJ)}),
        boolean(),
        gleam@option:option(fun((binary()) -> SJJ)),
        gleam@option:option(SJJ),
        gleam@option:option(fun((binary()) -> SJJ)),
        gleam@option:option(SJJ),
        gleam@option:option(SJJ),
        gleam@option:option(SJJ)}.

-type option(SJK) :: {option, fun((config(SJK)) -> config(SJK))}.

-file("src/lustre/runtime/app.gleam", 75).
?DOC(false).
-spec configure_server_component(config(SJP)) -> lustre@runtime@server@runtime:config(SJP).
configure_server_component(Config) ->
    {config,
        erlang:element(2, Config),
        erlang:element(3, Config),
        maps:from_list(lists:reverse(erlang:element(5, Config))),
        maps:from_list(lists:reverse(erlang:element(6, Config))),
        maps:from_list(lists:reverse(erlang:element(7, Config))),
        erlang:element(12, Config),
        erlang:element(14, Config)}.

-file("src/lustre/runtime/app.gleam", 71).
?DOC(false).
-spec configure(list(option(SJL))) -> config(SJL).
configure(Options) ->
    gleam@list:fold(
        Options,
        {config,
            true,
            true,
            false,
            [],
            [],
            [],
            false,
            none,
            none,
            none,
            none,
            none,
            none},
        fun(Config, Option) -> (erlang:element(2, Option))(Config) end
    ).
