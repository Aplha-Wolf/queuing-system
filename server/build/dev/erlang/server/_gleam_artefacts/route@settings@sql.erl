-module(route@settings@sql).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/settings/sql.gleam").
-export([get_settings/1, update_settings/18]).
-export_type([get_settings_row/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " This module contains the code to run the sql queries defined in\n"
    " `./src/route/settings/sql`.\n"
    " > 🐿️ This module was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
    "\n"
).

-type get_settings_row() :: {get_settings_row,
        integer(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary(),
        binary()}.

-file("src/route/settings/sql.gleam", 43).
?DOC(
    " Get settings (single global entry)\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_settings(pog:connection()) -> {ok, pog:returned(get_settings_row())} |
    {error, pog:query_error()}.
get_settings(Db) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) ->
                gleam@dynamic@decode:field(
                    1,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Background) ->
                        gleam@dynamic@decode:field(
                            2,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Text_primary) ->
                                gleam@dynamic@decode:field(
                                    3,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Text_secondary) ->
                                        gleam@dynamic@decode:field(
                                            4,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_string/1},
                                            fun(Card_background) ->
                                                gleam@dynamic@decode:field(
                                                    5,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_string/1},
                                                    fun(Card_border) ->
                                                        gleam@dynamic@decode:field(
                                                            6,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_string/1},
                                                            fun(Card_text) ->
                                                                gleam@dynamic@decode:field(
                                                                    7,
                                                                    {decoder,
                                                                        fun gleam@dynamic@decode:decode_string/1},
                                                                    fun(
                                                                        Button_primary
                                                                    ) ->
                                                                        gleam@dynamic@decode:field(
                                                                            8,
                                                                            {decoder,
                                                                                fun gleam@dynamic@decode:decode_string/1},
                                                                            fun(
                                                                                Button_secondary
                                                                            ) ->
                                                                                gleam@dynamic@decode:field(
                                                                                    9,
                                                                                    {decoder,
                                                                                        fun gleam@dynamic@decode:decode_string/1},
                                                                                    fun(
                                                                                        Input_background
                                                                                    ) ->
                                                                                        gleam@dynamic@decode:field(
                                                                                            10,
                                                                                            {decoder,
                                                                                                fun gleam@dynamic@decode:decode_string/1},
                                                                                            fun(
                                                                                                Input_border
                                                                                            ) ->
                                                                                                gleam@dynamic@decode:field(
                                                                                                    11,
                                                                                                    {decoder,
                                                                                                        fun gleam@dynamic@decode:decode_string/1},
                                                                                                    fun(
                                                                                                        Input_text
                                                                                                    ) ->
                                                                                                        gleam@dynamic@decode:field(
                                                                                                            12,
                                                                                                            {decoder,
                                                                                                                fun gleam@dynamic@decode:decode_string/1},
                                                                                                            fun(
                                                                                                                Header_background
                                                                                                            ) ->
                                                                                                                gleam@dynamic@decode:field(
                                                                                                                    13,
                                                                                                                    {decoder,
                                                                                                                        fun gleam@dynamic@decode:decode_string/1},
                                                                                                                    fun(
                                                                                                                        Header_text
                                                                                                                    ) ->
                                                                                                                        gleam@dynamic@decode:field(
                                                                                                                            14,
                                                                                                                            {decoder,
                                                                                                                                fun gleam@dynamic@decode:decode_string/1},
                                                                                                                            fun(
                                                                                                                                Border
                                                                                                                            ) ->
                                                                                                                                gleam@dynamic@decode:field(
                                                                                                                                    15,
                                                                                                                                    {decoder,
                                                                                                                                        fun gleam@dynamic@decode:decode_string/1},
                                                                                                                                    fun(
                                                                                                                                        Success
                                                                                                                                    ) ->
                                                                                                                                        gleam@dynamic@decode:field(
                                                                                                                                            16,
                                                                                                                                            {decoder,
                                                                                                                                                fun gleam@dynamic@decode:decode_string/1},
                                                                                                                                            fun(
                                                                                                                                                Danger
                                                                                                                                            ) ->
                                                                                                                                                gleam@dynamic@decode:field(
                                                                                                                                                    17,
                                                                                                                                                    {decoder,
                                                                                                                                                        fun gleam@dynamic@decode:decode_string/1},
                                                                                                                                                    fun(
                                                                                                                                                        Warning
                                                                                                                                                    ) ->
                                                                                                                                                        gleam@dynamic@decode:success(
                                                                                                                                                            {get_settings_row,
                                                                                                                                                                Id,
                                                                                                                                                                Background,
                                                                                                                                                                Text_primary,
                                                                                                                                                                Text_secondary,
                                                                                                                                                                Card_background,
                                                                                                                                                                Card_border,
                                                                                                                                                                Card_text,
                                                                                                                                                                Button_primary,
                                                                                                                                                                Button_secondary,
                                                                                                                                                                Input_background,
                                                                                                                                                                Input_border,
                                                                                                                                                                Input_text,
                                                                                                                                                                Header_background,
                                                                                                                                                                Header_text,
                                                                                                                                                                Border,
                                                                                                                                                                Success,
                                                                                                                                                                Danger,
                                                                                                                                                                Warning}
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
    _pipe = <<"-- Get settings (single global entry)
SELECT 
  id, background, text_primary, text_secondary,
  card_background, card_border, card_text,
  button_primary, button_secondary,
  input_background, input_border, input_text,
  header_background, header_text,
  border, success, danger, warning
FROM settings
WHERE id = 1"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:returning(_pipe@1, Decoder),
    pog:execute(_pipe@2, Db).

-file("src/route/settings/sql.gleam", 107).
?DOC(
    " Update settings\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec update_settings(
    pog:connection(),
    binary(),
    binary(),
    binary(),
    binary(),
    binary(),
    binary(),
    binary(),
    binary(),
    binary(),
    binary(),
    binary(),
    binary(),
    binary(),
    binary(),
    binary(),
    binary(),
    binary()
) -> {ok, pog:returned(nil)} | {error, pog:query_error()}.
update_settings(
    Db,
    Arg_1,
    Arg_2,
    Arg_3,
    Arg_4,
    Arg_5,
    Arg_6,
    Arg_7,
    Arg_8,
    Arg_9,
    Arg_10,
    Arg_11,
    Arg_12,
    Arg_13,
    Arg_14,
    Arg_15,
    Arg_16,
    Arg_17
) ->
    Decoder = gleam@dynamic@decode:map(
        {decoder, fun gleam@dynamic@decode:decode_dynamic/1},
        fun(_) -> nil end
    ),
    _pipe = <<"-- Update settings
UPDATE settings SET
  background = $1,
  text_primary = $2,
  text_secondary = $3,
  card_background = $4,
  card_border = $5,
  card_text = $6,
  button_primary = $7,
  button_secondary = $8,
  input_background = $9,
  input_border = $10,
  input_text = $11,
  header_background = $12,
  header_text = $13,
  border = $14,
  success = $15,
  danger = $16,
  warning = $17,
  updated_at = CURRENT_TIMESTAMP
WHERE id = 1"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:parameter(_pipe@2, pog_ffi:coerce(Arg_2)),
    _pipe@4 = pog:parameter(_pipe@3, pog_ffi:coerce(Arg_3)),
    _pipe@5 = pog:parameter(_pipe@4, pog_ffi:coerce(Arg_4)),
    _pipe@6 = pog:parameter(_pipe@5, pog_ffi:coerce(Arg_5)),
    _pipe@7 = pog:parameter(_pipe@6, pog_ffi:coerce(Arg_6)),
    _pipe@8 = pog:parameter(_pipe@7, pog_ffi:coerce(Arg_7)),
    _pipe@9 = pog:parameter(_pipe@8, pog_ffi:coerce(Arg_8)),
    _pipe@10 = pog:parameter(_pipe@9, pog_ffi:coerce(Arg_9)),
    _pipe@11 = pog:parameter(_pipe@10, pog_ffi:coerce(Arg_10)),
    _pipe@12 = pog:parameter(_pipe@11, pog_ffi:coerce(Arg_11)),
    _pipe@13 = pog:parameter(_pipe@12, pog_ffi:coerce(Arg_12)),
    _pipe@14 = pog:parameter(_pipe@13, pog_ffi:coerce(Arg_13)),
    _pipe@15 = pog:parameter(_pipe@14, pog_ffi:coerce(Arg_14)),
    _pipe@16 = pog:parameter(_pipe@15, pog_ffi:coerce(Arg_15)),
    _pipe@17 = pog:parameter(_pipe@16, pog_ffi:coerce(Arg_16)),
    _pipe@18 = pog:parameter(_pipe@17, pog_ffi:coerce(Arg_17)),
    _pipe@19 = pog:returning(_pipe@18, Decoder),
    pog:execute(_pipe@19, Db).
