-module(shared@media).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/shared/media.gleam").
-export([decoder/0, to_json/1]).
-export_type([media/0]).

-type media() :: {media,
        integer(),
        binary(),
        binary(),
        boolean(),
        integer(),
        binary(),
        boolean()}.

-file("src/shared/media.gleam", 16).
-spec decoder() -> gleam@dynamic@decode:decoder(media()).
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
                                <<"is_ads"/utf8>>,
                                {decoder,
                                    fun gleam@dynamic@decode:decode_bool/1},
                                fun(Is_ads) ->
                                    gleam@dynamic@decode:field(
                                        <<"media_type"/utf8>>,
                                        {decoder,
                                            fun gleam@dynamic@decode:decode_int/1},
                                        fun(Media_type) ->
                                            gleam@dynamic@decode:field(
                                                <<"filename"/utf8>>,
                                                {decoder,
                                                    fun gleam@dynamic@decode:decode_string/1},
                                                fun(Filename) ->
                                                    gleam@dynamic@decode:field(
                                                        <<"active"/utf8>>,
                                                        {decoder,
                                                            fun gleam@dynamic@decode:decode_bool/1},
                                                        fun(Active) ->
                                                            gleam@dynamic@decode:success(
                                                                {media,
                                                                    Id,
                                                                    Create_at,
                                                                    Name,
                                                                    Is_ads,
                                                                    Media_type,
                                                                    Filename,
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

-file("src/shared/media.gleam", 35).
-spec to_json(media()) -> gleam@json:json().
to_json(Media) ->
    {media, Id, Create_at, Name, Is_ads, Media_type, Filename, Active} = Media,
    gleam@json:object(
        [{<<"id"/utf8>>, gleam@json:int(Id)},
            {<<"create_at"/utf8>>, gleam@json:string(Create_at)},
            {<<"name"/utf8>>, gleam@json:string(Name)},
            {<<"is_ads"/utf8>>, gleam@json:bool(Is_ads)},
            {<<"media_type"/utf8>>, gleam@json:int(Media_type)},
            {<<"filename"/utf8>>, gleam@json:string(Filename)},
            {<<"active"/utf8>>, gleam@json:bool(Active)}]
    ).
