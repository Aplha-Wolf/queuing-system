-module(route@terminal@sql).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/terminal/sql.gleam").
-export([add_terminal/3, delete_terminal/2, find_terminal_by_code/2, find_terminal_by_id/2, find_terminal_by_name/2, list_all_terminals/1, update_teminal/5]).
-export_type([add_terminal_row/0, find_terminal_by_code_row/0, find_terminal_by_id_row/0, find_terminal_by_name_row/0, list_all_terminals_row/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " This module contains the code to run the sql queries defined in\n"
    " `./src/route/terminal/sql`.\n"
    " > 🐿️ This module was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
    "\n"
).

-type add_terminal_row() :: {add_terminal_row, integer()}.

-type find_terminal_by_code_row() :: {find_terminal_by_code_row,
        integer(),
        binary(),
        binary(),
        boolean(),
        binary()}.

-type find_terminal_by_id_row() :: {find_terminal_by_id_row,
        integer(),
        binary(),
        binary(),
        boolean(),
        binary()}.

-type find_terminal_by_name_row() :: {find_terminal_by_name_row,
        integer(),
        binary(),
        binary(),
        boolean(),
        binary()}.

-type list_all_terminals_row() :: {list_all_terminals_row,
        integer(),
        binary(),
        binary(),
        boolean(),
        binary()}.

-file("src/route/terminal/sql.gleam", 26).
?DOC(
    " Runs the `add_terminal` query\n"
    " defined in `./src/route/terminal/sql/add_terminal.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec add_terminal(pog:connection(), binary(), binary()) -> {ok,
        pog:returned(add_terminal_row())} |
    {error, pog:query_error()}.
add_terminal(Db, Arg_1, Arg_2) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) -> gleam@dynamic@decode:success({add_terminal_row, Id}) end
        )
    end,
    _pipe = <<"INSERT INTO terminal 
    (code, name) 
VALUES 
    ($1, $2)
RETURNING id;"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:parameter(_pipe@2, pog_ffi:coerce(Arg_2)),
    _pipe@4 = pog:returning(_pipe@3, Decoder),
    pog:execute(_pipe@4, Db).

-file("src/route/terminal/sql.gleam", 54).
?DOC(
    " Runs the `delete_terminal` query\n"
    " defined in `./src/route/terminal/sql/delete_terminal.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec delete_terminal(pog:connection(), integer()) -> {ok, pog:returned(nil)} |
    {error, pog:query_error()}.
delete_terminal(Db, Arg_1) ->
    Decoder = gleam@dynamic@decode:map(
        {decoder, fun gleam@dynamic@decode:decode_dynamic/1},
        fun(_) -> nil end
    ),
    _pipe = <<"DELETE FROM terminal 
WHERE 
    id = $1"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).

-file("src/route/terminal/sql.gleam", 91).
?DOC(
    " Runs the `find_terminal_by_code` query\n"
    " defined in `./src/route/terminal/sql/find_terminal_by_code.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec find_terminal_by_code(pog:connection(), binary()) -> {ok,
        pog:returned(find_terminal_by_code_row())} |
    {error, pog:query_error()}.
find_terminal_by_code(Db, Arg_1) ->
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
                            fun(Name) ->
                                gleam@dynamic@decode:field(
                                    3,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_bool/1},
                                    fun(Active) ->
                                        gleam@dynamic@decode:field(
                                            4,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_string/1},
                                            fun(Create_at) ->
                                                gleam@dynamic@decode:success(
                                                    {find_terminal_by_code_row,
                                                        Id,
                                                        Code,
                                                        Name,
                                                        Active,
                                                        Create_at}
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
    id, code, name, active, CAST(create_at AS TEXT) AS create_at
FROM
    terminal
WHERE
    code LIKE $1
LIMIT 1
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).

-file("src/route/terminal/sql.gleam", 140).
?DOC(
    " Runs the `find_terminal_by_id` query\n"
    " defined in `./src/route/terminal/sql/find_terminal_by_id.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec find_terminal_by_id(pog:connection(), integer()) -> {ok,
        pog:returned(find_terminal_by_id_row())} |
    {error, pog:query_error()}.
find_terminal_by_id(Db, Arg_1) ->
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
                            fun(Name) ->
                                gleam@dynamic@decode:field(
                                    3,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_bool/1},
                                    fun(Active) ->
                                        gleam@dynamic@decode:field(
                                            4,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_string/1},
                                            fun(Create_at) ->
                                                gleam@dynamic@decode:success(
                                                    {find_terminal_by_id_row,
                                                        Id,
                                                        Code,
                                                        Name,
                                                        Active,
                                                        Create_at}
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
    id, code, name, active, CAST(create_at AS TEXT) AS create_at
FROM 
    terminal 
WHERE 
    id = $1
LIMIT 1"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).

-file("src/route/terminal/sql.gleam", 188).
?DOC(
    " Runs the `find_terminal_by_name` query\n"
    " defined in `./src/route/terminal/sql/find_terminal_by_name.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec find_terminal_by_name(pog:connection(), binary()) -> {ok,
        pog:returned(find_terminal_by_name_row())} |
    {error, pog:query_error()}.
find_terminal_by_name(Db, Arg_1) ->
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
                            fun(Name) ->
                                gleam@dynamic@decode:field(
                                    3,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_bool/1},
                                    fun(Active) ->
                                        gleam@dynamic@decode:field(
                                            4,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_string/1},
                                            fun(Create_at) ->
                                                gleam@dynamic@decode:success(
                                                    {find_terminal_by_name_row,
                                                        Id,
                                                        Code,
                                                        Name,
                                                        Active,
                                                        Create_at}
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
  id, code, name, active, CAST(create_at AS TEXT) AS create_at
FROM
  terminal
WHERE
  name LIKE $1
LIMIT 1"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).

-file("src/route/terminal/sql.gleam", 236).
?DOC(
    " Runs the `list_all_terminals` query\n"
    " defined in `./src/route/terminal/sql/list_all_terminals.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec list_all_terminals(pog:connection()) -> {ok,
        pog:returned(list_all_terminals_row())} |
    {error, pog:query_error()}.
list_all_terminals(Db) ->
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
                            fun(Name) ->
                                gleam@dynamic@decode:field(
                                    3,
                                    {decoder,
                                        fun gleam@dynamic@decode:decode_bool/1},
                                    fun(Active) ->
                                        gleam@dynamic@decode:field(
                                            4,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_string/1},
                                            fun(Create_at) ->
                                                gleam@dynamic@decode:success(
                                                    {list_all_terminals_row,
                                                        Id,
                                                        Code,
                                                        Name,
                                                        Active,
                                                        Create_at}
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
    id, code, name, active, CAST(create_at AS TEXT) AS create_at
FROM
    terminal"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:returning(_pipe@1, Decoder),
    pog:execute(_pipe@2, Db).

-file("src/route/terminal/sql.gleam", 263).
?DOC(
    " Runs the `update_teminal` query\n"
    " defined in `./src/route/terminal/sql/update_teminal.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec update_teminal(pog:connection(), binary(), binary(), boolean(), integer()) -> {ok,
        pog:returned(nil)} |
    {error, pog:query_error()}.
update_teminal(Db, Arg_1, Arg_2, Arg_3, Arg_4) ->
    Decoder = gleam@dynamic@decode:map(
        {decoder, fun gleam@dynamic@decode:decode_dynamic/1},
        fun(_) -> nil end
    ),
    _pipe = <<"UPDATE terminal 
SET 
    code = $1, name = $2, active = $3
WHERE 
    id = $4"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:parameter(_pipe@2, pog_ffi:coerce(Arg_2)),
    _pipe@4 = pog:parameter(_pipe@3, pog_ffi:coerce(Arg_3)),
    _pipe@5 = pog:parameter(_pipe@4, pog_ffi:coerce(Arg_4)),
    _pipe@6 = pog:returning(_pipe@5, Decoder),
    pog:execute(_pipe@6, Db).
