-module(shared@queue).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/shared/queue.gleam").
-export([decoder/0, to_json/1, empty/0]).
-export_type([queue/0]).

-type queue() :: {queue, integer(), binary()}.

-file("src/shared/queue.gleam", 8).
-spec decoder() -> gleam@dynamic@decode:decoder(queue()).
decoder() ->
    gleam@dynamic@decode:field(
        <<"id"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_int/1},
        fun(Id) ->
            gleam@dynamic@decode:field(
                <<"que_label"/utf8>>,
                {decoder, fun gleam@dynamic@decode:decode_string/1},
                fun(Que_label) ->
                    gleam@dynamic@decode:success({queue, Id, Que_label})
                end
            )
        end
    ).

-file("src/shared/queue.gleam", 14).
-spec to_json(queue()) -> gleam@json:json().
to_json(Queue) ->
    {queue, Id, Que_label} = Queue,
    gleam@json:object(
        [{<<"id"/utf8>>, gleam@json:int(Id)},
            {<<"que_label"/utf8>>, gleam@json:string(Que_label)}]
    ).

-file("src/shared/queue.gleam", 19).
-spec empty() -> queue().
empty() ->
    {queue, 0, <<""/utf8>>}.
