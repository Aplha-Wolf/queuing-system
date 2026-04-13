-module(route@theme@sql).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/theme/sql.gleam").
-export([activate_theme/2, deactivate_all_themes/1, get_active_theme/1, get_theme_by_id/2, get_theme_colors/2, list_themes/1]).
-export_type([get_active_theme_row/0, get_theme_by_id_row/0, get_theme_colors_row/0, list_themes_row/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " This module contains the code to run the sql queries defined in\n"
    " `./src/route/theme/sql`.\n"
    " > 🐿️ This module was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
    "\n"
).

-type get_active_theme_row() :: {get_active_theme_row,
        integer(),
        binary(),
        binary(),
        binary(),
        boolean(),
        boolean(),
        binary()}.

-type get_theme_by_id_row() :: {get_theme_by_id_row,
        integer(),
        binary(),
        binary(),
        binary(),
        boolean(),
        boolean(),
        binary()}.

-type get_theme_colors_row() :: {get_theme_colors_row,
        binary(),
        binary(),
        binary()}.

-type list_themes_row() :: {list_themes_row,
        integer(),
        binary(),
        binary(),
        binary(),
        boolean(),
        boolean(),
        binary()}.

-file("src/route/theme/sql.gleam", 15).
?DOC(
    " Activate theme by ID\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec activate_theme(pog:connection(), integer()) -> {ok, pog:returned(nil)} |
    {error, pog:query_error()}.
activate_theme(Db, Arg_1) ->
    Decoder = gleam@dynamic@decode:map(
        {decoder, fun gleam@dynamic@decode:decode_dynamic/1},
        fun(_) -> nil end
    ),
    _pipe = <<"-- Activate theme by ID
UPDATE theme
SET is_active = true, updated_at = CURRENT_TIMESTAMP
WHERE id = $1
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).

-file("src/route/theme/sql.gleam", 37).
?DOC(
    " Deactivate all themes\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec deactivate_all_themes(pog:connection()) -> {ok, pog:returned(nil)} |
    {error, pog:query_error()}.
deactivate_all_themes(Db) ->
    Decoder = gleam@dynamic@decode:map(
        {decoder, fun gleam@dynamic@decode:decode_dynamic/1},
        fun(_) -> nil end
    ),
    _pipe = <<"-- Deactivate all themes
UPDATE theme SET is_active = false
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:returning(_pipe@1, Decoder),
    pog:execute(_pipe@2, Db).

-file("src/route/theme/sql.gleam", 73).
?DOC(
    " Get active theme\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_active_theme(pog:connection()) -> {ok,
        pog:returned(get_active_theme_row())} |
    {error, pog:query_error()}.
get_active_theme(Db) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) ->
                gleam@dynamic@decode:field(
                    1,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Name) ->
                        gleam@dynamic@decode:field(
                            2,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Display_name) ->
                                gleam@dynamic@decode:field(
                                    3,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Description) ->
                                        gleam@dynamic@decode:field(
                                            4,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_bool/1},
                                            fun(Is_active) ->
                                                gleam@dynamic@decode:field(
                                                    5,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_bool/1},
                                                    fun(Is_dark) ->
                                                        gleam@dynamic@decode:field(
                                                            6,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_string/1},
                                                            fun(Created_at) ->
                                                                gleam@dynamic@decode:success(
                                                                    {get_active_theme_row,
                                                                        Id,
                                                                        Name,
                                                                        Display_name,
                                                                        Description,
                                                                        Is_active,
                                                                        Is_dark,
                                                                        Created_at}
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
    end,
    _pipe = <<"-- Get active theme
SELECT
  id, name, display_name, description, is_active, is_dark, CAST(created_at AS TEXT) AS created_at
FROM theme
WHERE is_active = true
LIMIT 1
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:returning(_pipe@1, Decoder),
    pog:execute(_pipe@2, Db).

-file("src/route/theme/sql.gleam", 130).
?DOC(
    " Get theme by ID\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_theme_by_id(pog:connection(), integer()) -> {ok,
        pog:returned(get_theme_by_id_row())} |
    {error, pog:query_error()}.
get_theme_by_id(Db, Arg_1) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) ->
                gleam@dynamic@decode:field(
                    1,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Name) ->
                        gleam@dynamic@decode:field(
                            2,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Display_name) ->
                                gleam@dynamic@decode:field(
                                    3,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Description) ->
                                        gleam@dynamic@decode:field(
                                            4,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_bool/1},
                                            fun(Is_active) ->
                                                gleam@dynamic@decode:field(
                                                    5,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_bool/1},
                                                    fun(Is_dark) ->
                                                        gleam@dynamic@decode:field(
                                                            6,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_string/1},
                                                            fun(Created_at) ->
                                                                gleam@dynamic@decode:success(
                                                                    {get_theme_by_id_row,
                                                                        Id,
                                                                        Name,
                                                                        Display_name,
                                                                        Description,
                                                                        Is_active,
                                                                        Is_dark,
                                                                        Created_at}
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
    end,
    _pipe = <<"-- Get theme by ID
SELECT
  id, name, display_name, description, is_active, is_dark, CAST(created_at AS TEXT) AS created_at
FROM theme
WHERE id = $1
LIMIT 1
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).

-file("src/route/theme/sql.gleam", 181).
?DOC(
    " Get theme colors by theme_id\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_theme_colors(pog:connection(), integer()) -> {ok,
        pog:returned(get_theme_colors_row())} |
    {error, pog:query_error()}.
get_theme_colors(Db, Arg_1) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_string/1},
            fun(Token) ->
                gleam@dynamic@decode:field(
                    1,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Light_value) ->
                        gleam@dynamic@decode:field(
                            2,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Dark_value) ->
                                gleam@dynamic@decode:success(
                                    {get_theme_colors_row,
                                        Token,
                                        Light_value,
                                        Dark_value}
                                )
                            end
                        )
                    end
                )
            end
        )
    end,
    _pipe = <<"-- Get theme colors by theme_id
SELECT token, light_value, dark_value
FROM theme_color
WHERE theme_id = $1
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).

-file("src/route/theme/sql.gleam", 226).
?DOC(
    " List all themes\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec list_themes(pog:connection()) -> {ok, pog:returned(list_themes_row())} |
    {error, pog:query_error()}.
list_themes(Db) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) ->
                gleam@dynamic@decode:field(
                    1,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Name) ->
                        gleam@dynamic@decode:field(
                            2,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Display_name) ->
                                gleam@dynamic@decode:field(
                                    3,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Description) ->
                                        gleam@dynamic@decode:field(
                                            4,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_bool/1},
                                            fun(Is_active) ->
                                                gleam@dynamic@decode:field(
                                                    5,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_bool/1},
                                                    fun(Is_dark) ->
                                                        gleam@dynamic@decode:field(
                                                            6,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_string/1},
                                                            fun(Created_at) ->
                                                                gleam@dynamic@decode:success(
                                                                    {list_themes_row,
                                                                        Id,
                                                                        Name,
                                                                        Display_name,
                                                                        Description,
                                                                        Is_active,
                                                                        Is_dark,
                                                                        Created_at}
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
    end,
    _pipe = <<"-- List all themes
SELECT
  id, name, display_name, description, is_active, is_dark, CAST(created_at AS TEXT) AS created_at
FROM theme
ORDER BY id ASC
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:returning(_pipe@1, Decoder),
    pog:execute(_pipe@2, Db).
