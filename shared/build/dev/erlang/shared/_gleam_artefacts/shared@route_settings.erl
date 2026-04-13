-module(shared@route_settings).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/shared/route_settings.gleam").
-export([default_settings/0, to_json/1]).
-export_type([settings/0]).

-type settings() :: {settings,
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary()}.

-file("src/shared/route_settings.gleam", 25).
-spec default_settings() -> settings().
default_settings() ->
    {settings,
        <<"#1f2937"/utf8>>,
        <<"#f9fafb"/utf8>>,
        <<"#9ca3af"/utf8>>,
        <<"#374151"/utf8>>,
        <<"#4b5563"/utf8>>,
        <<"#f9fafb"/utf8>>,
        <<"#2563eb"/utf8>>,
        <<"#4b5563"/utf8>>,
        <<"#374151"/utf8>>,
        <<"#4b5563"/utf8>>,
        <<"#f9fafb"/utf8>>,
        <<"#1e3a8a"/utf8>>,
        <<"#f9fafb"/utf8>>,
        <<"#4b5563"/utf8>>,
        <<"#22c55e"/utf8>>,
        <<"#ef4444"/utf8>>,
        <<"#eab308"/utf8>>}.

-file("src/shared/route_settings.gleam", 47).
-spec to_json(settings()) -> gleam@json:json().
to_json(Settings) ->
    gleam@json:object(
        [{<<"background"/utf8>>, gleam@json:string(erlang:element(2, Settings))},
            {<<"text_primary"/utf8>>,
                gleam@json:string(erlang:element(3, Settings))},
            {<<"text_secondary"/utf8>>,
                gleam@json:string(erlang:element(4, Settings))},
            {<<"card_background"/utf8>>,
                gleam@json:string(erlang:element(5, Settings))},
            {<<"card_border"/utf8>>,
                gleam@json:string(erlang:element(6, Settings))},
            {<<"card_text"/utf8>>,
                gleam@json:string(erlang:element(7, Settings))},
            {<<"button_primary"/utf8>>,
                gleam@json:string(erlang:element(8, Settings))},
            {<<"button_secondary"/utf8>>,
                gleam@json:string(erlang:element(9, Settings))},
            {<<"input_background"/utf8>>,
                gleam@json:string(erlang:element(10, Settings))},
            {<<"input_border"/utf8>>,
                gleam@json:string(erlang:element(11, Settings))},
            {<<"input_text"/utf8>>,
                gleam@json:string(erlang:element(12, Settings))},
            {<<"header_background"/utf8>>,
                gleam@json:string(erlang:element(13, Settings))},
            {<<"header_text"/utf8>>,
                gleam@json:string(erlang:element(14, Settings))},
            {<<"border"/utf8>>, gleam@json:string(erlang:element(15, Settings))},
            {<<"success"/utf8>>,
                gleam@json:string(erlang:element(16, Settings))},
            {<<"danger"/utf8>>, gleam@json:string(erlang:element(17, Settings))},
            {<<"warning"/utf8>>,
                gleam@json:string(erlang:element(18, Settings))}]
    ).
