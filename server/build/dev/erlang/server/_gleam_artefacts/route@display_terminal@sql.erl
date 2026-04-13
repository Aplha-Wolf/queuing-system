-module(route@display_terminal@sql).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/display_terminal/sql.gleam").
-export([get_display_terminals/3]).
-export_type([get_display_terminals_row/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " This module contains the code to run the sql queries defined in\n"
    " `./src/route/display_terminal/sql`.\n"
    " > 🐿️ This module was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
    "\n"
).

-type get_display_terminals_row() :: {get_display_terminals_row,
        integer(),
        binary(),
        binary(),
        binary()}.

-file("src/route/display_terminal/sql.gleam", 26).
?DOC(
    " Runs the `get_display_terminals` query\n"
    " defined in `./src/route/display_terminal/sql/get_display_terminals.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_display_terminals(pog:connection(), integer(), integer()) -> {ok,
        pog:returned(get_display_terminals_row())} |
    {error, pog:query_error()}.
get_display_terminals(Db, Arg_1, Arg_2) ->
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
                                        fun gleam@dynamic@decode:decode_string/1},
                                    fun(Que_label) ->
                                        gleam@dynamic@decode:success(
                                            {get_display_terminals_row,
                                                Id,
                                                Code,
                                                Name,
                                                Que_label}
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
    dt.terminal_id AS id, t.code AS code, t.name AS name, 
    COALESCE((SELECT
        p.prefix || qt.prefix || LPAD(CAST(q.que_no AS TEXT), 3, '0')
    FROM
        que AS q
            INNER JOIN quetype AS qt ON (qt.id = q.quetype_id)
                INNER JOIN priority AS p ON (p.id = q.priority_id)
            INNER JOIN terminal_quetype AS tq ON (tq.quetype_id = qt.id)
    WHERE
        q.terminal_id = dt.terminal_id AND q.update_at is NULL
        AND q.reset_id = (SELECT r.id FROM reset AS r ORDER BY r.id DESC LIMIT 1)
    ORDER BY
        q.update_at DESC
    LIMIT 1), '') AS que_label
FROM
    display_terminal AS dt
        INNER JOIN terminal AS t ON (t.id = dt.terminal_id)
WHERE
    dt.display_id = $1
ORDER BY
    dt.order ASC, dt.id ASC
LIMIT $2
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:parameter(_pipe@2, pog_ffi:coerce(Arg_2)),
    _pipe@4 = pog:returning(_pipe@3, Decoder),
    pog:execute(_pipe@4, Db).
