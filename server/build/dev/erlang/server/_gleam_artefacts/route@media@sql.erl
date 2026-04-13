-module(route@media@sql).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/media/sql.gleam").
-export([get_new_media/1]).
-export_type([get_new_media_row/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " This module contains the code to run the sql queries defined in\n"
    " `./src/route/media/sql`.\n"
    " > 🐿️ This module was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
    "\n"
).

-type get_new_media_row() :: {get_new_media_row,
        integer(),
        binary(),
        binary(),
        boolean(),
        integer(),
        binary(),
        boolean()}.

-file("src/route/media/sql.gleam", 34).
?DOC(
    " Runs the `get_new_media` query\n"
    " defined in `./src/route/media/sql/get_new_media.sql`.\n"
    "\n"
    " > 🐿️ This function was generated automatically using v4.6.0 of\n"
    " > the [squirrel package](https://github.com/giacomocavalieri/squirrel).\n"
).
-spec get_new_media(pog:connection()) -> {ok, pog:returned(get_new_media_row())} |
    {error, pog:query_error()}.
get_new_media(Db) ->
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
                                        fun gleam@dynamic@decode:decode_bool/1},
                                    fun(Is_ads) ->
                                        gleam@dynamic@decode:field(
                                            4,
                                            {decoder,
                                                fun gleam@dynamic@decode:decode_int/1},
                                            fun(Media_type) ->
                                                gleam@dynamic@decode:field(
                                                    5,
                                                    {decoder,
                                                        fun gleam@dynamic@decode:decode_string/1},
                                                    fun(Filename) ->
                                                        gleam@dynamic@decode:field(
                                                            6,
                                                            {decoder,
                                                                fun gleam@dynamic@decode:decode_bool/1},
                                                            fun(Active) ->
                                                                gleam@dynamic@decode:success(
                                                                    {get_new_media_row,
                                                                        Id,
                                                                        Create_at,
                                                                        Name,
                                                                        Is_ads,
                                                                        Media_type,
                                                                        Filename,
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
  id, TO_CHAR(create_at, 'YYYY-MM-DD HH24:MI:SS') AS create_at, name, is_ads, media_type, filename, active 
FROM
    media
WHERE id = (
    SELECT id
    FROM media
  WHERE active = TRUE AND is_ads = TRUE
    ORDER BY RANDOM() LIMIT 1
);
"/utf8>>,
    _pipe@1 = pog:'query'(_pipe),
    _pipe@2 = pog:returning(_pipe@1, Decoder),
    pog:execute(_pipe@2, Db).
