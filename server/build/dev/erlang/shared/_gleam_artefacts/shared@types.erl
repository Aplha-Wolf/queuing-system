-module(shared@types).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/shared/types.gleam").
-export([terminal_decoder/0, terminal_to_json/1, priority_decoder/0, priority_to_json/1, queue_decoder/0, queue_to_json/1, display_decoder/0, display_to_json/1, terminal_info_decoder/0, terminal_info_to_json/1, page_decoder/0, page_to_json/1]).
-export_type([terminal/0, priority/0, queue/0, display/0, terminal_info/0, page/0]).

-type terminal() :: {terminal,
        integer(),
        binary(),
        binary(),
        binary(),
        boolean()}.

-type priority() :: {priority,
        integer(),
        binary(),
        binary(),
        binary(),
        integer(),
        binary(),
        boolean()}.

-type queue() :: {queue, integer(), binary()}.

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

-type terminal_info() :: {terminal_info, terminal(), queue(), list(queue())}.

-type page() :: {page, integer(), integer()}.

-file("src/shared/types.gleam", 14).
-spec terminal_decoder() -> gleam@dynamic@decode:decoder(terminal()).
terminal_decoder() ->
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

-file("src/shared/types.gleam", 23).
-spec terminal_to_json(terminal()) -> gleam@json:json().
terminal_to_json(Terminal) ->
    {terminal, Id, Created_at, Code, Name, Active} = Terminal,
    gleam@json:object(
        [{<<"id"/utf8>>, gleam@json:int(Id)},
            {<<"created_at"/utf8>>, gleam@json:string(Created_at)},
            {<<"code"/utf8>>, gleam@json:string(Code)},
            {<<"name"/utf8>>, gleam@json:string(Name)},
            {<<"active"/utf8>>, gleam@json:bool(Active)}]
    ).

-file("src/shared/types.gleam", 46).
-spec priority_decoder() -> gleam@dynamic@decode:decoder(priority()).
priority_decoder() ->
    gleam@dynamic@decode:field(
        <<"id"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_int/1},
        fun(Id) ->
            gleam@dynamic@decode:field(
                <<"create_at"/utf8>>,
                {decoder, fun gleam@dynamic@decode:decode_string/1},
                fun(Create_at) ->
                    gleam@dynamic@decode:field(
                        <<"name"/utf8>>,
                        {decoder, fun gleam@dynamic@decode:decode_string/1},
                        fun(Name) ->
                            gleam@dynamic@decode:field(
                                <<"icon"/utf8>>,
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1},
                                fun(Icon) ->
                                    gleam@dynamic@decode:field(
                                        <<"level"/utf8>>,
                                        {decoder,
                                            fun gleam@dynamic@decode:decode_int/1},
                                        fun(Level) ->
                                            gleam@dynamic@decode:field(
                                                <<"prefix"/utf8>>,
                                                {decoder,
                                                    fun gleam@dynamic@decode:decode_string/1},
                                                fun(Prefix) ->
                                                    gleam@dynamic@decode:field(
                                                        <<"active"/utf8>>,
                                                        {decoder,
                                                            fun gleam@dynamic@decode:decode_bool/1},
                                                        fun(Active) ->
                                                            gleam@dynamic@decode:success(
                                                                {priority,
                                                                    Id,
                                                                    Create_at,
                                                                    Name,
                                                                    Icon,
                                                                    Level,
                                                                    Prefix,
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
                    )
                end
            )
        end
    ).

-file("src/shared/types.gleam", 65).
-spec priority_to_json(priority()) -> gleam@json:json().
priority_to_json(Priority) ->
    {priority, Id, Create_at, Name, Icon, Level, Prefix, Active} = Priority,
    gleam@json:object(
        [{<<"id"/utf8>>, gleam@json:int(Id)},
            {<<"create_at"/utf8>>, gleam@json:string(Create_at)},
            {<<"name"/utf8>>, gleam@json:string(Name)},
            {<<"icon"/utf8>>, gleam@json:string(Icon)},
            {<<"level"/utf8>>, gleam@json:int(Level)},
            {<<"prefix"/utf8>>, gleam@json:string(Prefix)},
            {<<"active"/utf8>>, gleam@json:bool(Active)}]
    ).

-file("src/shared/types.gleam", 83).
-spec queue_decoder() -> gleam@dynamic@decode:decoder(queue()).
queue_decoder() ->
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

-file("src/shared/types.gleam", 89).
-spec queue_to_json(queue()) -> gleam@json:json().
queue_to_json(Queue) ->
    {queue, Id, Que_label} = Queue,
    gleam@json:object(
        [{<<"id"/utf8>>, gleam@json:int(Id)},
            {<<"que_label"/utf8>>, gleam@json:string(Que_label)}]
    ).

-file("src/shared/types.gleam", 113).
-spec display_decoder() -> gleam@dynamic@decode:decoder(display()).
display_decoder() ->
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

-file("src/shared/types.gleam", 146).
-spec display_to_json(display()) -> gleam@json:json().
display_to_json(Display) ->
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

-file("src/shared/types.gleam", 185).
-spec terminal_info_decoder() -> gleam@dynamic@decode:decoder(terminal_info()).
terminal_info_decoder() ->
    gleam@dynamic@decode:field(
        <<"terminal"/utf8>>,
        terminal_decoder(),
        fun(Terminal) ->
            gleam@dynamic@decode:field(
                <<"current"/utf8>>,
                queue_decoder(),
                fun(Current) ->
                    gleam@dynamic@decode:field(
                        <<"queues"/utf8>>,
                        gleam@dynamic@decode:list(queue_decoder()),
                        fun(Queues) ->
                            gleam@dynamic@decode:success(
                                {terminal_info, Terminal, Current, Queues}
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/shared/types.gleam", 192).
-spec terminal_info_to_json(terminal_info()) -> gleam@json:json().
terminal_info_to_json(Info) ->
    {terminal_info, Terminal, Current, Queues} = Info,
    gleam@json:object(
        [{<<"terminal"/utf8>>, terminal_to_json(Terminal)},
            {<<"current"/utf8>>, queue_to_json(Current)},
            {<<"queues"/utf8>>, gleam@json:array(Queues, fun queue_to_json/1)}]
    ).

-file("src/shared/types.gleam", 205).
-spec page_decoder() -> gleam@dynamic@decode:decoder(page()).
page_decoder() ->
    gleam@dynamic@decode:field(
        <<"count"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_int/1},
        fun(Count) ->
            gleam@dynamic@decode:field(
                <<"total"/utf8>>,
                {decoder, fun gleam@dynamic@decode:decode_int/1},
                fun(Total) ->
                    gleam@dynamic@decode:success({page, Count, Total})
                end
            )
        end
    ).

-file("src/shared/types.gleam", 211).
-spec page_to_json(page()) -> gleam@json:json().
page_to_json(Page) ->
    {page, Count, Total} = Page,
    gleam@json:object(
        [{<<"count"/utf8>>, gleam@json:int(Count)},
            {<<"total"/utf8>>, gleam@json:int(Total)}]
    ).
