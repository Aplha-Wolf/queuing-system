-module(squirrel@internal@eval_extra).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/squirrel/internal/eval_extra.gleam").
-export([run_all/2, try_fold/3, try_map/2, try_index_map/2]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-file("src/squirrel/internal/eval_extra.gleam", 20).
?DOC(false).
-spec run_all(list(eval:eval(AHSW, AHSX, AHSY)), AHSY) -> list({ok, AHSW} |
    {error, AHSX}).
run_all(List, Context) ->
    Acc = {[], Context},
    {Results@1, _} = begin
        gleam@list:fold(
            List,
            Acc,
            fun(_use0, Script) ->
                {Results, Context@1} = _use0,
                {Context@2, Result} = eval:step(Script, Context@1),
                {[Result | Results], Context@2}
            end
        )
    end,
    Results@1.

-file("src/squirrel/internal/eval_extra.gleam", 42).
?DOC(false).
-spec try_fold(
    list(AHTU),
    AHTW,
    fun((AHTW, AHTU) -> eval:eval(AHTW, AHUC, AHUD))
) -> eval:eval(AHTW, AHUC, AHUD).
try_fold(List, Acc, Fun) ->
    case List of
        [] ->
            eval:return(Acc);

        [First | Rest] ->
            eval:'try'(
                Fun(Acc, First),
                fun(Acc@1) -> try_fold(Rest, Acc@1, Fun) end
            )
    end.

-file("src/squirrel/internal/eval_extra.gleam", 7).
?DOC(false).
-spec try_map(list(AHSI), fun((AHSI) -> eval:eval(AHSK, AHWM, AHWN))) -> eval:eval(list(AHSK), AHWM, AHWN).
try_map(List, Fun) ->
    _pipe = try_fold(
        List,
        [],
        fun(Acc, Item) ->
            eval:'try'(
                Fun(Item),
                fun(Mapped_item) -> eval:return([Mapped_item | Acc]) end
            )
        end
    ),
    eval:map(_pipe, fun lists:reverse/1).

-file("src/squirrel/internal/eval_extra.gleam", 64).
?DOC(false).
-spec do_try_index_fold(
    integer(),
    list(AHUU),
    AHUW,
    fun((AHUW, AHUU, integer()) -> eval:eval(AHUW, AHVC, AHVD))
) -> eval:eval(AHUW, AHVC, AHVD).
do_try_index_fold(Index, List, Acc, Fun) ->
    case List of
        [] ->
            eval:return(Acc);

        [First | Rest] ->
            eval:'try'(
                Fun(Acc, First, Index),
                fun(Acc@1) -> do_try_index_fold(Index + 1, Rest, Acc@1, Fun) end
            )
    end.

-file("src/squirrel/internal/eval_extra.gleam", 56).
?DOC(false).
-spec try_index_fold(
    list(AHUH),
    AHUJ,
    fun((AHUJ, AHUH, integer()) -> eval:eval(AHUJ, AHUK, AHUL))
) -> eval:eval(AHUJ, AHUK, AHUL).
try_index_fold(List, Acc, Fun) ->
    do_try_index_fold(0, List, Acc, Fun).

-file("src/squirrel/internal/eval_extra.gleam", 31).
?DOC(false).
-spec try_index_map(
    list(AHTG),
    fun((AHTG, integer()) -> eval:eval(AHTI, AHXV, AHXW))
) -> eval:eval(list(AHTI), AHXV, AHXW).
try_index_map(List, Fun) ->
    _pipe = try_index_fold(
        List,
        [],
        fun(Acc, Item, I) ->
            eval:'try'(
                Fun(Item, I),
                fun(Mapped_item) -> eval:return([Mapped_item | Acc]) end
            )
        end
    ),
    eval:map(_pipe, fun lists:reverse/1).
