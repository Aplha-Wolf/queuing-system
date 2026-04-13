-module(shared@display).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/shared/display.gleam").
-export([decoder/0, to_json/1]).
-export_type([display/0]).

-type display() :: {display,
        integer(),
        binary(),
        binary(),
        boolean(),
        binary(),
        integer(),
        integer(),
        integer(),
        integer(),
        integer(),
        integer(),
        integer(),
        integer(),
        integer()}.

-file("src/shared/display.gleam", 23).
-spec decoder() -> gleam@dynamic@decode:decoder(display()).
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
                                <<"active"/utf8>>,
                                {decoder,
                                    fun gleam@dynamic@decode:decode_bool/1},
                                fun(Active) ->
                                    gleam@dynamic@decode:field(
                                        <<"created_at"/utf8>>,
                                        {decoder,
                                            fun gleam@dynamic@decode:decode_string/1},
                                        fun(Created_at) ->
                                            gleam@dynamic@decode:field(
                                                <<"now_serving_size"/utf8>>,
                                                {decoder,
                                                    fun gleam@dynamic@decode:decode_int/1},
                                                fun(Now_serving_size) ->
                                                    gleam@dynamic@decode:field(
                                                        <<"media_width"/utf8>>,
                                                        {decoder,
                                                            fun gleam@dynamic@decode:decode_int/1},
                                                        fun(Media_width) ->
                                                            gleam@dynamic@decode:field(
                                                                <<"terminal_div_width"/utf8>>,
                                                                {decoder,
                                                                    fun gleam@dynamic@decode:decode_int/1},
                                                                fun(
                                                                    Terminal_div_width
                                                                ) ->
                                                                    gleam@dynamic@decode:field(
                                                                        <<"cols"/utf8>>,
                                                                        {decoder,
                                                                            fun gleam@dynamic@decode:decode_int/1},
                                                                        fun(
                                                                            Cols
                                                                        ) ->
                                                                            gleam@dynamic@decode:field(
                                                                                <<"rows"/utf8>>,
                                                                                {decoder,
                                                                                    fun gleam@dynamic@decode:decode_int/1},
                                                                                fun(
                                                                                    Rows
                                                                                ) ->
                                                                                    gleam@dynamic@decode:field(
                                                                                        <<"name_size"/utf8>>,
                                                                                        {decoder,
                                                                                            fun gleam@dynamic@decode:decode_int/1},
                                                                                        fun(
                                                                                            Name_size
                                                                                        ) ->
                                                                                            gleam@dynamic@decode:field(
                                                                                                <<"que_label_size"/utf8>>,
                                                                                                {decoder,
                                                                                                    fun gleam@dynamic@decode:decode_int/1},
                                                                                                fun(
                                                                                                    Que_label_size
                                                                                                ) ->
                                                                                                    gleam@dynamic@decode:field(
                                                                                                        <<"que_no_size"/utf8>>,
                                                                                                        {decoder,
                                                                                                            fun gleam@dynamic@decode:decode_int/1},
                                                                                                        fun(
                                                                                                            Que_no_size
                                                                                                        ) ->
                                                                                                            gleam@dynamic@decode:field(
                                                                                                                <<"date_time_size"/utf8>>,
                                                                                                                {decoder,
                                                                                                                    fun gleam@dynamic@decode:decode_int/1},
                                                                                                                fun(
                                                                                                                    Date_time_size
                                                                                                                ) ->
                                                                                                                    gleam@dynamic@decode:success(
                                                                                                                        {display,
                                                                                                                            Id,
                                                                                                                            Code,
                                                                                                                            Name,
                                                                                                                            Active,
                                                                                                                            Created_at,
                                                                                                                            Now_serving_size,
                                                                                                                            Media_width,
                                                                                                                            Terminal_div_width,
                                                                                                                            Cols,
                                                                                                                            Rows,
                                                                                                                            Name_size,
                                                                                                                            Que_label_size,
                                                                                                                            Que_no_size,
                                                                                                                            Date_time_size}
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
                                    )
                                end
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/shared/display.gleam", 56).
-spec to_json(display()) -> gleam@json:json().
to_json(Display) ->
    {display,
        Id,
        Code,
        Name,
        Active,
        Created_at,
        Now_serving_size,
        Media_width,
        Terminal_div_width,
        Cols,
        Rows,
        Name_size,
        Que_label_size,
        Que_no_size,
        Date_time_size} = Display,
    gleam@json:object(
        [{<<"id"/utf8>>, gleam@json:int(Id)},
            {<<"code"/utf8>>, gleam@json:string(Code)},
            {<<"name"/utf8>>, gleam@json:string(Name)},
            {<<"active"/utf8>>, gleam@json:bool(Active)},
            {<<"created_at"/utf8>>, gleam@json:string(Created_at)},
            {<<"now_serving_size"/utf8>>, gleam@json:int(Now_serving_size)},
            {<<"media_width"/utf8>>, gleam@json:int(Media_width)},
            {<<"terminal_div_width"/utf8>>, gleam@json:int(Terminal_div_width)},
            {<<"cols"/utf8>>, gleam@json:int(Cols)},
            {<<"rows"/utf8>>, gleam@json:int(Rows)},
            {<<"name_size"/utf8>>, gleam@json:int(Name_size)},
            {<<"que_label_size"/utf8>>, gleam@json:int(Que_label_size)},
            {<<"que_no_size"/utf8>>, gleam@json:int(Que_no_size)},
            {<<"date_time_size"/utf8>>, gleam@json:int(Date_time_size)}]
    ).
