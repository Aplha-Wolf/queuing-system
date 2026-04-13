-module(route@media@router).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/media/router.gleam").
-export([handle_media_request/2]).

-file("src/route/media/router.gleam", 27).
-spec identify_media_request() -> gleam@http@response:response(wisp:body()).
identify_media_request() ->
    Html = gleam_stdlib:identity(<<"Media!"/utf8>>),
    _pipe = wisp:ok(),
    wisp:html_body(_pipe, unicode:characters_to_binary(Html)).

-file("src/route/media/router.gleam", 33).
-spec create_media(gleam@http@request:request(wisp@internal:connection())) -> gleam@http@response:response(wisp:body()).
create_media(_) ->
    Html = gleam_stdlib:identity(<<"Created"/utf8>>),
    _pipe = wisp:created(),
    wisp:html_body(_pipe, unicode:characters_to_binary(Html)).

-file("src/route/media/router.gleam", 19).
-spec show_medias(gleam@http@request:request(wisp@internal:connection())) -> gleam@http@response:response(wisp:body()).
show_medias(Req) ->
    case erlang:element(2, Req) of
        get ->
            identify_media_request();

        post ->
            create_media(Req);

        _ ->
            wisp:method_not_allowed([get, post])
    end.

-file("src/route/media/router.gleam", 39).
-spec show_media(
    gleam@http@request:request(wisp@internal:connection()),
    binary()
) -> gleam@http@response:response(wisp:body()).
show_media(Req, Id) ->
    wisp:require_method(
        Req,
        get,
        fun() ->
            Html = gleam_stdlib:identity(<<"Comment with id "/utf8, Id/binary>>),
            _pipe = wisp:ok(),
            wisp:html_body(_pipe, unicode:characters_to_binary(Html))
        end
    ).

-file("src/route/media/router.gleam", 54).
-spec get_new_media(pog:connection()) -> gleam@http@response:response(wisp:body()).
get_new_media(Db) ->
    case route@media@service:get_new_media(Db) of
        {ok, X} ->
            _pipe = wisp:ok(),
            wisp:json_body(_pipe, gleam@json:to_string(shared@media:to_json(X)));

        {error, Err} ->
            _pipe@1 = wisp:not_found(),
            wisp:json_body(
                _pipe@1,
                gleam@json:to_string(
                    route@media@service:media_error_to_json(Err)
                )
            )
    end.

-file("src/route/media/router.gleam", 47).
-spec handle_get_new_media(
    gleam@http@request:request(wisp@internal:connection()),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_get_new_media(Req, Ctx) ->
    case erlang:element(2, Req) of
        get ->
            get_new_media(erlang:element(2, Ctx));

        _ ->
            wisp:method_not_allowed([get])
    end.

-file("src/route/media/router.gleam", 10).
-spec handle_media_request(
    gleam@http@request:request(wisp@internal:connection()),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_media_request(Req, Ctx) ->
    case fun gleam@http@request:path_segments/1(Req) of
        [<<"api"/utf8>>, <<"medias"/utf8>>] ->
            show_medias(Req);

        [<<"api"/utf8>>, <<"medias"/utf8>>, <<"new"/utf8>>] ->
            handle_get_new_media(Req, Ctx);

        [<<"api"/utf8>>, <<"medias"/utf8>>, Id] ->
            show_media(Req, Id);

        _ ->
            wisp:not_found()
    end.
