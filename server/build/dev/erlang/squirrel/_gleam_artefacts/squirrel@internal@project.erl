-module(squirrel@internal@project).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/squirrel/internal/project.gleam").
-export([name/0, src/0, test_/0, dev/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-file("src/squirrel/internal/project.gleam", 20).
?DOC(false).
-spec try_nil(
    {ok, AKEK} | {error, any()},
    fun((AKEK) -> {ok, AKEO} | {error, nil})
) -> {ok, AKEO} | {error, nil}.
try_nil(Result, Do) ->
    gleam@result:'try'(gleam@result:replace_error(Result, nil), Do).

-file("src/squirrel/internal/project.gleam", 58).
?DOC(false).
-spec find_root(binary()) -> binary().
find_root(Path) ->
    Toml = filepath:join(Path, <<"gleam.toml"/utf8>>),
    case simplifile_erl:is_file(Toml) of
        {ok, false} ->
            find_root(filepath:join(<<".."/utf8>>, Path));

        {error, _} ->
            find_root(filepath:join(<<".."/utf8>>, Path));

        {ok, true} ->
            Path
    end.

-file("src/squirrel/internal/project.gleam", 54).
?DOC(false).
-spec root() -> binary().
root() ->
    find_root(<<"."/utf8>>).

-file("src/squirrel/internal/project.gleam", 11).
?DOC(false).
-spec name() -> {ok, binary()} | {error, nil}.
name() ->
    Configuration_path = filepath:join(root(), <<"gleam.toml"/utf8>>),
    try_nil(
        simplifile:read(Configuration_path),
        fun(Configuration) ->
            try_nil(
                tom:parse(Configuration),
                fun(Toml) ->
                    try_nil(
                        tom:get_string(Toml, [<<"name"/utf8>>]),
                        fun(Name) -> {ok, Name} end
                    )
                end
            )
        end
    ).

-file("src/squirrel/internal/project.gleam", 31).
?DOC(false).
-spec src() -> binary().
src() ->
    filepath:join(root(), <<"src"/utf8>>).

-file("src/squirrel/internal/project.gleam", 39).
?DOC(false).
-spec test_() -> binary().
test_() ->
    filepath:join(root(), <<"test"/utf8>>).

-file("src/squirrel/internal/project.gleam", 47).
?DOC(false).
-spec dev() -> binary().
dev() ->
    filepath:join(root(), <<"dev"/utf8>>).
