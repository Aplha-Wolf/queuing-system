-module(eval).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([run/2, step/2, return/1, throw/1, from/1, from_option/2, from_result/1, map/2, map2/3, map_error/2, replace/2, replace_error/2, then/2, 'try'/2, guard/3, all/1, attempt/2]).
-export_type([eval/3]).

-opaque eval(FQU, FQV, FQW) :: {eval,
        fun((FQW) -> {FQW, {ok, FQU} | {error, FQV}})}.

-spec run(eval(FQX, FQY, FQZ), FQZ) -> {ok, FQX} | {error, FQY}.
run(Eval, Context) ->
    _pipe = (erlang:element(2, Eval))(Context),
    gleam@pair:second(_pipe).

-spec step(eval(FRF, FRG, FRH), FRH) -> {FRH, {ok, FRF} | {error, FRG}}.
step(Eval, Ctx) ->
    (erlang:element(2, Eval))(Ctx).

-spec return(FRN) -> eval(FRN, any(), any()).
return(Value) ->
    {eval, fun(Ctx) -> {Ctx, {ok, Value}} end}.

-spec throw(FRT) -> eval(any(), FRT, any()).
throw(Error) ->
    {eval, fun(Ctx) -> {Ctx, {error, Error}} end}.

-spec from(fun((FRZ) -> {FRZ, {ok, FSA} | {error, FSB}})) -> eval(FSA, FSB, FRZ).
from(Eval) ->
    {eval, Eval}.

-spec from_option(gleam@option:option(FSH), FSJ) -> eval(FSH, FSJ, any()).
from_option(Value, Error) ->
    case Value of
        {some, A} ->
            return(A);

        none ->
            throw(Error)
    end.

-spec from_result({ok, FSO} | {error, FSP}) -> eval(FSO, FSP, any()).
from_result(Value) ->
    case Value of
        {ok, A} ->
            return(A);

        {error, E} ->
            throw(E)
    end.

-spec map(eval(FSW, FSX, FSY), fun((FSW) -> FTC)) -> eval(FTC, FSX, FSY).
map(Eval, F) ->
    {eval,
        fun(Ctx) ->
            {Ctx@1, Result} = (erlang:element(2, Eval))(Ctx),
            case Result of
                {ok, A} ->
                    {Ctx@1, {ok, F(A)}};

                {error, E} ->
                    {Ctx@1, {error, E}}
            end
        end}.

-spec map2(eval(FTG, FTH, FTI), eval(FTM, FTH, FTI), fun((FTG, FTM) -> FTQ)) -> eval(FTQ, FTH, FTI).
map2(Eval_a, Eval_b, F) ->
    {eval,
        fun(Ctx) ->
            {Ctx@1, Res} = (erlang:element(2, Eval_a))(Ctx),
            case Res of
                {ok, A} ->
                    {Ctx@2, Res@1} = (erlang:element(2, Eval_b))(Ctx@1),
                    case Res@1 of
                        {ok, B} ->
                            {Ctx@2, {ok, F(A, B)}};

                        {error, E} ->
                            {Ctx@2, {error, E}}
                    end;

                {error, E@1} ->
                    {Ctx@1, {error, E@1}}
            end
        end}.

-spec map_error(eval(FTU, FTV, FTW), fun((FTV) -> FUA)) -> eval(FTU, FUA, FTW).
map_error(Eval, F) ->
    {eval,
        fun(Ctx) ->
            {Ctx@1, Result} = (erlang:element(2, Eval))(Ctx),
            case Result of
                {ok, A} ->
                    {Ctx@1, {ok, A}};

                {error, E} ->
                    {Ctx@1, {error, F(E)}}
            end
        end}.

-spec replace(eval(any(), FUF, FUG), FUK) -> eval(FUK, FUF, FUG).
replace(Eval, Replacement) ->
    {eval,
        fun(Ctx) ->
            {Ctx@1, Result} = (erlang:element(2, Eval))(Ctx),
            case Result of
                {ok, _} ->
                    {Ctx@1, {ok, Replacement}};

                {error, E} ->
                    {Ctx@1, {error, E}}
            end
        end}.

-spec replace_error(eval(FUO, any(), FUQ), FUU) -> eval(FUO, FUU, FUQ).
replace_error(Eval, Replacement) ->
    {eval,
        fun(Ctx) ->
            {Ctx@1, Result} = (erlang:element(2, Eval))(Ctx),
            case Result of
                {ok, A} ->
                    {Ctx@1, {ok, A}};

                {error, _} ->
                    {Ctx@1, {error, Replacement}}
            end
        end}.

-spec then(eval(FUY, FUZ, FVA), fun((FUY) -> eval(FVE, FUZ, FVA))) -> eval(FVE, FUZ, FVA).
then(Eval, F) ->
    {eval,
        fun(Ctx) ->
            {Ctx@1, Result} = (erlang:element(2, Eval))(Ctx),
            case Result of
                {ok, A} ->
                    step(F(A), Ctx@1);

                {error, E} ->
                    {Ctx@1, {error, E}}
            end
        end}.

-spec 'try'(eval(FVL, FVM, FVN), fun((FVL) -> eval(FVR, FVM, FVN))) -> eval(FVR, FVM, FVN).
'try'(Eval, F) ->
    {eval,
        fun(Ctx) ->
            {Ctx@1, Result} = (erlang:element(2, Eval))(Ctx),
            case Result of
                {ok, A} ->
                    step(F(A), Ctx@1);

                {error, E} ->
                    {Ctx@1, {error, E}}
            end
        end}.

-spec guard(boolean(), FVY, fun(() -> eval(FVZ, FVY, FWA))) -> eval(FVZ, FVY, FWA).
guard(Requirement, Consequence, Do) ->
    gleam@bool:guard(Requirement, throw(Consequence), Do).

-spec all(list(eval(FWH, FWI, FWJ))) -> eval(list(FWH), FWI, FWJ).
all(Evals) ->
    Prepend = fun(List, A) -> [A | List] end,
    Callback = fun(A@1, List@1) -> map2(A@1, List@1, Prepend) end,
    _pipe = gleam@list:fold(Evals, return([]), Callback),
    map(_pipe, fun lists:reverse/1).

-spec attempt(eval(FWS, FWT, FWU), fun((FWU, FWT) -> eval(FWS, FWT, FWU))) -> eval(FWS, FWT, FWU).
attempt(Eval, F) ->
    {eval,
        fun(Ctx) ->
            {Ctx_, Result} = (erlang:element(2, Eval))(Ctx),
            case Result of
                {ok, A} ->
                    {Ctx_, {ok, A}};

                {error, E} ->
                    step(F(Ctx_, E), Ctx)
            end
        end}.
