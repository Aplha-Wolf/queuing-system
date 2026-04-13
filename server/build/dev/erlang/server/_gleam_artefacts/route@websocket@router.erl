-module(route@websocket@router).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/websocket/router.gleam").
-export([broadcaster_handle_message/2, handle_websocket/2]).
-export_type([broadcaster_message/1, socket_state/0, my_message/0]).

-type broadcaster_message(FBR) :: {register, gleam@erlang@process:subject(FBR)} |
    {unregister, gleam@erlang@process:subject(FBR)} |
    {broadcast, FBR}.

-type socket_state() :: {socket_state,
        gleam@erlang@process:subject(my_message())}.

-type my_message() :: {send, binary()}.

-file("src/route/websocket/router.gleam", 25).
-spec broadcaster_handle_message(
    broadcaster_message(FBS),
    list(gleam@erlang@process:subject(FBS))
) -> gleam@otp@actor:next(list(gleam@erlang@process:subject(FBS)), any()).
broadcaster_handle_message(Message, Destinations) ->
    case Message of
        {register, Subject} ->
            gleam@otp@actor:continue([Subject | Destinations]);

        {unregister, Subject@1} ->
            gleam@otp@actor:continue(
                begin
                    _pipe = Destinations,
                    gleam@list:filter(_pipe, fun(D) -> D /= Subject@1 end)
                end
            );

        {broadcast, Inner} ->
            _pipe@1 = Destinations,
            gleam@list:each(
                _pipe@1,
                fun(Dest) -> gleam@erlang@process:send(Dest, Inner) end
            ),
            gleam@otp@actor:continue(Destinations)
    end.

-file("src/route/websocket/router.gleam", 44).
-spec handle_websocket(
    gleam@http@request:request(mist@internal@http:connection()),
    gleam@erlang@process:subject(broadcaster_message(my_message()))
) -> gleam@http@response:response(mist:response_data()).
handle_websocket(Req, Broadcaster) ->
    case gleam@http@request:path_segments(Req) of
        [<<"ws"/utf8>>] ->
            mist:websocket(Req, fun(State, Message, Conn) -> case Message of
                        {text, Text} ->
                            gleam@erlang@process:send(
                                Broadcaster,
                                {broadcast, {send, Text}}
                            ),
                            mist:continue(State);

                        {binary, _} ->
                            mist:continue(State);

                        {custom, {send, Text@1}} ->
                            case mist:send_text_frame(Conn, Text@1) of
                                {ok, _} -> nil;
                                _assert_fail ->
                                    erlang:error(#{gleam_error => let_assert,
                                                message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                                file => <<?FILEPATH/utf8>>,
                                                module => <<"route/websocket/router"/utf8>>,
                                                function => <<"handle_websocket"/utf8>>,
                                                line => 73,
                                                value => _assert_fail,
                                                start => 1969,
                                                'end' => 2020,
                                                pattern_start => 1980,
                                                pattern_end => 1985})
                            end,
                            mist:continue(State);

                        closed ->
                            mist:stop();

                        shutdown ->
                            mist:stop()
                    end end, fun(_) ->
                    Subject = gleam@erlang@process:new_subject(),
                    Selector = begin
                        _pipe = gleam_erlang_ffi:new_selector(),
                        gleam@erlang@process:select_map(
                            _pipe,
                            Subject,
                            fun gleam@function:identity/1
                        )
                    end,
                    gleam@erlang@process:send(Broadcaster, {register, Subject}),
                    {{socket_state, Subject}, {some, Selector}}
                end, fun(State@1) ->
                    gleam@erlang@process:send(
                        Broadcaster,
                        {unregister, erlang:element(2, State@1)}
                    )
                end);

        _ ->
            _pipe@1 = gleam@http@response:new(404),
            gleam@http@response:set_body(
                _pipe@1,
                {bytes, gleam@bytes_tree:new()}
            )
    end.
