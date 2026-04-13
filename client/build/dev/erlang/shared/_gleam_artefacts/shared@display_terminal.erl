-module(shared@display_terminal).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/shared/display_terminal.gleam").
-export([decoder/0, to_json/1]).
-export_type([display_terminal/0]).

-type display_terminal() :: {display_terminal,
        integer(),
        binary(),
        binary(),
        binary()}.

-file("src/shared/display_terminal.gleam", 8).
-spec decoder() -> gleam@dynamic@decode:decoder(display_terminal()).
decoder() ->
    gleam@dynamic@decode:field(
        <<"id"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_int/1},
        fun(Id) ->
            gleam@dynamic@decode:field(
                <<"code"/utf8>>,
                {decoder, fun gleam@dynamic@decode:decode_string/1},
                fun(Code) ->
                    gleam@dynamic@decode:field(
                        <<"name"/utf8>>,
                        {decoder, fun gleam@dynamic@decode:decode_string/1},
                        fun(Name) ->
                            gleam@dynamic@decode:field(
                                <<"que_label"/utf8>>,
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1},
                                fun(Que_label) ->
                                    gleam@dynamic@decode:success(
                                        {display_terminal,
                                            Id,
                                            Code,
                                            Name,
                                            Que_label}
                                    )
                                end
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/shared/display_terminal.gleam", 16).
-spec to_json(display_terminal()) -> gleam@json:json().
to_json(Dt) ->
    {display_terminal, Id, Code, Name, Que_label} = Dt,
    gleam@json:object(
        [{<<"id"/utf8>>, gleam@json:int(Id)},
            {<<"code"/utf8>>, gleam@json:string(Code)},
            {<<"name"/utf8>>, gleam@json:string(Name)},
            {<<"que_label"/utf8>>, gleam@json:string(Que_label)}]
    ).
