-module(route@display@sql).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/display/sql.gleam").
-export([get_display_by_code/2, get_display_by_id/2]).
-export_type([get_display_by_code_row/0, get_display_by_id_row/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " This module contains the code to run the sql queries defined in\n"
    " `./src/route/display/sql`.\n"
    " > 🐿️ This module was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
    "\n"
).

-type get_display_by_code_row() :: {get_display_by_code_row,
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
        integer(),
        integer()}.

-type get_display_by_id_row() :: {get_display_by_id_row,
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
        integer(),
        integer()}.

-file("src/route/display/sql.gleam", 41).
?DOC(
    " Runs the `get_display_by_code` query\n"
    " defined in `./src/route/display/sql/get_display_by_code.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_display_by_code(pog:connection(), binary()) -> {ok,
        pog:returned(get_display_by_code_row())} |
    {error, pog:query_error()}.
get_display_by_code(Db, Arg_1) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) ->
                gleam@dynamic@decode:field(
                    1,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Code) ->
                        gleam@dynamic@decode:field(
                            2,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Create_at) ->
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
                                                    fun(Now_serving_size) ->
                                                        gleam@dynamic@decode:field(
                                                            6,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_int/1},
                                                            fun(Media_width) ->
                                                                gleam@dynamic@decode:field(
                                                                    7,
                                                                    {decoder,
                                                                        fun gleam@dynamic@decode:decode_int/1},
                                                                    fun(
                                                                        Terminal_div_width
                                                                    ) ->
                                                                        gleam@dynamic@decode:field(
                                                                            8,
                                                                            {decoder,
                                                                                fun gleam@dynamic@decode:decode_int/1},
                                                                            fun(
                                                                                Cols
                                                                            ) ->
                                                                                gleam@dynamic@decode:field(
                                                                                    9,
                                                                                    {decoder,
                                                                                        fun gleam@dynamic@decode:decode_int/1},
                                                                                    fun(
                                                                                        Rows
                                                                                    ) ->
                                                                                        gleam@dynamic@decode:field(
                                                                                            10,
                                                                                            {decoder,
                                                                                                fun gleam@dynamic@decode:decode_int/1},
                                                                                            fun(
                                                                                                Name_size
                                                                                            ) ->
                                                                                                gleam@dynamic@decode:field(
                                                                                                    11,
                                                                                                    {decoder,
                                                                                                        fun gleam@dynamic@decode:decode_int/1},
                                                                                                    fun(
                                                                                                        Que_label_size
                                                                                                    ) ->
                                                                                                        gleam@dynamic@decode:field(
                                                                                                            12,
                                                                                                            {decoder,
                                                                                                                fun gleam@dynamic@decode:decode_int/1},
                                                                                                            fun(
                                                                                                                Que_no_size
                                                                                                            ) ->
                                                                                                                gleam@dynamic@decode:field(
                                                                                                                    13,
                                                                                                                    {decoder,
                                                                                                                        fun gleam@dynamic@decode:decode_int/1},
                                                                                                                    fun(
                                                                                                                        Date_time_size
                                                                                                                    ) ->
                                                                                                                        gleam@dynamic@decode:success(
                                                                                                                            {get_display_by_code_row,
                                                                                                                                Id,
                                                                                                                                Code,
                                                                                                                                Create_at,
                                                                                                                                Name,
                                                                                                                                Active,
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
        )
    end,
    _pipe = <<"SELECT
    id, code, CAST(create_at AS TEXT) AS create_at, name, active, 
    now_serving_size, media_width, terminal_div_width, cols, rows, 
    name_size, que_label_size, que_no_size, date_time_size
FROM
    display
WHERE
    code = $1"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).

-file("src/route/display/sql.gleam", 123).
?DOC(
    " Runs the `get_display_by_id` query\n"
    " defined in `./src/route/display/sql/get_display_by_id.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_display_by_id(pog:connection(), integer()) -> {ok,
        pog:returned(get_display_by_id_row())} |
    {error, pog:query_error()}.
get_display_by_id(Db, Arg_1) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) ->
                gleam@dynamic@decode:field(
                    1,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Code) ->
                        gleam@dynamic@decode:field(
                            2,
                            {decoder, fun gleam@dynamic@decode:decode_string/1},
                            fun(Create_at) ->
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
                                                    fun(Now_serving_size) ->
                                                        gleam@dynamic@decode:field(
                                                            6,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_int/1},
                                                            fun(Media_width) ->
                                                                gleam@dynamic@decode:field(
                                                                    7,
                                                                    {decoder,
                                                                        fun gleam@dynamic@decode:decode_int/1},
                                                                    fun(
                                                                        Terminal_div_width
                                                                    ) ->
                                                                        gleam@dynamic@decode:field(
                                                                            8,
                                                                            {decoder,
                                                                                fun gleam@dynamic@decode:decode_int/1},
                                                                            fun(
                                                                                Cols
                                                                            ) ->
                                                                                gleam@dynamic@decode:field(
                                                                                    9,
                                                                                    {decoder,
                                                                                        fun gleam@dynamic@decode:decode_int/1},
                                                                                    fun(
                                                                                        Rows
                                                                                    ) ->
                                                                                        gleam@dynamic@decode:field(
                                                                                            10,
                                                                                            {decoder,
                                                                                                fun gleam@dynamic@decode:decode_int/1},
                                                                                            fun(
                                                                                                Name_size
                                                                                            ) ->
                                                                                                gleam@dynamic@decode:field(
                                                                                                    11,
                                                                                                    {decoder,
                                                                                                        fun gleam@dynamic@decode:decode_int/1},
                                                                                                    fun(
                                                                                                        Que_label_size
                                                                                                    ) ->
                                                                                                        gleam@dynamic@decode:field(
                                                                                                            12,
                                                                                                            {decoder,
                                                                                                                fun gleam@dynamic@decode:decode_int/1},
                                                                                                            fun(
                                                                                                                Que_no_size
                                                                                                            ) ->
                                                                                                                gleam@dynamic@decode:field(
                                                                                                                    13,
                                                                                                                    {decoder,
                                                                                                                        fun gleam@dynamic@decode:decode_int/1},
                                                                                                                    fun(
                                                                                                                        Date_time_size
                                                                                                                    ) ->
                                                                                                                        gleam@dynamic@decode:success(
                                                                                                                            {get_display_by_id_row,
                                                                                                                                Id,
                                                                                                                                Code,
                                                                                                                                Create_at,
                                                                                                                                Name,
                                                                                                                                Active,
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
        )
    end,
    _pipe = <<"SELECT
    id, code, CAST(create_at AS TEXT) AS create_at, name, active, 
    now_serving_size, media_width, terminal_div_width, cols, rows, 
    name_size, que_label_size, que_no_size, date_time_size
FROM
    display
WHERE
    id = $1"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).
