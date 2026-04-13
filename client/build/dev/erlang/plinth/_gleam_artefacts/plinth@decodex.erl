-module(plinth@decodex).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/plinth/decodex.gleam").
-export([float_or_int/0]).

-file("src/plinth/decodex.gleam", 4).
-spec float_or_int() -> gleam@dynamic@decode:decoder(float()).
float_or_int() ->
    gleam@dynamic@decode:one_of(
        {decoder, fun gleam@dynamic@decode:decode_float/1},
        [gleam@dynamic@decode:map(
                {decoder, fun gleam@dynamic@decode:decode_int/1},
                fun erlang:float/1
            )]
    ).
