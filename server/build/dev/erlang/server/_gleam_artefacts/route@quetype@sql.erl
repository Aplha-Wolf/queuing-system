-module(route@quetype@sql).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/quetype/sql.gleam").
-export([add_quetype/5, get_no_of_active_quetype/1, get_quetype_with_limit_offset/3]).
-export_type([add_quetype_row/0, get_no_of_active_quetype_row/0, get_quetype_with_limit_offset_row/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " This module contains the code to run the sql queries defined in\n"
    " `./src/route/quetype/sql`.\n"
    " > 🐿️ This module was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
    "\n"
).

-type add_quetype_row() :: {add_quetype_row, integer()}.

-type get_no_of_active_quetype_row() :: {get_no_of_active_quetype_row,
        integer()}.

-type get_quetype_with_limit_offset_row() :: {get_quetype_with_limit_offset_row,
        integer(),
        binary(),
        binary(),
        binary(),
        binary(),
        boolean()}.

-file("src/route/quetype/sql.gleam", 26).
?DOC(
    " Runs the `add_quetype` query\n"
    " defined in `./src/route/quetype/sql/add_quetype.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec add_quetype(pog:connection(), binary(), boolean(), binary(), binary()) -> {ok,
        pog:returned(add_quetype_row())} |
    {error, pog:query_error()}.
add_quetype(Db, Arg_1, Arg_2, Arg_3, Arg_4) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) -> gleam@dynamic@decode:success({add_quetype_row, Id}) end
        )
    end,
    _pipe = <<"INSERT INTO
    quetype
    (name, active, color, prefix)
VALUES
    ($1, $2, $3, $4)
RETURNING id;
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:parameter(_pipe@2, pog_ffi:coerce(Arg_2)),
    _pipe@4 = pog:parameter(_pipe@3, pog_ffi:coerce(Arg_3)),
    _pipe@5 = pog:parameter(_pipe@4, pog_ffi:coerce(Arg_4)),
    _pipe@6 = pog:returning(_pipe@5, Decoder),
    pog:execute(_pipe@6, Db).

-file("src/route/quetype/sql.gleam", 70).
?DOC(
    " Runs the `get_no_of_active_quetype` query\n"
    " defined in `./src/route/quetype/sql/get_no_of_active_quetype.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_no_of_active_quetype(pog:connection()) -> {ok,
        pog:returned(get_no_of_active_quetype_row())} |
    {error, pog:query_error()}.
get_no_of_active_quetype(Db) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Total_count) ->
                gleam@dynamic@decode:success(
                    {get_no_of_active_quetype_row, Total_count}
                )
            end
        )
    end,
    _pipe = <<"SELECT
    COALESCE(COUNT(id), 0) AS total_count
FROM
    quetype
WHERE
    active = TRUE;
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:returning(_pipe@1, Decoder),
    pog:execute(_pipe@2, Db).

-file("src/route/quetype/sql.gleam", 113).
?DOC(
    " Runs the `get_quetype_with_limit_offset` query\n"
    " defined in `./src/route/quetype/sql/get_quetype_with_limit_offset.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_quetype_with_limit_offset(pog:connection(), integer(), integer()) -> {ok,
        pog:returned(get_quetype_with_limit_offset_row())} |
    {error, pog:query_error()}.
get_quetype_with_limit_offset(Db, Arg_1, Arg_2) ->
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
                            fun(Name) ->
                                gleam@dynamic@decode:field(
                                    3,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Icon) ->
                                        gleam@dynamic@decode:field(
                                            4,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_string/1},
                                            fun(Prefix) ->
                                                gleam@dynamic@decode:field(
                                                    5,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_bool/1},
                                                    fun(Active) ->
                                                        gleam@dynamic@decode:success(
                                                            {get_quetype_with_limit_offset_row,
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
        )
    end,
    _pipe = <<"SELECT
    id, CAST(create_at AS TEXT) AS create_at, name,
    icon, prefix, active
FROM
    quetype
ORDER BY
    name ASC
LIMIT $1
OFFSET $2;
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:parameter(_pipe@2, pog_ffi:coerce(Arg_2)),
    _pipe@4 = pog:returning(_pipe@3, Decoder),
    pog:execute(_pipe@4, Db).
