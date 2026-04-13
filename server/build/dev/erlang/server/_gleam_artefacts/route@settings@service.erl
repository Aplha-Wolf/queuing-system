-module(route@settings@service).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/settings/service.gleam").
-export([get_settings/1, update_settings/2, settings_to_json/1, settings_error_to_json/1]).
-export_type([settings_error/0]).

-type settings_error() :: {database_error, gleam@json:json()} | not_found.

-file("src/route/settings/service.gleam", 13).
-spec get_settings(pog:connection()) -> {ok, shared@route_settings:settings()} |
    {error, settings_error()}.
get_settings(Db) ->
    case route@settings@sql:get_settings(Db) of
        {ok, X} ->
            case gleam@list:first(erlang:element(3, X)) of
                {ok, Row} ->
                    {ok,
                        {settings,
                            erlang:element(3, Row),
                            erlang:element(4, Row),
                            erlang:element(5, Row),
                            erlang:element(6, Row),
                            erlang:element(7, Row),
                            erlang:element(8, Row),
                            erlang:element(9, Row),
                            erlang:element(10, Row),
                            erlang:element(11, Row),
                            erlang:element(12, Row),
                            erlang:element(13, Row),
                            erlang:element(14, Row),
                            erlang:element(15, Row),
                            erlang:element(16, Row),
                            erlang:element(17, Row),
                            erlang:element(18, Row),
                            erlang:element(19, Row)}};

                {error, _} ->
                    {error, not_found}
            end;

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}}
    end.

-file("src/route/settings/service.gleam", 47).
-spec update_settings(pog:connection(), shared@route_settings:settings()) -> {ok,
        shared@route_settings:settings()} |
    {error, settings_error()}.
update_settings(Db, Settings) ->
    case route@settings@sql:update_settings(
        Db,
        erlang:element(2, Settings),
        erlang:element(3, Settings),
        erlang:element(4, Settings),
        erlang:element(5, Settings),
        erlang:element(6, Settings),
        erlang:element(7, Settings),
        erlang:element(8, Settings),
        erlang:element(9, Settings),
        erlang:element(10, Settings),
        erlang:element(11, Settings),
        erlang:element(12, Settings),
        erlang:element(13, Settings),
        erlang:element(14, Settings),
        erlang:element(15, Settings),
        erlang:element(16, Settings),
        erlang:element(17, Settings),
        erlang:element(18, Settings)
    ) of
        {ok, _} ->
            get_settings(Db);

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}}
    end.

-file("src/route/settings/service.gleam", 78).
-spec settings_to_json(shared@route_settings:settings()) -> gleam@json:json().
settings_to_json(Settings) ->
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

-file("src/route/settings/service.gleam", 100).
-spec settings_error_to_json(settings_error()) -> gleam@json:json().
settings_error_to_json(Error) ->
    case Error of
        {database_error, E} ->
            E;

        not_found ->
            gleam@json:object(
                [{<<"message"/utf8>>,
                        gleam@json:string(<<"Settings not found"/utf8>>)}]
            )
    end.
