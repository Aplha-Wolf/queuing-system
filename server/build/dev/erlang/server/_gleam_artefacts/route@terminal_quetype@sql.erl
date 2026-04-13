-module(route@terminal_quetype@sql).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/terminal_quetype/sql.gleam").
-export([add_terminal_quetype/3, delete_terminal_quetype/2, list_delete_not_terminal_quetype/3, list_delete_terminal_quetype/2]).
-export_type([add_terminal_quetype_row/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " This module contains the code to run the sql queries defined in\n"
    " `./src/route/terminal_quetype/sql`.\n"
    " > 🐿️ This module was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
    "\n"
).

-type add_terminal_quetype_row() :: {add_terminal_quetype_row, integer()}.

-file("src/route/terminal_quetype/sql.gleam", 26).
?DOC(
    " Runs the `add_terminal_quetype` query\n"
    " defined in `./src/route/terminal_quetype/sql/add_terminal_quetype.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec add_terminal_quetype(pog:connection(), integer(), integer()) -> {ok,
        pog:returned(add_terminal_quetype_row())} |
    {error, pog:query_error()}.
add_terminal_quetype(Db, Arg_1, Arg_2) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) ->
                gleam@dynamic@decode:success({add_terminal_quetype_row, Id})
            end
        )
    end,
    _pipe = <<"INSERT INTO
    terminal_quetype
    (terminal_id, quetype_id)
VALUES
    ($1, $2)
RETURNING id;"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:parameter(_pipe@2, pog_ffi:coerce(Arg_2)),
    _pipe@4 = pog:returning(_pipe@3, Decoder),
    pog:execute(_pipe@4, Db).

-file("src/route/terminal_quetype/sql.gleam", 55).
?DOC(
    " Runs the `delete_terminal_quetype` query\n"
    " defined in `./src/route/terminal_quetype/sql/delete_terminal_quetype.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec delete_terminal_quetype(pog:connection(), integer()) -> {ok,
        pog:returned(nil)} |
    {error, pog:query_error()}.
delete_terminal_quetype(Db, Arg_1) ->
    Decoder = gleam@dynamic@decode:map(
        {decoder, fun gleam@dynamic@decode:decode_dynamic/1},
        fun(_) -> nil end
    ),
    _pipe = <<"DELETE
FROM
    terminal_quetype
WHERE
    id = $1;"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).

-file("src/route/terminal_quetype/sql.gleam", 78).
?DOC(
    " Runs the `list_delete_not_terminal_quetype` query\n"
    " defined in `./src/route/terminal_quetype/sql/list_delete_not_terminal_quetype.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec list_delete_not_terminal_quetype(
    pog:connection(),
    integer(),
    list(integer())
) -> {ok, pog:returned(nil)} | {error, pog:query_error()}.
list_delete_not_terminal_quetype(Db, Arg_1, Arg_2) ->
    Decoder = gleam@dynamic@decode:map(
        {decoder, fun gleam@dynamic@decode:decode_dynamic/1},
        fun(_) -> nil end
    ),
    _pipe = <<"DELETE FROM
    terminal_quetype
WHERE
    terminal_id = $1
    AND quetype_id != ANY($2);"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:parameter(
        _pipe@2,
        pog:array(fun(Value) -> pog_ffi:coerce(Value) end, Arg_2)
    ),
    _pipe@4 = pog:returning(_pipe@3, Decoder),
    pog:execute(_pipe@4, Db).

-file("src/route/terminal_quetype/sql.gleam", 103).
?DOC(
    " Runs the `list_delete_terminal_quetype` query\n"
    " defined in `./src/route/terminal_quetype/sql/list_delete_terminal_quetype.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec list_delete_terminal_quetype(pog:connection(), integer()) -> {ok,
        pog:returned(nil)} |
    {error, pog:query_error()}.
list_delete_terminal_quetype(Db, Arg_1) ->
    Decoder = gleam@dynamic@decode:map(
        {decoder, fun gleam@dynamic@decode:decode_dynamic/1},
        fun(_) -> nil end
    ),
    _pipe = <<"DELETE FROM
    terminal_quetype
WHERE
    terminal_id = $1;"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).
