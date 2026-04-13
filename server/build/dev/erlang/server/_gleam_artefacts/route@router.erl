-module(route@router).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/router.gleam").
-export([handle_request/2]).

-file("src/route/router.gleam", 69).
-spec home_page(gleam@http@request:request(wisp@internal:connection())) -> gleam@http@response:response(wisp:body()).
home_page(Req) ->
    wisp:require_method(
        Req,
        get,
        fun() ->
            Html = gleam_stdlib:identity(<<"Queuing System API!"/utf8>>),
            _pipe = wisp:ok(),
            wisp:html_body(_pipe, unicode:characters_to_binary(Html))
        end
    ).

-file("src/route/router.gleam", 16).
-spec handle_request(
    gleam@http@request:request(wisp@internal:connection()),
    route@web:context()
) -> gleam@http@response:response(wisp:body()).
handle_request(Req, Ctx) ->
    route@web:middleware(
        Req,
        fun(Req@1) -> case fun gleam@http@request:path_segments/1(Req@1) of
                [] ->
                    home_page(Req@1);

                [<<"api"/utf8>>, <<"medias"/utf8>> | _] ->
                    route@media@router:handle_media_request(Req@1, Ctx);

                [<<"api"/utf8>>, <<"terminals"/utf8>> | _] ->
                    route@terminal@router:handle_terminal_request(Req@1, Ctx);

                [<<"api"/utf8>>, <<"queues"/utf8>>, <<"terminals"/utf8>> | _] ->
                    route@que@router:handle_queue_request(Req@1, Ctx);

                [<<"api"/utf8>>, <<"display-terminals"/utf8>> | Path_segment] ->
                    route@display_terminal@router:handle_display_terminal_request(
                        erlang:element(2, Req@1),
                        Path_segment,
                        wisp:get_query(Req@1),
                        Ctx
                    );

                [<<"api"/utf8>>, <<"displays"/utf8>> | Path_segment@1] ->
                    route@display@router:handle_display_request(
                        erlang:element(2, Req@1),
                        Path_segment@1,
                        wisp:get_query(Req@1),
                        Ctx
                    );

                [<<"api"/utf8>>, <<"frontdesk"/utf8>> | Path_segment@2] ->
                    route@frontdesk@router:handle_frontdesk_request(
                        erlang:element(2, Req@1),
                        Path_segment@2,
                        wisp:get_query(Req@1),
                        Ctx
                    );

                [<<"api"/utf8>>, <<"priority"/utf8>> | Path_segment@3] ->
                    route@priority@router:handle_priority_request(
                        erlang:element(2, Req@1),
                        Path_segment@3,
                        wisp:get_query(Req@1),
                        Ctx
                    );

                [<<"api"/utf8>>, <<"quetype"/utf8>> | Path_segment@4] ->
                    route@quetype@router:handle_priority_request(
                        erlang:element(2, Req@1),
                        Path_segment@4,
                        wisp:get_query(Req@1),
                        Ctx
                    );

                [<<"api"/utf8>>, <<"themes"/utf8>> | Path_segment@5] ->
                    route@theme@router:handle_theme_request(
                        erlang:element(2, Req@1),
                        Path_segment@5,
                        Ctx
                    );

                [<<"api"/utf8>>, <<"settings"/utf8>> | Path_segment@6] ->
                    route@settings@router:handle_settings_request(
                        erlang:element(2, Req@1),
                        Path_segment@6,
                        Ctx
                    );

                _ ->
                    wisp:not_found()
            end end
    ).
