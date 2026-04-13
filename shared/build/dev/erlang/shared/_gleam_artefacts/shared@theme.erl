-module(shared@theme).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/shared/theme.gleam").
-export([decoder/0, color_decoder/0, theme_with_colors_decoder/0, to_json/1, color_to_json/1, theme_with_colors_to_json/1, list_themes_decoder/0, activate_result_decoder/0]).
-export_type([theme/0, theme_color/0, theme_with_colors/0, list_themes_response/0, activate_theme_result/0]).

-type theme() :: {theme,
        integer(),
        binary(),
        binary(),
        binary(),
        boolean(),
        boolean()}.

-type theme_color() :: {theme_color, binary(), binary(), binary()}.

-type theme_with_colors() :: {theme_with_colors, theme(), list(theme_color())}.

-type list_themes_response() :: {list_themes_response, integer(), list(theme())}.

-type activate_theme_result() :: {activate_theme_result, binary()}.

-file("src/shared/theme.gleam", 24).
-spec decoder() -> gleam@dynamic@decode:decoder(theme()).
decoder() ->
    gleam@dynamic@decode:field(
        <<"id"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_int/1},
        fun(Id) ->
            gleam@dynamic@decode:field(
                <<"name"/utf8>>,
                {decoder, fun gleam@dynamic@decode:decode_string/1},
                fun(Name) ->
                    gleam@dynamic@decode:field(
                        <<"display_name"/utf8>>,
                        {decoder, fun gleam@dynamic@decode:decode_string/1},
                        fun(Display_name) ->
                            gleam@dynamic@decode:field(
                                <<"description"/utf8>>,
                                {decoder,
                                    fun gleam@dynamic@decode:decode_string/1},
                                fun(Description) ->
                                    gleam@dynamic@decode:field(
                                        <<"is_active"/utf8>>,
                                        {decoder,
                                            fun gleam@dynamic@decode:decode_bool/1},
                                        fun(Is_active) ->
                                            gleam@dynamic@decode:field(
                                                <<"is_dark"/utf8>>,
                                                {decoder,
                                                    fun gleam@dynamic@decode:decode_bool/1},
                                                fun(Is_dark) ->
                                                    gleam@dynamic@decode:success(
                                                        {theme,
                                                            Id,
                                                            Name,
                                                            Display_name,
                                                            Description,
                                                            Is_active,
                                                            Is_dark}
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

-file("src/shared/theme.gleam", 41).
-spec color_decoder() -> gleam@dynamic@decode:decoder(theme_color()).
color_decoder() ->
    gleam@dynamic@decode:field(
        <<"token"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_string/1},
        fun(Token) ->
            gleam@dynamic@decode:field(
                <<"light_value"/utf8>>,
                {decoder, fun gleam@dynamic@decode:decode_string/1},
                fun(Light_value) ->
                    gleam@dynamic@decode:field(
                        <<"dark_value"/utf8>>,
                        {decoder, fun gleam@dynamic@decode:decode_string/1},
                        fun(Dark_value) ->
                            gleam@dynamic@decode:success(
                                {theme_color, Token, Light_value, Dark_value}
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/shared/theme.gleam", 48).
-spec theme_with_colors_decoder() -> gleam@dynamic@decode:decoder(theme_with_colors()).
theme_with_colors_decoder() ->
    gleam@dynamic@decode:field(
        <<"theme"/utf8>>,
        decoder(),
        fun(Theme) ->
            gleam@dynamic@decode:field(
                <<"colors"/utf8>>,
                gleam@dynamic@decode:list(color_decoder()),
                fun(Colors) ->
                    gleam@dynamic@decode:success(
                        {theme_with_colors, Theme, Colors}
                    )
                end
            )
        end
    ).

-file("src/shared/theme.gleam", 54).
-spec to_json(theme()) -> gleam@json:json().
to_json(Theme) ->
    {theme, Id, Name, Display_name, Description, Is_active, Is_dark} = Theme,
    gleam@json:object(
        [{<<"id"/utf8>>, gleam@json:int(Id)},
            {<<"name"/utf8>>, gleam@json:string(Name)},
            {<<"display_name"/utf8>>, gleam@json:string(Display_name)},
            {<<"description"/utf8>>, gleam@json:string(Description)},
            {<<"is_active"/utf8>>, gleam@json:bool(Is_active)},
            {<<"is_dark"/utf8>>, gleam@json:bool(Is_dark)}]
    ).

-file("src/shared/theme.gleam", 67).
-spec color_to_json(theme_color()) -> gleam@json:json().
color_to_json(Color) ->
    {theme_color, Token, Light_value, Dark_value} = Color,
    gleam@json:object(
        [{<<"token"/utf8>>, gleam@json:string(Token)},
            {<<"light_value"/utf8>>, gleam@json:string(Light_value)},
            {<<"dark_value"/utf8>>, gleam@json:string(Dark_value)}]
    ).

-file("src/shared/theme.gleam", 76).
-spec theme_with_colors_to_json(theme_with_colors()) -> gleam@json:json().
theme_with_colors_to_json(Twc) ->
    {theme_with_colors, Theme, Colors} = Twc,
    gleam@json:object(
        [{<<"theme"/utf8>>, to_json(Theme)},
            {<<"colors"/utf8>>,
                gleam@json:preprocessed_array(
                    gleam@list:map(Colors, fun color_to_json/1)
                )}]
    ).

-file("src/shared/theme.gleam", 88).
-spec list_themes_decoder() -> gleam@dynamic@decode:decoder(list_themes_response()).
list_themes_decoder() ->
    gleam@dynamic@decode:field(
        <<"count"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_int/1},
        fun(Count) ->
            gleam@dynamic@decode:field(
                <<"themes"/utf8>>,
                gleam@dynamic@decode:list(decoder()),
                fun(Themes) ->
                    gleam@dynamic@decode:success(
                        {list_themes_response, Count, Themes}
                    )
                end
            )
        end
    ).

-file("src/shared/theme.gleam", 98).
-spec activate_result_decoder() -> gleam@dynamic@decode:decoder(activate_theme_result()).
activate_result_decoder() ->
    gleam@dynamic@decode:field(
        <<"message"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_string/1},
        fun(Message) ->
            gleam@dynamic@decode:success({activate_theme_result, Message})
        end
    ).
