-module(shared@frontdesk).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/shared/frontdesk.gleam").
-export([decoder/0, to_json/1, page_decoder/0, page_to_json/1, list_response_decoder/0]).
-export_type([front_desk/0, list_response/0, page/0]).

-type front_desk() :: {front_desk,
        integer(),
        binary(),
        binary(),
        binary(),
        boolean(),
        integer(),
        integer(),
        integer(),
        integer(),
        integer(),
        integer(),
        integer(),
        integer()}.

-type list_response() :: {list_response,
        integer(),
        binary(),
        page(),
        list(front_desk())}.

-type page() :: {page, integer(), integer()}.

-file("src/shared/frontdesk.gleam", 22).
-spec decoder() -> gleam@dynamic@decode:decoder(front_desk()).
decoder() ->
    gleam@dynamic@decode:field(
        <<"id"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_int/1},
        fun(Id) ->
            gleam@dynamic@decode:field(
                <<"create_at"/utf8>>,
                {decoder, fun gleam@dynamic@decode:decode_string/1},
                fun(Create_at) ->
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
                                            gleam@dynamic@decode:field(
                                                <<"title_fontsize"/utf8>>,
                                                {decoder,
                                                    fun gleam@dynamic@decode:decode_int/1},
                                                fun(Title_fontsize) ->
                                                    gleam@dynamic@decode:field(
                                                        <<"option_fontsize"/utf8>>,
                                                        {decoder,
                                                            fun gleam@dynamic@decode:decode_int/1},
                                                        fun(Option_fontsize) ->
                                                            gleam@dynamic@decode:field(
                                                                <<"icon_height"/utf8>>,
                                                                {decoder,
                                                                    fun gleam@dynamic@decode:decode_int/1},
                                                                fun(Icon_height) ->
                                                                    gleam@dynamic@decode:field(
                                                                        <<"icon_width"/utf8>>,
                                                                        {decoder,
                                                                            fun gleam@dynamic@decode:decode_int/1},
                                                                        fun(
                                                                            Icon_width
                                                                        ) ->
                                                                            gleam@dynamic@decode:field(
                                                                                <<"priority_cols"/utf8>>,
                                                                                {decoder,
                                                                                    fun gleam@dynamic@decode:decode_int/1},
                                                                                fun(
                                                                                    Priority_cols
                                                                                ) ->
                                                                                    gleam@dynamic@decode:field(
                                                                                        <<"priority_rows"/utf8>>,
                                                                                        {decoder,
                                                                                            fun gleam@dynamic@decode:decode_int/1},
                                                                                        fun(
                                                                                            Priority_rows
                                                                                        ) ->
                                                                                            gleam@dynamic@decode:field(
                                                                                                <<"transaction_cols"/utf8>>,
                                                                                                {decoder,
                                                                                                    fun gleam@dynamic@decode:decode_int/1},
                                                                                                fun(
                                                                                                    Transaction_cols
                                                                                                ) ->
                                                                                                    gleam@dynamic@decode:field(
                                                                                                        <<"transaction_rows"/utf8>>,
                                                                                                        {decoder,
                                                                                                            fun gleam@dynamic@decode:decode_int/1},
                                                                                                        fun(
                                                                                                            Transaction_rows
                                                                                                        ) ->
                                                                                                            gleam@dynamic@decode:success(
                                                                                                                {front_desk,
                                                                                                                    Id,
                                                                                                                    Create_at,
                                                                                                                    Code,
                                                                                                                    Name,
                                                                                                                    Active,
                                                                                                                    Title_fontsize,
                                                                                                                    Option_fontsize,
                                                                                                                    Icon_height,
                                                                                                                    Icon_width,
                                                                                                                    Priority_cols,
                                                                                                                    Priority_rows,
                                                                                                                    Transaction_cols,
                                                                                                                    Transaction_rows}
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

-file("src/shared/frontdesk.gleam", 53).
-spec to_json(front_desk()) -> gleam@json:json().
to_json(Frontdesk) ->
    {front_desk,
        Id,
        Create_at,
        Code,
        Name,
        Active,
        Title_fontsize,
        Option_fontsize,
        Icon_height,
        Icon_width,
        Priority_cols,
        Priority_rows,
        Transaction_cols,
        Transaction_rows} = Frontdesk,
    gleam@json:object(
        [{<<"id"/utf8>>, gleam@json:int(Id)},
            {<<"create_at"/utf8>>, gleam@json:string(Create_at)},
            {<<"code"/utf8>>, gleam@json:string(Code)},
            {<<"name"/utf8>>, gleam@json:string(Name)},
            {<<"active"/utf8>>, gleam@json:bool(Active)},
            {<<"title_fontsize"/utf8>>, gleam@json:int(Title_fontsize)},
            {<<"option_fontsize"/utf8>>, gleam@json:int(Option_fontsize)},
            {<<"icon_height"/utf8>>, gleam@json:int(Icon_height)},
            {<<"icon_width"/utf8>>, gleam@json:int(Icon_width)},
            {<<"priority_cols"/utf8>>, gleam@json:int(Priority_cols)},
            {<<"priority_rows"/utf8>>, gleam@json:int(Priority_rows)},
            {<<"transaction_cols"/utf8>>, gleam@json:int(Transaction_cols)},
            {<<"transaction_rows"/utf8>>, gleam@json:int(Transaction_rows)}]
    ).

-file("src/shared/frontdesk.gleam", 94).
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

-file("src/shared/frontdesk.gleam", 100).
-spec page_to_json(page()) -> gleam@json:json().
page_to_json(Page) ->
    {page, Count, Total} = Page,
    gleam@json:object(
        [{<<"count"/utf8>>, gleam@json:int(Count)},
            {<<"total"/utf8>>, gleam@json:int(Total)}]
    ).

-file("src/shared/frontdesk.gleam", 105).
-spec list_response_decoder() -> gleam@dynamic@decode:decoder(list_response()).
list_response_decoder() ->
    gleam@dynamic@decode:field(
        <<"status"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_int/1},
        fun(Status) ->
            gleam@dynamic@decode:field(
                <<"message"/utf8>>,
                {decoder, fun gleam@dynamic@decode:decode_string/1},
                fun(Message) ->
                    gleam@dynamic@decode:field(
                        <<"page"/utf8>>,
                        page_decoder(),
                        fun(Page) ->
                            gleam@dynamic@decode:field(
                                <<"data"/utf8>>,
                                gleam@dynamic@decode:list(decoder()),
                                fun(Data) ->
                                    gleam@dynamic@decode:success(
                                        {list_response,
                                            Status,
                                            Message,
                                            Page,
                                            Data}
                                    )
                                end
                            )
                        end
                    )
                end
            )
        end
    ).
