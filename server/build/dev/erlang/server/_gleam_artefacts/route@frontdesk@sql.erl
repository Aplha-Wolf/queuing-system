-module(route@frontdesk@sql).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/frontdesk/sql.gleam").
-export([get_frontdesk_by_code/2, list_all_frontdesk/2]).
-export_type([get_frontdesk_by_code_row/0, list_all_frontdesk_row/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " This module contains the code to run the sql queries defined in\n"
    " `./src/route/frontdesk/sql`.\n"
    " > 🐿️ This module was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
    "\n"
).

-type get_frontdesk_by_code_row() :: {get_frontdesk_by_code_row,
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

-type list_all_frontdesk_row() :: {list_all_frontdesk_row,
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

-file("src/route/frontdesk/sql.gleam", 40).
?DOC(
    " Runs the `get_frontdesk_by_code` query\n"
    " defined in `./src/route/frontdesk/sql/get_frontdesk_by_code.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_frontdesk_by_code(pog:connection(), binary()) -> {ok,
        pog:returned(get_frontdesk_by_code_row())} |
    {error, pog:query_error()}.
get_frontdesk_by_code(Db, Arg_1) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) ->
                gleam@dynamic@decode:field(
                    1,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Create_at) ->
                        gleam@dynamic@decode:field(
                            2,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Code) ->
                                gleam@dynamic@decode:field(
                                    3,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Name) ->
                                        gleam@dynamic@decode:field(
                                            4,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_bool/1},
                                            fun(Active) ->
                                                gleam@dynamic@decode:field(
                                                    5,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_int/1},
                                                    fun(Title_fontsize) ->
                                                        gleam@dynamic@decode:field(
                                                            6,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_int/1},
                                                            fun(Option_fontsize) ->
                                                                gleam@dynamic@decode:field(
                                                                    7,
                                                                    {decoder,
                                                                        fun gleam@dynamic@decode:decode_int/1},
                                                                    fun(
                                                                        Icon_height
                                                                    ) ->
                                                                        gleam@dynamic@decode:field(
                                                                            8,
                                                                            {decoder,
                                                                                fun gleam@dynamic@decode:decode_int/1},
                                                                            fun(
                                                                                Icon_width
                                                                            ) ->
                                                                                gleam@dynamic@decode:field(
                                                                                    9,
                                                                                    {decoder,
                                                                                        fun gleam@dynamic@decode:decode_int/1},
                                                                                    fun(
                                                                                        Priority_cols
                                                                                    ) ->
                                                                                        gleam@dynamic@decode:field(
                                                                                            10,
                                                                                            {decoder,
                                                                                                fun gleam@dynamic@decode:decode_int/1},
                                                                                            fun(
                                                                                                Priority_rows
                                                                                            ) ->
                                                                                                gleam@dynamic@decode:field(
                                                                                                    11,
                                                                                                    {decoder,
                                                                                                        fun gleam@dynamic@decode:decode_int/1},
                                                                                                    fun(
                                                                                                        Transaction_cols
                                                                                                    ) ->
                                                                                                        gleam@dynamic@decode:field(
                                                                                                            12,
                                                                                                            {decoder,
                                                                                                                fun gleam@dynamic@decode:decode_int/1},
                                                                                                            fun(
                                                                                                                Transaction_rows
                                                                                                            ) ->
                                                                                                                gleam@dynamic@decode:success(
                                                                                                                    {get_frontdesk_by_code_row,
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
        )
    end,
    _pipe = <<"SELECT
    id, CAST(create_at AS TEXT) AS create_at, code, name, active,
    title_fontsize, option_fontsize, icon_height, icon_width,
    priority_cols, priority_rows, transaction_cols, transaction_rows
FROM
    frontdesk
WHERE
    code LIKE $1
ORDER BY
    create_at DESC
LIMIT 1;
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).

-file("src/route/frontdesk/sql.gleam", 123).
?DOC(
    " Runs the `list_all_frontdesk` query\n"
    " defined in `./src/route/frontdesk/sql/list_all_frontdesk.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec list_all_frontdesk(pog:connection(), integer()) -> {ok,
        pog:returned(list_all_frontdesk_row())} |
    {error, pog:query_error()}.
list_all_frontdesk(Db, Arg_1) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) ->
                gleam@dynamic@decode:field(
                    1,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Create_at) ->
                        gleam@dynamic@decode:field(
                            2,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Code) ->
                                gleam@dynamic@decode:field(
                                    3,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Name) ->
                                        gleam@dynamic@decode:field(
                                            4,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_bool/1},
                                            fun(Active) ->
                                                gleam@dynamic@decode:field(
                                                    5,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_int/1},
                                                    fun(Title_fontsize) ->
                                                        gleam@dynamic@decode:field(
                                                            6,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_int/1},
                                                            fun(Option_fontsize) ->
                                                                gleam@dynamic@decode:field(
                                                                    7,
                                                                    {decoder,
                                                                        fun gleam@dynamic@decode:decode_int/1},
                                                                    fun(
                                                                        Icon_height
                                                                    ) ->
                                                                        gleam@dynamic@decode:field(
                                                                            8,
                                                                            {decoder,
                                                                                fun gleam@dynamic@decode:decode_int/1},
                                                                            fun(
                                                                                Icon_width
                                                                            ) ->
                                                                                gleam@dynamic@decode:field(
                                                                                    9,
                                                                                    {decoder,
                                                                                        fun gleam@dynamic@decode:decode_int/1},
                                                                                    fun(
                                                                                        Priority_cols
                                                                                    ) ->
                                                                                        gleam@dynamic@decode:field(
                                                                                            10,
                                                                                            {decoder,
                                                                                                fun gleam@dynamic@decode:decode_int/1},
                                                                                            fun(
                                                                                                Priority_rows
                                                                                            ) ->
                                                                                                gleam@dynamic@decode:field(
                                                                                                    11,
                                                                                                    {decoder,
                                                                                                        fun gleam@dynamic@decode:decode_int/1},
                                                                                                    fun(
                                                                                                        Transaction_cols
                                                                                                    ) ->
                                                                                                        gleam@dynamic@decode:field(
                                                                                                            12,
                                                                                                            {decoder,
                                                                                                                fun gleam@dynamic@decode:decode_int/1},
                                                                                                            fun(
                                                                                                                Transaction_rows
                                                                                                            ) ->
                                                                                                                gleam@dynamic@decode:success(
                                                                                                                    {list_all_frontdesk_row,
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
        )
    end,
    _pipe = <<"SELECT
    id, CAST(create_at AS TEXT) AS create_at, code, name, active, title_fontsize, option_fontsize,
    icon_height, icon_width, priority_cols, priority_rows, transaction_cols,
    transaction_rows
FROM frontdesk
LIMIT $1
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).
