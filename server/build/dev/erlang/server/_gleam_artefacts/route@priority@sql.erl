-module(route@priority@sql).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/priority/sql.gleam").
-export([get_all_active_priority/3, get_no_of_active_priority/1]).
-export_type([get_all_active_priority_row/0, get_no_of_active_priority_row/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " This module contains the code to run the sql queries defined in\n"
    " `./src/route/priority/sql`.\n"
    " > 🐿️ This module was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
    "\n"
).

-type get_all_active_priority_row() :: {get_all_active_priority_row,
        integer(),
        binary(),
        binary(),
        binary(),
        binary(),
        integer(),
        boolean()}.

-type get_no_of_active_priority_row() :: {get_no_of_active_priority_row,
        integer()}.

-file("src/route/priority/sql.gleam", 34).
?DOC(
    " Runs the `get_all_active_priority` query\n"
    " defined in `./src/route/priority/sql/get_all_active_priority.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_all_active_priority(pog:connection(), integer(), integer()) -> {ok,
        pog:returned(get_all_active_priority_row())} |
    {error, pog:query_error()}.
get_all_active_priority(Db, Arg_1, Arg_2) ->
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
                                                        fun gleam@dynamic@decode:decode_int/1},
                                                    fun(Level) ->
                                                        gleam@dynamic@decode:field(
                                                            6,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_bool/1},
                                                            fun(Active) ->
                                                                gleam@dynamic@decode:success(
                                                                    {get_all_active_priority_row,
                                                                        Id,
                                                                        Create_at,
                                                                        Name,
                                                                        Icon,
                                                                        Prefix,
                                                                        Level,
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
            end
        )
    end,
    _pipe = <<"SELECT
    id, CAST(create_at AS TEXT) AS create_at, name, icon, prefix, level, active
FROM
    priority
WHERE
    active = TRUE
ORDER BY level ASC
LIMIT $1
OFFSET $2
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:parameter(_pipe@1, pog_ffi:coerce(Arg_1)),
    _pipe@3 = pog:parameter(_pipe@2, pog_ffi:coerce(Arg_2)),
    _pipe@4 = pog:returning(_pipe@3, Decoder),
    pog:execute(_pipe@4, Db).

-file("src/route/priority/sql.gleam", 91).
?DOC(
    " Runs the `get_no_of_active_priority` query\n"
    " defined in `./src/route/priority/sql/get_no_of_active_priority.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_no_of_active_priority(pog:connection()) -> {ok,
        pog:returned(get_no_of_active_priority_row())} |
    {error, pog:query_error()}.
get_no_of_active_priority(Db) ->
    Decoder = begin
        gleam@dynamic@decode:field(
            0,
            {decoder, fun gleam@dynamic@decode:decode_int/1},
            fun(Total_count) ->
                gleam@dynamic@decode:success(
                    {get_no_of_active_priority_row, Total_count}
                )
            end
        )
    end,
    _pipe = <<"SELECT
    COALESCE(COUNT(id), 0) AS total_count
FROM
    priority
WHERE
    active = TRUE;
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:returning(_pipe@1, Decoder),
    pog:execute(_pipe@2, Db).
