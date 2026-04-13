-module(eval).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/eval.gleam").
-export([run/2, step/2, return/1, throw/1, from/1, from_option/2, from_result/1, map/2, map2/3, map_error/2, replace/2, replace_error/2, then/2, 'try'/2, guard/3, all/1, attempt/2]).
-export_type([eval/3]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC("\n").

-opaque eval(ECJ, ECK, ECL) :: {eval,
        fun((ECL) -> {ECL, {ok, ECJ} | {error, ECK}})}.

-file("src/eval.gleam", 27).
?DOC(
    " Given an `Eval`, actuall perform the computation by also providing the context\n"
    " that the computation is running in.\n"
).
-spec run(eval(ECM, ECN, ECO), ECO) -> {ok, ECM} | {error, ECN}.
run(Eval, Context) ->
    _pipe = (erlang:element(2, Eval))(Context),
    gleam@pair:second(_pipe).

-file("src/eval.gleam", 36).
?DOC(
    " Step through an `Eval` and get back both it's result and the context it\n"
    " produced. This is especially useful if you want to run some computation,\n"
    " do some other Gleam bits, and then continue with the computation by passing\n"
    " the produced context to `run` or `step` again.\n"
).
-spec step(eval(ECU, ECV, ECW), ECW) -> {ECW, {ok, ECU} | {error, ECV}}.
step(Eval, Ctx) ->
    (erlang:element(2, Eval))(Ctx).

-file("src/eval.gleam", 50).
?DOC(
    " Construct an `Eval` that always succeeds with the given value, regardless of\n"
    " context.\n"
    "\n"
    " 📝 Note: you might find this called `pure` or `return` in some other languages\n"
    " like Haskell or PureScript.\n"
).
-spec return(EDC) -> eval(EDC, any(), any()).
return(Value) ->
    {eval, fun(Ctx) -> {Ctx, {ok, Value}} end}.

-file("src/eval.gleam", 72).
?DOC(
    " Construct an `Eval` that always fails with the given error, regardless of\n"
    " context. Often used in combination with `then` to run some `Eval` and then\n"
    " potentially fail based on the result of that computation.\n"
    "\n"
    " ```gleam\n"
    " eval(expr) |> then(fn (y) {\n"
    "   case y == 0.0 {\n"
    "     True ->\n"
    "       throw(DivisionByZero)\n"
    "\n"
    "     False ->\n"
    "       succeed(y)\n"
    "   }\n"
    " })\n"
    " ```\n"
).
-spec throw(EDI) -> eval(any(), EDI, any()).
throw(Error) ->
    {eval, fun(Ctx) -> {Ctx, {error, Error}} end}.

-file("src/eval.gleam", 84).
?DOC(
    " Construct an `Eval` from a function that takes some context and returns a pair\n"
    " of a new context and some `Result` value. This is provided as a fallback if\n"
    " none of the functions here or in `eval/context` are getting you where you need\n"
    " to go: generally you should avoid using this in favour of _combining_ the\n"
    " other functions in this module!\n"
).
-spec from(fun((EDO) -> {EDO, {ok, EDP} | {error, EDQ}})) -> eval(EDP, EDQ, EDO).
from(Eval) ->
    {eval, Eval}.

-file("src/eval.gleam", 92).
?DOC(
    " Construct an `Eval` from an optional value and an error to throw if that value\n"
    " is `None`. This is useful for situations where you have some function or value\n"
    " that returns an `Option` but is not dependent on the context.\n"
).
-spec from_option(gleam@option:option(EDW), EDY) -> eval(EDW, EDY, any()).
from_option(Value, Error) ->
    case Value of
        {some, A} ->
            return(A);

        none ->
            throw(Error)
    end.

-file("src/eval.gleam", 103).
?DOC(
    " Construct an `Eval` from a result. This is useful for situations where you have\n"
    " some function or value that returns a `Result` but is not dependent on the\n"
    " context.\n"
).
-spec from_result({ok, EED} | {error, EEE}) -> eval(EED, EEE, any()).
from_result(Value) ->
    case Value of
        {ok, A} ->
            return(A);

        {error, E} ->
            throw(E)
    end.

-file("src/eval.gleam", 120).
?DOC(
    " Transform the value produced by an `Eval` using the given function.\n"
    "\n"
    " 📝 Note: you might find this called `fmap` or `<$>` in some other languages\n"
    " like Haskell or PureScript. In this context, the `Eval` type would be known\n"
    " as a _functor_.\n"
).
-spec map(eval(EEL, EEM, EEN), fun((EEL) -> EER)) -> eval(EER, EEM, EEN).
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

-file("src/eval.gleam", 135).
?DOC(
    "\n"
    "\n"
    " 📝 Note: you might find this called `liftA2` or `liftM2` in some other\n"
    " languages like Haskell or PureScript.\n"
).
-spec map2(eval(EEV, EEW, EEX), eval(EFB, EEW, EEX), fun((EEV, EFB) -> EFF)) -> eval(EFF, EEW, EEX).
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

-file("src/eval.gleam", 160).
?DOC(
    " Just like `map` but for error-producing steps instead. Transforms the error\n"
    " produced by some `Eval` step using the given function.\n"
).
-spec map_error(eval(EFJ, EFK, EFL), fun((EFK) -> EFP)) -> eval(EFJ, EFP, EFL).
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

-file("src/eval.gleam", 174).
?DOC(
    " Run an `Eval` step but then replace its result with some other fixed value.\n"
    " Often used in tandem with effectful steps that often _do_ something but don't\n"
    " produce any meaninful value (and so are usually `Eval(Nil, e, ctx)`).\n"
).
-spec replace(eval(any(), EFU, EFV), EFZ) -> eval(EFZ, EFU, EFV).
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

-file("src/eval.gleam", 187).
?DOC(
    " Just like `replace` but for error-producing steps instead. Replaces the error\n"
    " thrown by some `Eval` step with another, fixed, value.\n"
).
-spec replace_error(eval(EGD, any(), EGF), EGJ) -> eval(EGD, EGJ, EGF).
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

-file("src/eval.gleam", 211).
?DOC(
    " Run an `Eval` and then apply a function that returns another `Eval` to the\n"
    " result. This can be useful for chaining together multiple `Eval`s.\n"
    "\n"
    " 📝 Note: you might find this called `bind`, `>>=`, `flatMap`, or `andThen` in\n"
    " some other languages like Haskell, Elm, or PureScript. In this context, the\n"
    " `Eval` type would be known as a _monad_.\n"
).
-spec then(eval(EGN, EGO, EGP), fun((EGN) -> eval(EGT, EGO, EGP))) -> eval(EGT, EGO, EGP).
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

-file("src/eval.gleam", 233).
?DOC(
    " Run an `Eval` and then apply a function that returns another `Eval` to the\n"
    " result. This can be useful for chaining together multiple `Eval`s. This is\n"
    " the same as [`then`](#then) but you might find the `try` naming nicer to use\n"
    " with Gleam's `use` notation.\n"
    "\n"
    " 📝 Note: you might find this called `bind`, `>>=`, `flatMap`, or `andThen` in\n"
    " some other languages like Haskell, Elm, or PureScript. In this context, the\n"
    " `Eval` type would be known as a _monad_.\n"
).
-spec 'try'(eval(EHA, EHB, EHC), fun((EHA) -> eval(EHG, EHB, EHC))) -> eval(EHG, EHB, EHC).
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

-file("src/eval.gleam", 248).
?DOC("\n").
-spec guard(boolean(), EHN, fun(() -> eval(EHO, EHN, EHP))) -> eval(EHO, EHN, EHP).
guard(Requirement, Consequence, Do) ->
    gleam@bool:guard(Requirement, throw(Consequence), Do).

-file("src/eval.gleam", 263).
?DOC(
    " Run a list of `Eval`s in sequence and then combine their results into a list.\n"
    " If any of the `Eval`s fail, the whole sequence fails.\n"
    "\n"
    " 📝 Note: you might find this called `sequence` in some other languages like\n"
    " Haskell or PureScript.\n"
).
-spec all(list(eval(EHW, EHX, EHY))) -> eval(list(EHW), EHX, EHY).
all(Evals) ->
    Prepend = fun(List, A) -> [A | List] end,
    Callback = fun(A@1, List@1) -> map2(A@1, List@1, Prepend) end,
    _pipe = gleam@list:fold(Evals, return([]), Callback),
    map(_pipe, fun lists:reverse/1).

-file("src/eval.gleam", 274).
?DOC(
    " Run an `Eval` and then attempt to recover from an error by applying a function\n"
    " that takes the error value and returns another `Eval`.\n"
).
-spec attempt(eval(EIH, EII, EIJ), fun((EIJ, EII) -> eval(EIH, EII, EIJ))) -> eval(EIH, EII, EIJ).
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
