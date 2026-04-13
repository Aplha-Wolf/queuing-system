-module(shared@quetype).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/shared/quetype.gleam").
-export([decoder/0, to_json/1, page_decoder/0, page_to_json/1, list_response_decoder/0]).
-export_type([que_type/0, list_response/0, page/0]).

-type que_type() :: {que_type,
        integer(),
        binary(),
        binary(),
        binary(),
        binary(),
        boolean()}.

-type list_response() :: {list_response,
        integer(),
        binary(),
        page(),
        list(que_type())}.

-type page() :: {page, integer(), integer()}.

-file("src/shared/quetype.gleam", 15).
-spec decoder() -> gleam@dynamic@decode:decoder(que_type()).
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
                        <<"name"/utf8>>,
                        {decoder, fun gleam@dynamic@decode:decode_string/1},
                        fun(Name) ->
                            gleam@dynamic@decode:field(
                                <<"icon"/utf8>>,
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1},
                                fun(Icon) ->
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
                                                        {que_type,
                                                            Id,
                                                            Create_at,
                                                            Name,
                                                            Icon,
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
    ).

-file("src/shared/quetype.gleam", 25).
-spec to_json(que_type()) -> gleam@json:json().
to_json(Quetype) ->
    {que_type, Id, Create_at, Name, Icon, Prefix, Active} = Quetype,
    gleam@json:object(
        [{<<"id"/utf8>>, gleam@json:int(Id)},
            {<<"create_at"/utf8>>, gleam@json:string(Create_at)},
            {<<"name"/utf8>>, gleam@json:string(Name)},
            {<<"icon"/utf8>>, gleam@json:string(Icon)},
            {<<"prefix"/utf8>>, gleam@json:string(Prefix)},
            {<<"active"/utf8>>, gleam@json:bool(Active)}]
    ).

-file("src/shared/quetype.gleam", 45).
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

-file("src/shared/quetype.gleam", 51).
-spec page_to_json(page()) -> gleam@json:json().
page_to_json(Page) ->
    {page, Count, Total} = Page,
    gleam@json:object(
        [{<<"count"/utf8>>, gleam@json:int(Count)},
            {<<"total"/utf8>>, gleam@json:int(Total)}]
    ).

-file("src/shared/quetype.gleam", 56).
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
