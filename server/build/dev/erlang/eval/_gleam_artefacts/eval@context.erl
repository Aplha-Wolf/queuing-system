-module(eval@context).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/eval/context.gleam").
-export([get/0, set/1, update/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-file("src/eval/context.gleam", 5).
?DOC(" Get the current context.\n").
-spec get() -> eval:eval(EQY, any(), EQY).
get() ->
    eval:from(fun(Ctx) -> {Ctx, {ok, Ctx}} end).

-file("src/eval/context.gleam", 11).
?DOC(" Replace the current context with a new fixed value.\n").
-spec set(ERD) -> eval:eval(nil, any(), ERD).
set(Ctx) ->
    eval:from(fun(_) -> {Ctx, {ok, nil}} end).

-file("src/eval/context.gleam", 17).
?DOC(" Update the current context by applying a function to it.\n").
-spec update(fun((ERI) -> ERI)) -> eval:eval(nil, any(), ERI).
update(F) ->
    _pipe = get(),
    eval:then(_pipe, fun(Ctx) -> set(F(Ctx)) end).
