-module(shared@terminal).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/shared/terminal.gleam").
-export([decoder/0, to_json/1, list_decoder/0]).
-export_type([terminal/0]).

-type terminal() :: {terminal,
        integer(),
        binary(),
        binary(),
        binary(),
        boolean()}.

-file("src/shared/terminal.gleam", 14).
-spec decoder() -> gleam@dynamic@decode:decoder(terminal()).
decoder() ->
    gleam@dynamic@decode:field(
        <<"id"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_int/1},
        fun(Id) ->
            gleam@dynamic@decode:field(
                <<"created_at"/utf8>>,
                {decoder, fun gleam@dynamic@decode:decode_string/1},
                fun(Created_at) ->
                    gleam@dynamic@decode:field(
                        <<"code"/utf8>>,
                        {decoder, fun gleam@dynamic@decode:decode_string/1},
                        fun(Code) ->
                            gleam@dynamic@decode:field(
                                <<"name"/utf8>>,
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1},
                                fun(Name) ->
                                    gleam@dynamic@decode:field(
                                        <<"active"/utf8>>,
                                        {decoder,
                                            fun gleam@dynamic@decode:decode_bool/1},
                                        fun(Active) ->
                                            gleam@dynamic@decode:success(
                                                {terminal,
                                                    Id,
                                                    Created_at,
                                                    Code,
                                                    Name,
                                                    Active}
                                            )
                                        end
                                    )
                                end
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/shared/terminal.gleam", 23).
-spec to_json(terminal()) -> gleam@json:json().
to_json(Terminal) ->
    {terminal, Id, Created_at, Code, Name, Active} = Terminal,
    gleam@json:object(
        [{<<"id"/utf8>>, gleam@json:int(Id)},
            {<<"created_at"/utf8>>, gleam@json:string(Created_at)},
            {<<"code"/utf8>>, gleam@json:string(Code)},
            {<<"name"/utf8>>, gleam@json:string(Name)},
            {<<"active"/utf8>>, gleam@json:bool(Active)}]
    ).

-file("src/shared/terminal.gleam", 34).
-spec list_decoder() -> gleam@dynamic@decode:decoder(list(terminal())).
list_decoder() ->
    gleam@dynamic@decode:field(
        <<"terminals"/utf8>>,
        gleam@dynamic@decode:list(decoder()),
        fun(Terminals) -> gleam@dynamic@decode:success(Terminals) end
    ).
