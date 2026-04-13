-module(route@media@service).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/media/service.gleam").
-export([get_new_media/1, media_error_to_json/1]).
-export_type([media_error/0]).

-type media_error() :: {database_error, gleam@json:json()} | not_found.

-file("src/route/media/service.gleam", 23).
-spec getnewmediarow_to_media(list(route@media@sql:get_new_media_row())) -> shared@media:media().
getnewmediarow_to_media(Media) ->
    Row@1 = case gleam@list:first(Media) of
        {ok, Row} -> Row;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"route/media/service"/utf8>>,
                        function => <<"getnewmediarow_to_media"/utf8>>,
                        line => 26,
                        value => _assert_fail,
                        start => 615,
                        'end' => 653,
                        pattern_start => 626,
                        pattern_end => 633})
    end,
    {media,
        erlang:element(2, Row@1),
        erlang:element(3, Row@1),
        erlang:element(4, Row@1),
        erlang:element(5, Row@1),
        erlang:element(6, Row@1),
        erlang:element(7, Row@1),
        erlang:element(8, Row@1)}.

-file("src/route/media/service.gleam", 13).
-spec get_new_media(pog:connection()) -> {ok, shared@media:media()} |
    {error, media_error()}.
get_new_media(Db) ->
    case route@media@sql:get_new_media(Db) of
        {ok, X} when erlang:element(2, X) =:= 1 ->
            {ok, getnewmediarow_to_media(erlang:element(3, X))};

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}};

        _ ->
            {error, not_found}
    end.

-file("src/route/media/service.gleam", 39).
-spec media_error_to_json(media_error()) -> gleam@json:json().
media_error_to_json(Error) ->
    case Error of
        {database_error, E} ->
            E;

        not_found ->
            gleam@json:object(
                [{<<"error"/utf8>>,
                        gleam@json:string(<<"Media not found"/utf8>>)}]
            )
    end.
