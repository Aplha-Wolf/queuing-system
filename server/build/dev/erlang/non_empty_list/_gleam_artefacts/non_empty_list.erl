-module(non_empty_list).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/non_empty_list.gleam").
-export([any/2, first/1, find/2, fold/3, last/1, length/1, new/2, append_list/2, from_list/1, index_map/2, intersperse/2, map/2, prepend/2, reduce/2, rest/1, single/1, to_list/1, append/2, drop/2, group/2, reverse/1, all/1, flatten/1, flat_map/2, map2/3, map_fold/3, scan/3, shuffle/1, sort/2, take/2, unique/1, unzip/1, zip/2, strict_zip/2]).
-export_type([non_empty_list/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-type non_empty_list(ABVB) :: {non_empty_list, ABVB, list(ABVB)}.

-file("src/non_empty_list.gleam", 101).
?DOC(
    " Returns `True` if the given function returns `True` for any of the\n"
    " elements in the given non-empty list. If the function returns `True` for\n"
    " any of the elements it immediately returns `True` without checking the\n"
    " rest of the list.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert any(new(1, [2, 3]), satisfying: fn(x) { x > 2 })\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " assert !any(new(1, [2, 3]), satisfying: fn(x) { x > 5 })\n"
    " ```\n"
).
-spec any(non_empty_list(ABVZ), fun((ABVZ) -> boolean())) -> boolean().
any(List, Predicate) ->
    Predicate(erlang:element(2, List)) orelse gleam@list:any(
        erlang:element(3, List),
        Predicate
    ).

-file("src/non_empty_list.gleam", 132).
?DOC(
    " Gets the first element from the start of the non-empty list.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert first(new(1, [2, 3, 4])) == 1\n"
    " ```\n"
).
-spec first(non_empty_list(ABWE)) -> ABWE.
first(List) ->
    erlang:element(2, List).

-file("src/non_empty_list.gleam", 170).
?DOC(
    " Finds the first element in a given non-empty list for which the given\n"
    " function returns `True`.\n"
    "\n"
    " Returns `Error(Nil)` if no such element is found.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(1, [2, 3]) |> find(one_that: fn(x) { x > 1 }) == Ok(2)\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " assert new(1, [2, 3]) |> find(one_that: fn(x) { x > 5 }) == Error(Nil)\n"
    " ```\n"
).
-spec find(non_empty_list(ABWL), fun((ABWL) -> boolean())) -> {ok, ABWL} |
    {error, nil}.
find(List, Is_desired) ->
    case Is_desired(erlang:element(2, List)) of
        true ->
            {ok, erlang:element(2, List)};

        false ->
            gleam@list:find(erlang:element(3, List), Is_desired)
    end.

-file("src/non_empty_list.gleam", 238).
?DOC(
    " Reduces a non-empty list of elements into a single value by calling a\n"
    " given function on each element, going from left to right.\n"
    "\n"
    " `fold(new(1, [2, 3]), 0, add)` is the equivalent of\n"
    " `add(add(add(0, 1), 2), 3)`.\n"
    "\n"
    " This function runs in linear time.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(1, [2, 3, 4])\n"
    "   |> fold(from: 0, with: fn(acc, x) { acc + x })\n"
    "   == 10\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " assert single(5) |> fold(from: 0, with: fn(acc, x) { acc + x }) == 5\n"
    " ```\n"
).
-spec fold(non_empty_list(ABXC), ABXE, fun((ABXE, ABXC) -> ABXE)) -> ABXE.
fold(List, Initial, Fun) ->
    gleam@list:fold(
        erlang:element(3, List),
        Fun(Initial, erlang:element(2, List)),
        Fun
    ).

-file("src/non_empty_list.gleam", 316).
-spec do_index_map(
    list(ABXU),
    list(ABXW),
    integer(),
    fun((integer(), ABXU) -> ABXW)
) -> list(ABXW).
do_index_map(List, Accumulator, Index, Fun) ->
    case List of
        [] ->
            lists:reverse(Accumulator);

        [First | Rest] ->
            do_index_map(
                Rest,
                [Fun(Index, First) | Accumulator],
                Index + 1,
                Fun
            )
    end.

-file("src/non_empty_list.gleam", 361).
?DOC(
    " Returns the last element in the given list.\n"
    "\n"
    " This function runs in linear time.\n"
    " For a collection oriented around performant access at either end,\n"
    " see `gleam/queue.Queue`.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert last(single(1)) == 1\n"
    " assert last(new(1, [2, 3, 4])) == 4\n"
    " ```\n"
).
-spec last(non_empty_list(ABYC)) -> ABYC.
last(List) ->
    _pipe = gleam@list:last(erlang:element(3, List)),
    gleam@result:unwrap(_pipe, erlang:element(2, List)).

-file("src/non_empty_list.gleam", 378).
?DOC(
    " Counts the number of elements in a given list.\n"
    "\n"
    " This function has to traverse the list to determine the number of elements,\n"
    "  so it runs in linear time.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert length(single(0)) == 1\n"
    " assert length(new(0, [1])) == 2\n"
    " ```\n"
).
-spec length(non_empty_list(any())) -> integer().
length(List) ->
    case erlang:element(3, List) of
        [] ->
            1;

        Rest ->
            1 + erlang:length(Rest)
    end.

-file("src/non_empty_list.gleam", 465).
?DOC(
    " Creates a new non-empty list given its first element and a list\n"
    " for the rest of the elements.\n"
).
-spec new(ABZC, list(ABZC)) -> non_empty_list(ABZC).
new(First, Rest) ->
    {non_empty_list, First, Rest}.

-file("src/non_empty_list.gleam", 82).
?DOC(
    " Joins a list onto the end of a non-empty list.\n"
    "\n"
    " This function runs in linear time, and it traverses and copies the first non-empty list.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(1, [2, 3, 4])\n"
    "   |> append_list([5, 6, 7])\n"
    "   == new(1, [2, 3, 4, 5, 6, 7])\n"
    "\n"
    " assert new(\"a\", [\"b\", \"c\"])\n"
    "   |> append_list([])\n"
    "   == new(\"a\", [\"b\", \"c\"])\n"
    " ```\n"
).
-spec append_list(non_empty_list(ABVV), list(ABVV)) -> non_empty_list(ABVV).
append_list(First, Second) ->
    new(
        erlang:element(2, First),
        lists:append(erlang:element(3, First), Second)
    ).

-file("src/non_empty_list.gleam", 257).
?DOC(
    " Attempts to turn a list into a non-empty list, fails if the starting\n"
    " list is empty.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert from_list([1, 2, 3, 4]) == Ok(new(1, [2, 3, 4]))\n"
    " assert from_list([\"a\"]) == Ok(single(\"a\"))\n"
    " assert from_list([]) == Error(Nil)\n"
    " ```\n"
).
-spec from_list(list(ABXF)) -> {ok, non_empty_list(ABXF)} | {error, nil}.
from_list(List) ->
    case List of
        [] ->
            {error, nil};

        [First | Rest] ->
            {ok, new(First, Rest)}
    end.

-file("src/non_empty_list.gleam", 309).
?DOC(
    " Returns a new list containing only the elements of the first list after the\n"
    " function has been applied to each one and their index.\n"
    "\n"
    " The index starts at 0, so the first element is 0, the second is 1, and so on.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(\"a\", [\"b\", \"c\"])\n"
    "   |> index_map(fn(index, letter) { #(index, letter) })\n"
    "   == new(#(0, \"a\"), [#(1, \"b\"), #(2, \"c\")])\n"
    " ```\n"
).
-spec index_map(non_empty_list(ABXQ), fun((integer(), ABXQ) -> ABXS)) -> non_empty_list(ABXS).
index_map(List, Fun) ->
    new(
        Fun(0, erlang:element(2, List)),
        do_index_map(erlang:element(3, List), [], 1, Fun)
    ).

-file("src/non_empty_list.gleam", 340).
?DOC(
    " Inserts a given value between each existing element in a given list.\n"
    "\n"
    " This function runs in linear time and copies the list.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(1, [2, 3]) |> intersperse(with: 0) == new(1, [0, 2, 0, 3])\n"
    " assert single(\"a\") |> intersperse(with: \"z\") == single(\"a\")\n"
    " ```\n"
).
-spec intersperse(non_empty_list(ABXZ), ABXZ) -> non_empty_list(ABXZ).
intersperse(List, Elem) ->
    case List of
        {non_empty_list, _, []} ->
            List;

        {non_empty_list, First, [_ | _] = Rest} ->
            new(First, [Elem | gleam@list:intersperse(Rest, Elem)])
    end.

-file("src/non_empty_list.gleam", 394).
?DOC(
    " Returns a new non-empty list containing only the elements of the first\n"
    " non-empty list after the function has been applied to each one.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(1, [2, 3]) |> map(fn(x) { x + 1 }) == new(2, [3, 4])\n"
    " ```\n"
).
-spec map(non_empty_list(ABYG), fun((ABYG) -> ABYI)) -> non_empty_list(ABYI).
map(List, Fun) ->
    new(
        Fun(erlang:element(2, List)),
        gleam@list:map(erlang:element(3, List), Fun)
    ).

-file("src/non_empty_list.gleam", 477).
?DOC(
    " Prefixes an item to a non-empty list.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(2, [3, 4]) |> prepend(1) == new(1, [2, 3, 4])\n"
    " ```\n"
).
-spec prepend(non_empty_list(ABZF), ABZF) -> non_empty_list(ABZF).
prepend(List, Item) ->
    new(Item, [erlang:element(2, List) | erlang:element(3, List)]).

-file("src/non_empty_list.gleam", 492).
?DOC(
    " This function acts similar to fold, but does not take an initial state.\n"
    " Instead, it starts from the first element in the non-empty list and combines it with each\n"
    " subsequent element in turn using the given function.\n"
    " The function is called as `fun(accumulator, current_element)`.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(1, [2, 3, 4]) |> reduce(fn(acc, x) { acc + x }) == 10\n"
    " ```\n"
).
-spec reduce(non_empty_list(ABZI), fun((ABZI, ABZI) -> ABZI)) -> ABZI.
reduce(List, Fun) ->
    gleam@list:fold(erlang:element(3, List), erlang:element(2, List), Fun).

-file("src/non_empty_list.gleam", 506).
?DOC(
    " Returns the list minus the first element. Since the remaining list could\n"
    " be empty this functions returns a normal list.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(1, [2, 3, 4]) |> rest == [2, 3, 4]\n"
    " assert single(1) |> rest == []\n"
    " ```\n"
).
-spec rest(non_empty_list(ABZK)) -> list(ABZK).
rest(List) ->
    erlang:element(3, List).

-file("src/non_empty_list.gleam", 583).
?DOC(
    " Creates a non-empty list with a single element.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert single(1) == new(1, [])\n"
    " ```\n"
).
-spec single(ABZX) -> non_empty_list(ABZX).
single(First) ->
    new(First, []).

-file("src/non_empty_list.gleam", 666).
?DOC(
    " Turns a non-empty list back into a normal list with the same\n"
    " elements.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(1, [2, 3, 4]) |> to_list == [1, 2, 3, 4]\n"
    " assert single(\"a\") |> to_list == [\"a\"]\n"
    " ```\n"
).
-spec to_list(non_empty_list(ACAM)) -> list(ACAM).
to_list(Non_empty) ->
    [erlang:element(2, Non_empty) | erlang:element(3, Non_empty)].

-file("src/non_empty_list.gleam", 59).
?DOC(
    " Joins a non-empty list onto the end of a non-empty list.\n"
    "\n"
    " This function runs in linear time, and it traverses and copies the first\n"
    " non-empty list.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(1, [2, 3, 4])\n"
    "   |> append(new(5, [6, 7]))\n"
    "   == new(1, [2, 3, 4, 5, 6, 7])\n"
    "\n"
    " assert single(\"a\")\n"
    "   |> append(new(\"b\", [\"c\"])\n"
    "   == new(\"a\", [\"b\", \"c\"])\n"
    " ````\n"
).
-spec append(non_empty_list(ABVR), non_empty_list(ABVR)) -> non_empty_list(ABVR).
append(First, Second) ->
    new(
        erlang:element(2, First),
        lists:append(erlang:element(3, First), to_list(Second))
    ).

-file("src/non_empty_list.gleam", 118).
?DOC(
    " Returns a list that is the given non-empty list with up to the given\n"
    " number of elements removed from the front of the list.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(\"a\", [\"b\", \"c\"]) |> drop(up_to: 2) == [\"c\"]\n"
    " assert new(\"a\", [\"b\", \"c\"]) |> drop(up_to: 3) == []\n"
    " ```\n"
).
-spec drop(non_empty_list(ABWB), integer()) -> list(ABWB).
drop(List, N) ->
    _pipe = List,
    _pipe@1 = to_list(_pipe),
    gleam@list:drop(_pipe@1, N).

-file("src/non_empty_list.gleam", 207).
-spec reverse_and_prepend(non_empty_list(ABWY), non_empty_list(ABWY)) -> non_empty_list(ABWY).
reverse_and_prepend(Prefix, Suffix) ->
    case erlang:element(3, Prefix) of
        [] ->
            new(erlang:element(2, Prefix), to_list(Suffix));

        [First | Rest] ->
            reverse_and_prepend(
                new(First, Rest),
                new(erlang:element(2, Prefix), to_list(Suffix))
            )
    end.

-file("src/non_empty_list.gleam", 283).
?DOC(
    " Takes a list and groups the values by a key\n"
    " which is built from a key function.\n"
    "\n"
    " Does not preserve the initial value order.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " import gleam/dict\n"
    "\n"
    " assert new(1, [2, 3, 4, 5])\n"
    "   |> group(by: fn(i) { i - i / 3 * 3 })\n"
    "   == dict.from_list([\n"
    "     #(0, new(3, [])),\n"
    "     #(1, new(4, [1])),\n"
    "     #(2, new(5, [2]))\n"
    "   ]\n"
    " ```\n"
).
-spec group(non_empty_list(ABXK), fun((ABXK) -> ABXM)) -> gleam@dict:dict(ABXM, non_empty_list(ABXK)).
group(List, Key) ->
    _pipe = List,
    _pipe@1 = to_list(_pipe),
    _pipe@2 = gleam@list:group(_pipe@1, Key),
    gleam@dict:map_values(
        _pipe@2,
        fun(_, Group) ->
            Group@2 = case from_list(Group) of
                {ok, Group@1} -> Group@1;
                _assert_fail ->
                    erlang:error(#{gleam_error => let_assert,
                                message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                file => <<?FILEPATH/utf8>>,
                                module => <<"non_empty_list"/utf8>>,
                                function => <<"group"/utf8>>,
                                line => 291,
                                value => _assert_fail,
                                start => 7128,
                                'end' => 7167,
                                pattern_start => 7139,
                                pattern_end => 7148})
            end,
            Group@2
        end
    ).

-file("src/non_empty_list.gleam", 522).
?DOC(
    " Creates a new non-empty list from a given non-empty list containing the same\n"
    " elements but in the opposite order.\n"
    "\n"
    " This function has to traverse the non-empty list to create the new reversed\n"
    " non-empty list, so it runs in linear time.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(1, [2, 3, 4]) |> reverse == new(4, [3, 2, 1])\n"
    " ```\n"
).
-spec reverse(non_empty_list(ABZN)) -> non_empty_list(ABZN).
reverse(List) ->
    Reversed@1 = case begin
        _pipe = List,
        _pipe@1 = to_list(_pipe),
        _pipe@2 = lists:reverse(_pipe@1),
        from_list(_pipe@2)
    end of
        {ok, Reversed} -> Reversed;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"non_empty_list"/utf8>>,
                        function => <<"reverse"/utf8>>,
                        line => 523,
                        value => _assert_fail,
                        start => 13231,
                        'end' => 13317,
                        pattern_start => 13242,
                        pattern_end => 13254})
    end,
    Reversed@1.

-file("src/non_empty_list.gleam", 34).
-spec all_loop(list({ok, ABVK} | {error, ABVL}), ABVK, list(ABVK)) -> {ok,
        non_empty_list(ABVK)} |
    {error, ABVL}.
all_loop(Results, Acc_first, Acc_rest) ->
    case Results of
        [{error, Error} | _] ->
            {error, Error};

        [{ok, Value} | Rest] ->
            all_loop(Rest, Value, [Acc_first | Acc_rest]);

        [] ->
            {ok, reverse(new(Acc_first, Acc_rest))}
    end.

-file("src/non_empty_list.gleam", 27).
?DOC(
    " Combines a `NonEmptyList` of `Result`s into a single `Result`. If all\n"
    "  elements in the list are `Ok` then returns an `Ok` holding the list of\n"
    " values. If any element is `Error` then returns the first error.\n"
    "\n"
    " This function runs in linear time, and it traverses and copies the `Ok`\n"
    " values or the `Error` value.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert all(new(Ok(1), [Ok(2)])) == Ok(new(1, [2]))\n"
    " assert all(new(Ok(1), [Error(\"e\")])) == Error(\"e\")\n"
    " ```\n"
).
-spec all(non_empty_list({ok, ABVC} | {error, ABVD})) -> {ok,
        non_empty_list(ABVC)} |
    {error, ABVD}.
all(Results) ->
    case first(Results) of
        {ok, Value} ->
            all_loop(rest(Results), Value, []);

        {error, Error} ->
            {error, Error}
    end.

-file("src/non_empty_list.gleam", 196).
-spec do_flatten(list(non_empty_list(ABWT)), non_empty_list(ABWT)) -> non_empty_list(ABWT).
do_flatten(Lists, Accumulator) ->
    case Lists of
        [] ->
            reverse(Accumulator);

        [List | Further_lists] ->
            do_flatten(Further_lists, reverse_and_prepend(List, Accumulator))
    end.

-file("src/non_empty_list.gleam", 192).
?DOC(
    " Flattens a non-empty list of non-empty lists into a single non-empty list.\n"
    "\n"
    " This function traverses all elements twice.\n"
    "\n"
    " ### Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(new(1, [2, 3]), [new(3, [4, 5])])\n"
    "   |> flatten\n"
    "   == new(1, [2, 3, 4, 5])\n"
    " ```\n"
).
-spec flatten(non_empty_list(non_empty_list(ABWP))) -> non_empty_list(ABWP).
flatten(Lists) ->
    do_flatten(erlang:element(3, Lists), reverse(erlang:element(2, Lists))).

-file("src/non_empty_list.gleam", 146).
?DOC(
    " Maps the non-empty list with the given function and then flattens it.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(1, [3, 5])\n"
    "   |> flat_map(fn(x) { new(x, [x + 1]) })\n"
    "   == new(1, [2, 3, 4, 5, 6])\n"
    " ```\n"
).
-spec flat_map(non_empty_list(ABWG), fun((ABWG) -> non_empty_list(ABWI))) -> non_empty_list(ABWI).
flat_map(List, Fun) ->
    _pipe = List,
    _pipe@1 = map(_pipe, Fun),
    flatten(_pipe@1).

-file("src/non_empty_list.gleam", 420).
-spec do_map2(
    non_empty_list(ABYQ),
    list(ABYS),
    list(ABYU),
    fun((ABYS, ABYU) -> ABYQ)
) -> non_empty_list(ABYQ).
do_map2(Acc, List1, List2, Fun) ->
    case {List1, List2} of
        {[], _} ->
            reverse(Acc);

        {_, []} ->
            reverse(Acc);

        {[First_a | Rest_as], [First_b | Rest_bs]} ->
            _pipe = prepend(Acc, Fun(First_a, First_b)),
            do_map2(_pipe, Rest_as, Rest_bs, Fun)
    end.

-file("src/non_empty_list.gleam", 412).
?DOC(
    " Combines two non-empty lists into a single non-empty list using the given\n"
    " function.\n"
    "\n"
    " If a list is longer than the other the extra elements are dropped.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert map2(new(1, [2, 3]), new(4, [5, 6]), fn(x, y) { x + y })\n"
    "   == new(5, [7, 9])\n"
    " assert map2(new(1, [2]), new(\"a\", [\"b\", \"c\"]), fn(i, x) { #(i, x) })\n"
    "   == new(#(1, \"a\"), [#(2, \"b\")])\n"
    " ```\n"
).
-spec map2(
    non_empty_list(ABYK),
    non_empty_list(ABYM),
    fun((ABYK, ABYM) -> ABYO)
) -> non_empty_list(ABYO).
map2(List1, List2, Fun) ->
    do_map2(
        single(Fun(erlang:element(2, List1), erlang:element(2, List2))),
        erlang:element(3, List1),
        erlang:element(3, List2),
        Fun
    ).

-file("src/non_empty_list.gleam", 444).
?DOC(
    " Similar to `map` but also lets you pass around an accumulated value.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(1, [2, 3])\n"
    "   |> map_fold(from: 100, with: fn(memo, n) { #(memo + i, i * 2) })\n"
    "   == #(106, new(2, [4, 6]))\n"
    " ```\n"
).
-spec map_fold(non_empty_list(ABYX), ABYZ, fun((ABYZ, ABYX) -> {ABYZ, ABZA})) -> {ABYZ,
    non_empty_list(ABZA)}.
map_fold(List, Acc, Fun) ->
    {Acc@1, First_elem} = Fun(Acc, erlang:element(2, List)),
    _pipe = gleam@list:fold(
        erlang:element(3, List),
        {Acc@1, single(First_elem)},
        fun(Acc_non_empty, Item) ->
            {Acc@2, Non_empty} = Acc_non_empty,
            {Acc@3, New_item} = Fun(Acc@2, Item),
            {Acc@3, prepend(Non_empty, New_item)}
        end
    ),
    gleam@pair:map_second(_pipe, fun reverse/1).

-file("src/non_empty_list.gleam", 541).
?DOC(
    " Similar to fold, but yields the state of the accumulator at each stage.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(1, [2, 3, 4])\n"
    "   |> scan(from: 100, with: fn(acc, i) { acc + i })\n"
    "   == new(101 [103, 106, 110])\n"
    " ```\n"
).
-spec scan(non_empty_list(ABZQ), ABZS, fun((ABZS, ABZQ) -> ABZS)) -> non_empty_list(ABZS).
scan(List, Initial, Fun) ->
    Scanned@1 = case begin
        _pipe = List,
        _pipe@1 = to_list(_pipe),
        _pipe@2 = gleam@list:scan(_pipe@1, Initial, Fun),
        from_list(_pipe@2)
    end of
        {ok, Scanned} -> Scanned;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"non_empty_list"/utf8>>,
                        function => <<"scan"/utf8>>,
                        line => 546,
                        value => _assert_fail,
                        start => 13689,
                        'end' => 13797,
                        pattern_start => 13700,
                        pattern_end => 13711})
    end,
    Scanned@1.

-file("src/non_empty_list.gleam", 566).
?DOC(
    " Takes a non-empty list, randomly sorts all items and returns the shuffled\n"
    " non-empty list.\n"
    "\n"
    " This function uses Erlang's `:rand` module or Javascript's\n"
    " `Math.random()` to calcuate the index shuffling.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(\"a\", [\"b\", \"c\", \"d\"]) |> shuffle == new(\"c\", [\"a\", \"d\", \"b\"])\n"
    " ```\n"
).
-spec shuffle(non_empty_list(ABZU)) -> non_empty_list(ABZU).
shuffle(List) ->
    Shuffled@1 = case begin
        _pipe = List,
        _pipe@1 = to_list(_pipe),
        _pipe@2 = gleam@list:shuffle(_pipe@1),
        from_list(_pipe@2)
    end of
        {ok, Shuffled} -> Shuffled;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"non_empty_list"/utf8>>,
                        function => <<"shuffle"/utf8>>,
                        line => 567,
                        value => _assert_fail,
                        start => 14216,
                        'end' => 14302,
                        pattern_start => 14227,
                        pattern_end => 14239})
    end,
    Shuffled@1.

-file("src/non_empty_list.gleam", 598).
?DOC(
    " Sorts a given non-empty list from smallest to largest based upon the\n"
    " ordering specified by a given function.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " import gleam/int\n"
    " assert new(4, [1, 3, 4, 2, 6, 5]) |> sort(by: int.compare)\n"
    "   == new(1, [2, 3, 4, 4, 5, 6])\n"
    " ```\n"
).
-spec sort(non_empty_list(ABZZ), fun((ABZZ, ABZZ) -> gleam@order:order())) -> non_empty_list(ABZZ).
sort(List, Compare) ->
    Sorted@1 = case begin
        _pipe = List,
        _pipe@1 = to_list(_pipe),
        _pipe@2 = gleam@list:sort(_pipe@1, Compare),
        from_list(_pipe@2)
    end of
        {ok, Sorted} -> Sorted;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"non_empty_list"/utf8>>,
                        function => <<"sort"/utf8>>,
                        line => 602,
                        value => _assert_fail,
                        start => 14900,
                        'end' => 14994,
                        pattern_start => 14911,
                        pattern_end => 14921})
    end,
    Sorted@1.

-file("src/non_empty_list.gleam", 650).
?DOC(
    " Returns a list containing the first given number of elements from the given\n"
    " non-empty list.\n"
    "\n"
    " If the element has less than the number of elements then the full list is\n"
    " returned.\n"
    "\n"
    " This function runs in linear time but does not copy the list.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(1, [2, 3, 4]) |> take(2) == [1, 2]\n"
    " assert new(1, [2, 3, 4]) |> take(9) == [1, 2, 3, 4]\n"
    " ```\n"
).
-spec take(non_empty_list(ACAJ), integer()) -> list(ACAJ).
take(List, N) ->
    _pipe = List,
    _pipe@1 = to_list(_pipe),
    gleam@list:take(_pipe@1, N).

-file("src/non_empty_list.gleam", 680).
?DOC(
    " Removes any duplicate elements from a given list.\n"
    "\n"
    " This function returns in loglinear time.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(1, [1, 2, 3, 1, 4, 4, 3]) |> unique == new(1, [2, 3, 4])\n"
    " ```\n"
).
-spec unique(non_empty_list(ACAP)) -> non_empty_list(ACAP).
unique(List) ->
    Unique@1 = case begin
        _pipe = List,
        _pipe@1 = to_list(_pipe),
        _pipe@2 = gleam@list:unique(_pipe@1),
        from_list(_pipe@2)
    end of
        {ok, Unique} -> Unique;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"non_empty_list"/utf8>>,
                        function => <<"unique"/utf8>>,
                        line => 681,
                        value => _assert_fail,
                        start => 16876,
                        'end' => 16959,
                        pattern_start => 16887,
                        pattern_end => 16897})
    end,
    Unique@1.

-file("src/non_empty_list.gleam", 699).
?DOC(
    " Takes a single non-empty list of 2-element tuples and returns two\n"
    " non-empty lists.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert new(#(1, \"a\"), [#(2, \"b\"), #(3, \"c\")]) |> unzip\n"
    "  == #(new(1, [2, 3]), new(\"a\", [\"b\", \"c\"]))\n"
    " ```\n"
).
-spec unzip(non_empty_list({ACAS, ACAT})) -> {non_empty_list(ACAS),
    non_empty_list(ACAT)}.
unzip(List) ->
    _pipe = gleam@list:unzip(erlang:element(3, List)),
    _pipe@1 = gleam@pair:map_first(
        _pipe,
        fun(_capture) ->
            new(erlang:element(1, erlang:element(2, List)), _capture)
        end
    ),
    gleam@pair:map_second(
        _pipe@1,
        fun(_capture@1) ->
            new(erlang:element(2, erlang:element(2, List)), _capture@1)
        end
    ).

-file("src/non_empty_list.gleam", 720).
?DOC(
    " Takes two non-empty lists and returns a single non-empty list of 2-element\n"
    " tuples.\n"
    "\n"
    " If one of the non-empty lists is longer than the other, the remaining\n"
    " elements from the longer non-empty list are not used.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert zip(new(1, [2, 3]), single(\"a\")) == new(#(1, \"a\"), [])\n"
    " assert zip(single(1), new(\"a\", [\"b\", \"c\"])) == new(#(1, \"a\"), [])\n"
    " assert zip(new(1, [2, 3]), new(\"a\", [\"b\", \"c\"])) ==\n"
    "   new(#(1, \"a\"), [#(2, \"b\"), #(3, \"c\")])\n"
    " ```\n"
).
-spec zip(non_empty_list(ACAX), non_empty_list(ACAZ)) -> non_empty_list({ACAX,
    ACAZ}).
zip(List, Other) ->
    new(
        {erlang:element(2, List), erlang:element(2, Other)},
        gleam@list:zip(erlang:element(3, List), erlang:element(3, Other))
    ).

-file("src/non_empty_list.gleam", 625).
?DOC(
    " Takes two non-empty lists and returns a single non-empty list of 2-element\n"
    " tuples.\n"
    "\n"
    " If one of the non-empty lists is longer than the other, an `Error` is\n"
    " returned.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " assert strict_zip(single(1), new(\"a\", [\"b\", \"c\"])) == Error(Nil)\n"
    " assert strict_zip(new(1, [2, 3]), single(\"a\")) == Error(Nil)\n"
    " assert strict_zip(new(1, [2, 3]), new(\"a\", [\"b\", \"c\"]))\n"
    "   == Ok(new(#(1, \"a\"), [#(2, \"b\"), #(3, \"c\")]))\n"
    " ```\n"
).
-spec strict_zip(non_empty_list(ACAC), non_empty_list(ACAE)) -> {ok,
        non_empty_list({ACAC, ACAE})} |
    {error, nil}.
strict_zip(List, Other) ->
    case erlang:length(to_list(List)) =:= erlang:length(to_list(Other)) of
        true ->
            {ok, zip(List, Other)};

        false ->
            {error, nil}
    end.
