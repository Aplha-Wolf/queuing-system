-module(eval@context).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([get/0, set/1, update/1]).

-spec get() -> eval:eval(GFL, any(), GFL).
get() ->
    eval:from(fun(Ctx) -> {Ctx, {ok, Ctx}} end).

-spec set(GFQ) -> eval:eval(nil, any(), GFQ).
set(Ctx) ->
    eval:from(fun(_) -> {Ctx, {ok, nil}} end).

-spec update(fun((GFV) -> GFV)) -> eval:eval(nil, any(), GFV).
update(F) ->
    _pipe = get(),
    eval:then(_pipe, fun(Ctx) -> set(F(Ctx)) end).
