-module(route@que@sql).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/que/sql.gleam").
-export([add_queue/5, clear_terminal_queue/2, get_queues_using_terminal_code/2, get_queues_using_terminal_id/2, get_terminal_queue_by_code/2, get_terminal_queue_by_id/2, next_queue/2]).
-export_type([add_queue_row/0, get_queues_using_terminal_code_row/0, get_queues_using_terminal_id_row/0, get_terminal_queue_by_code_row/0, get_terminal_queue_by_id_row/0, next_queue_row/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " This module contains the code to run the sql queries defined in\n"
    " `./src/route/que/sql`.\n"
    " > 🐿️ This module was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
    "\n"
).

-type add_queue_row() :: {add_queue_row, integer()}.

-type get_queues_using_terminal_code_row() :: {get_queues_using_terminal_code_row,
        integer(),
        binary()}.

-type get_queues_using_terminal_id_row() :: {get_queues_using_terminal_id_row,
        integer(),
        binary()}.

-type get_terminal_queue_by_code_row() :: {get_terminal_queue_by_code_row,
        integer(),
        binary()}.

-type get_terminal_queue_by_id_row() :: {get_terminal_queue_by_id_row,
        integer(),
        binary()}.

-type next_queue_row() :: {next_queue_row, integer(), binary()}.

-file("src/route/que/sql.gleam", 26).
?DOC(
    " Runs the `add_queue` query\n"
    " defined in `./src/route/que/sql/add_queue.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec add_queue(pog:connection(), integer(), integer(), integer(), integer()) -> {ok,
        pog:returned(add_queue_row())} |
    {error, pog:query_error()}.
add_queue(Db, Arg_1, Arg_2, Arg_3, Arg_4) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) -> gleam@dynamic@decode:success({add_queue_row, Id}) end
        )
    end,
    _pipe = <<"INSERT INTO que
    (reset_id, quetype_id, priority_id, que_no)
VALUES
    ($1, $2, $3, $4)
RETURNING id;"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:parameter(_pipe@2, pog_ffi:coerce(Arg_2)),
    _pipe@4 = pog:parameter(_pipe@3, pog_ffi:coerce(Arg_3)),
    _pipe@5 = pog:parameter(_pipe@4, pog_ffi:coerce(Arg_4)),
    _pipe@6 = pog:returning(_pipe@5, Decoder),
    pog:execute(_pipe@6, Db).

-file("src/route/que/sql.gleam", 58).
?DOC(
    " Runs the `clear_terminal_queue` query\n"
    " defined in `./src/route/que/sql/clear_terminal_queue.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec clear_terminal_queue(pog:connection(), integer()) -> {ok,
        pog:returned(nil)} |
    {error, pog:query_error()}.
clear_terminal_queue(Db, Arg_1) ->
    Decoder = gleam@dynamic@decode:map(
        {decoder, fun gleam@dynamic@decode:decode_dynamic/1},
        fun(_) -> nil end
    ),
    _pipe = <<"UPDATE que
SET update_at = now()
WHERE terminal_id = $1 AND update_at IS NULL;
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).

-file("src/route/que/sql.gleam", 90).
?DOC(
    " Runs the `get_queues_using_terminal_code` query\n"
    " defined in `./src/route/que/sql/get_queues_using_terminal_code.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_queues_using_terminal_code(pog:connection(), binary()) -> {ok,
        pog:returned(get_queues_using_terminal_code_row())} |
    {error, pog:query_error()}.
get_queues_using_terminal_code(Db, Arg_1) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) ->
                gleam@dynamic@decode:field(
                    1,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Que_label) ->
                        gleam@dynamic@decode:success(
                            {get_queues_using_terminal_code_row, Id, Que_label}
                        )
                    end
                )
            end
        )
    end,
    _pipe = <<"SELECT
    q.id, p.prefix || qt.prefix || LPAD(CAST(q.que_no AS TEXT), 3, '0') AS que_label
FROM
    que AS q
        INNER JOIN quetype AS qt ON (qt.id = q.quetype_id)
            INNER JOIN priority AS p ON (p.id = q.priority_id)
        INNER JOIN terminal_quetype AS tq ON (tq.quetype_id = qt.id)
        INNER JOIN terminal AS t ON (t.id = tq.terminal_id)
WHERE
    t.code = $1 AND q.terminal_id IS NULL
    AND q.reset_id = (SELECT r.id FROM reset AS r ORDER BY r.id DESC LIMIT 1)
ORDER BY
    p.level ASC, q.que_no ASC
LIMIT 10;"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).

-file("src/route/que/sql.gleam", 136).
?DOC(
    " Runs the `get_queues_using_terminal_id` query\n"
    " defined in `./src/route/que/sql/get_queues_using_terminal_id.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_queues_using_terminal_id(pog:connection(), integer()) -> {ok,
        pog:returned(get_queues_using_terminal_id_row())} |
    {error, pog:query_error()}.
get_queues_using_terminal_id(Db, Arg_1) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) ->
                gleam@dynamic@decode:field(
                    1,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Que_label) ->
                        gleam@dynamic@decode:success(
                            {get_queues_using_terminal_id_row, Id, Que_label}
                        )
                    end
                )
            end
        )
    end,
    _pipe = <<"SELECT
    q.id, p.prefix || qt.prefix || LPAD(CAST(q.que_no AS TEXT), 3, '0') AS que_label
FROM
    que AS q
        INNER JOIN quetype AS qt ON (qt.id = q.quetype_id)
            INNER JOIN priority AS p ON (p.id = q.priority_id)
        INNER JOIN terminal_quetype AS tq ON (tq.quetype_id = qt.id)
WHERE
    tq.terminal_id = $1 AND q.terminal_id IS NULL 
    AND q.reset_id = (SELECT r.id FROM reset AS r ORDER BY r.id DESC LIMIT 1)
ORDER BY
    p.level ASC, q.que_no ASC
LIMIT 10;"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).

-file("src/route/que/sql.gleam", 181).
?DOC(
    " Runs the `get_terminal_queue_by_code` query\n"
    " defined in `./src/route/que/sql/get_terminal_queue_by_code.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_terminal_queue_by_code(pog:connection(), binary()) -> {ok,
        pog:returned(get_terminal_queue_by_code_row())} |
    {error, pog:query_error()}.
get_terminal_queue_by_code(Db, Arg_1) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) ->
                gleam@dynamic@decode:field(
                    1,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Que_label) ->
                        gleam@dynamic@decode:success(
                            {get_terminal_queue_by_code_row, Id, Que_label}
                        )
                    end
                )
            end
        )
    end,
    _pipe = <<"SELECT
    q.id, p.prefix || qt.prefix || LPAD(CAST(q.que_no AS TEXT), 3, '0') AS que_label
FROM
    que AS q
        INNER JOIN quetype AS qt ON (qt.id = q.quetype_id)
            INNER JOIN priority AS p ON (p.id = q.priority_id)
        INNER JOIN terminal_quetype AS tq ON (tq.quetype_id = qt.id)
        INNER JOIN terminal AS t ON (t.id = tq.terminal_id)
WHERE
    t.code = $1 AND q.terminal_id = t.id AND q.update_at is NULL
    AND q.reset_id = (SELECT r.id FROM reset AS r ORDER BY r.id DESC LIMIT 1)
ORDER BY
    q.update_at DESC
LIMIT 1;"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).

-file("src/route/que/sql.gleam", 227).
?DOC(
    " Runs the `get_terminal_queue_by_id` query\n"
    " defined in `./src/route/que/sql/get_terminal_queue_by_id.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_terminal_queue_by_id(pog:connection(), integer()) -> {ok,
        pog:returned(get_terminal_queue_by_id_row())} |
    {error, pog:query_error()}.
get_terminal_queue_by_id(Db, Arg_1) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) ->
                gleam@dynamic@decode:field(
                    1,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Que_label) ->
                        gleam@dynamic@decode:success(
                            {get_terminal_queue_by_id_row, Id, Que_label}
                        )
                    end
                )
            end
        )
    end,
    _pipe = <<"SELECT
    q.id, p.prefix || qt.prefix || LPAD(CAST(q.que_no AS TEXT), 3, '0') AS que_label
FROM
    que AS q
        INNER JOIN quetype AS qt ON (qt.id = q.quetype_id)
            INNER JOIN priority AS p ON (p.id = q.priority_id)
        INNER JOIN terminal_quetype AS tq ON (tq.quetype_id = qt.id)
WHERE
    q.terminal_id = $1 AND q.update_at is NULL
    AND q.reset_id = (SELECT r.id FROM reset AS r ORDER BY r.id DESC LIMIT 1)
ORDER BY
    q.update_at DESC
LIMIT 1;"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).

-file("src/route/que/sql.gleam", 272).
?DOC(
    " Runs the `next_queue` query\n"
    " defined in `./src/route/que/sql/next_queue.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec next_queue(pog:connection(), integer()) -> {ok,
        pog:returned(next_queue_row())} |
    {error, pog:query_error()}.
next_queue(Db, Arg_1) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Id) ->
                gleam@dynamic@decode:field(
                    1,
                    {decoder, fun gleam@dynamic@decode:decode_string/1},
                    fun(Que_label) ->
                        gleam@dynamic@decode:success(
                            {next_queue_row, Id, Que_label}
                        )
                    end
                )
            end
        )
    end,
    _pipe = <<"WITH rows_to_update AS (
    SELECT q2.id AS que_id, p.prefix || qt.prefix || LPAD(CAST(q2.que_no AS TEXT), 3, '0') AS que_label
    FROM que AS q2
    INNER JOIN quetype AS qt ON qt.id = q2.quetype_id
    INNER JOIN terminal_quetype AS tq ON tq.quetype_id = qt.id
    INNER JOIN priority AS p ON p.id = q2.priority_id
    WHERE q2.terminal_id IS NULL 
      AND tq.terminal_id = $1
      AND q2.reset_id = (SELECT r.id FROM reset AS r ORDER BY r.id DESC LIMIT 1)
    ORDER BY p.level ASC, q2.que_no ASC
    LIMIT 1
)
UPDATE que AS q2
SET terminal_id = $1
FROM rows_to_update
WHERE q2.id = rows_to_update.que_id
RETURNING q2.id, rows_to_update.que_label;
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:returning(_pipe@2, Decoder),
    pog:execute(_pipe@3, Db).
