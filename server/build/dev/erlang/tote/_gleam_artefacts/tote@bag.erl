-module(tote@bag).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/tote/bag.gleam").
-export([new/0, from_map/1, remove_all/2, copies/2, remove/3, insert/3, from_list/1, update/3, contains/2, is_empty/1, fold/3, size/1, intersect/2, merge/2, subtract/2, map/2, filter/2, to_list/1, to_set/1, to_map/1]).
-export_type([bag/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    "\n"
    " This module has all the functions you may need to work with bags (if you\n"
    " feel something is missing, please\n"
    " [open an issue](https://github.com/giacomocavalieri/tote/issues))!\n"
    "\n"
    " To quickly browse the documentation you can use this cheatsheet:\n"
    "\n"
    " <table>\n"
    " <tbody>\n"
    "   <tr>\n"
    "     <td>Creating bags</td>\n"
    "     <td>\n"
    "      <a href=\"#new\">new</a>,\n"
    "      <a href=\"#from_list\">from_list</a>,\n"
    "      <a href=\"#from_map\">from_map</a>\n"
    "     </td>\n"
    "   </tr>\n"
    "   <tr>\n"
    "     <td>Adding or removing items</td>\n"
    "     <td>\n"
    "      <a href=\"#insert\">insert</a>,\n"
    "      <a href=\"#remove\">remove</a>,\n"
    "      <a href=\"#remove_all\">remove_all</a>,\n"
    "      <a href=\"#update\">update</a>\n"
    "     </td>\n"
    "   </tr>\n"
    "   <tr>\n"
    "     <td>Querying the content of a bag</td>\n"
    "     <td>\n"
    "      <a href=\"#copies\">copies</a>,\n"
    "      <a href=\"#contains\">contains</a>,\n"
    "      <a href=\"#is_empty\">is_empty</a>,\n"
    "      <a href=\"#size\">size</a>\n"
    "     </td>\n"
    "   </tr>\n"
    "   <tr>\n"
    "     <td>Combining bags</td>\n"
    "     <td>\n"
    "      <a href=\"#intersect\">intersect</a>,\n"
    "      <a href=\"#merge\">merge</a>,\n"
    "      <a href=\"#subtract\">subtract</a>\n"
    "     </td>\n"
    "   </tr>\n"
    "   <tr>\n"
    "     <td>Transforming the content of a bag</td>\n"
    "     <td>\n"
    "      <a href=\"#fold\">fold</a>,\n"
    "      <a href=\"#map\">map</a>,\n"
    "      <a href=\"#filter\">filter</a>\n"
    "     </td>\n"
    "   </tr>\n"
    "   <tr>\n"
    "     <td>Converting a bag into other data structures</td>\n"
    "     <td>\n"
    "      <a href=\"#to_list\">to_list</a>,\n"
    "      <a href=\"#to_set\">to_set</a>,\n"
    "      <a href=\"#to_map\">to_map</a>\n"
    "     </td>\n"
    "   </tr>\n"
    " </tbody>\n"
    " </table>\n"
    "\n"
).

-opaque bag(AFUW) :: {bag, gleam@dict:dict(AFUW, integer())}.

-file("src/tote/bag.gleam", 91).
?DOC(" Creates a new empty bag.\n").
-spec new() -> bag(any()).
new() ->
    {bag, maps:new()}.

-file("src/tote/bag.gleam", 122).
?DOC(
    " Creates a new bag from the map where each key/value pair is turned into\n"
    " an item with those many copies inside the bag.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " map.from_list([#(\"a\", 1), #(\"b\", 2)])\n"
    " |> bag.from_map\n"
    " |> bag.to_list\n"
    " // [#(\"a\", 1), #(\"b\", 2)]\n"
    " ```\n"
).
-spec from_map(gleam@dict:dict(AFVC, integer())) -> bag(AFVC).
from_map(Map) ->
    {bag, Map}.

-file("src/tote/bag.gleam", 215).
?DOC(
    " Removes all the copies of a given item from a bag.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\", \"b\", \"a\"])\n"
    " |> bag.remove_all(\"a\")\n"
    " |> bag.to_list\n"
    " // [#(b, 1)]\n"
    " ```\n"
).
-spec remove_all(bag(AFVM), AFVM) -> bag(AFVM).
remove_all(Bag, Item) ->
    {bag, gleam@dict:delete(erlang:element(2, Bag), Item)}.

-file("src/tote/bag.gleam", 270).
?DOC(
    " Counts the number of copies of an item inside a bag.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\", \"b\", \"a\", \"c\"])\n"
    " |> bag.copies(of: \"a\")\n"
    " // 2\n"
    " ```\n"
).
-spec copies(bag(AFVS), AFVS) -> integer().
copies(Bag, Item) ->
    case gleam_stdlib:map_get(erlang:element(2, Bag), Item) of
        {ok, Copies} ->
            Copies;

        {error, nil} ->
            0
    end.

-file("src/tote/bag.gleam", 196).
?DOC(
    " Removes `n` copies of the given item from a bag.\n"
    "\n"
    " If the quantity to remove is greater than the number of copies in the bag,\n"
    " all copies of that item are removed.\n"
    "\n"
    " > ⚠️ Giving a negative quantity to remove doesn't really make sense, so the\n"
    " > sign of the `copies` argument is always ignored.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\", \"a\"])\n"
    " |> bag.remove(1, \"a\")\n"
    " |> bag.copies(of: \"a\")\n"
    " // 1\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\", \"a\"])\n"
    " |> bag.remove(-1, \"a\")\n"
    " |> bag.copies(of: \"a\")\n"
    " // 1\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\", \"a\"])\n"
    " |> bag.remove(10, \"a\")\n"
    " |> bag.copies(of: \"a\")\n"
    " // 0\n"
    " ```\n"
).
-spec remove(bag(AFVJ), integer(), AFVJ) -> bag(AFVJ).
remove(Bag, To_remove, Item) ->
    To_remove@1 = gleam@int:absolute_value(To_remove),
    Item_copies = copies(Bag, Item),
    case gleam@int:compare(To_remove@1, Item_copies) of
        lt ->
            {bag,
                gleam@dict:insert(
                    erlang:element(2, Bag),
                    Item,
                    Item_copies - To_remove@1
                )};

        gt ->
            remove_all(Bag, Item);

        eq ->
            remove_all(Bag, Item)
    end.

-file("src/tote/bag.gleam", 149).
?DOC(
    " Adds `n` copies of the given item into a bag.\n"
    "\n"
    " If the number of copies to add is negative, then this is the same as calling\n"
    " [`remove`](#remove) and will remove that many copies from the bag.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " bag.new()\n"
    " |> bag.insert(2, \"a\")\n"
    " |> bag.copies(of: \"a\")\n"
    " // 2\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\"])\n"
    " |> bag.insert(-1, \"a\")\n"
    " |> bag.copies(of: \"a\")\n"
    " // 0\n"
    " ```\n"
).
-spec insert(bag(AFVG), integer(), AFVG) -> bag(AFVG).
insert(Bag, To_add, Item) ->
    case gleam@int:compare(To_add, 0) of
        lt ->
            remove(Bag, To_add, Item);

        eq ->
            Bag;

        gt ->
            {bag,
                gleam@dict:upsert(
                    erlang:element(2, Bag),
                    Item,
                    fun(N) -> case N of
                            {some, N@1} ->
                                N@1 + To_add;

                            none ->
                                To_add
                        end end
                )}
    end.

-file("src/tote/bag.gleam", 105).
?DOC(
    " Creates a new bag from the given list by counting its items.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\", \"b\", \"a\", \"c\"])\n"
    " |> bag.to_list\n"
    " // [#(\"a\", 2), #(\"b\", 1), #(\"c\", 1)]\n"
    " ```\n"
).
-spec from_list(list(AFUZ)) -> bag(AFUZ).
from_list(List) ->
    gleam@list:fold(List, new(), fun(Bag, Item) -> insert(Bag, 1, Item) end).

-file("src/tote/bag.gleam", 247).
?DOC(
    " Updates the number of copies of an item in the bag.\n"
    "\n"
    " If the function returns 0 or a negative number, the item is removed from\n"
    " the bag.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\"])\n"
    " |> bag.update(\"a\", fn(n) { n + 1 })\n"
    " |> bag.copies(of: \"a\")\n"
    " // 2\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " bag.new()\n"
    " |> bag.update(\"a\", fn(_) { 10 })\n"
    " |> bag.copies(of: \"a\")\n"
    " // 10\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\"])\n"
    " |> bag.update(\"a\", fn(_) { -1 })\n"
    " |> bag.copies(of: \"a\")\n"
    " // 0\n"
    " ```\n"
).
-spec update(bag(AFVP), AFVP, fun((integer()) -> integer())) -> bag(AFVP).
update(Bag, Item, Fun) ->
    Count = copies(Bag, Item),
    New_count = Fun(Count),
    case gleam@int:compare(New_count, 0) of
        lt ->
            remove_all(Bag, Item);

        eq ->
            remove_all(Bag, Item);

        gt ->
            _pipe = remove_all(Bag, Item),
            insert(_pipe, New_count, Item)
    end.

-file("src/tote/bag.gleam", 293).
?DOC(
    " Returns `True` if the bag contains at least a copy of the given item.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\", \"b\"])\n"
    " |> bag.contains(\"a\")\n"
    " // True\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\", \"b\"])\n"
    " |> bag.contains(\"c\")\n"
    " // False\n"
    " ```\n"
).
-spec contains(bag(AFVU), AFVU) -> boolean().
contains(Bag, Item) ->
    gleam@dict:has_key(erlang:element(2, Bag), Item).

-file("src/tote/bag.gleam", 316).
?DOC(
    " Returns `True` if the bag is empty.\n"
    "\n"
    " > ⚠️ This is more efficient than checking if the bag's size is 0.\n"
    " > You should always use this function to check that a bag is empty!\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " bag.new()\n"
    " |> bag.is_empty()\n"
    " // True\n"
    " ```\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\", \"b\"])\n"
    " |> bag.is_empty()\n"
    " // False\n"
    " ```\n"
).
-spec is_empty(bag(any())) -> boolean().
is_empty(Bag) ->
    erlang:element(2, Bag) =:= maps:new().

-file("src/tote/bag.gleam", 420).
?DOC(
    " Combines all items of a bag into a single value by calling a given function\n"
    " on each one.\n"
    "\n"
    " The function will receive as input the accumulator, the item and\n"
    " its number of copies.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " let bag = bag.from_list([\"a\", \"b\", \"b\"])\n"
    " bag.fold(over: bag, from: 0, with: fn(count, _, copies) {\n"
    "   count + copies\n"
    " })\n"
    " // 3\n"
    " ```\n"
).
-spec fold(bag(AFWM), AFWO, fun((AFWO, AFWM, integer()) -> AFWO)) -> AFWO.
fold(Bag, Initial, Fun) ->
    gleam@dict:fold(erlang:element(2, Bag), Initial, Fun).

-file("src/tote/bag.gleam", 337).
?DOC(
    " Returns the total number of items inside a bag.\n"
    "\n"
    " > ⚠️ This function takes linear time in the number of distinct items in the\n"
    " > bag.\n"
    " >\n"
    " > If you need to check that a bag is empty, you should always use the\n"
    " > [`is_empty`](#is_empty) function instead of checking if the size is 0.\n"
    " > It's going to be way more efficient!\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\", \"b\", \"a\", \"c\"])\n"
    " |> bag.size\n"
    " // 4\n"
    " ```\n"
).
-spec size(bag(any())) -> integer().
size(Bag) ->
    fold(Bag, 0, fun(Sum, _, Copies) -> Sum + Copies end).

-file("src/tote/bag.gleam", 358).
?DOC(
    " Intersects two bags keeping the minimum number of copies of each item\n"
    " that appear in both bags.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " let bag1 = bag.from_list([\"a\", \"a\", \"b\", \"c\"])\n"
    " let bag2 = bag.from_list([\"a\", \"c\", \"c\"])\n"
    "\n"
    " bag.intersect(bag1, bag2)\n"
    " |> bag.to_list\n"
    " // [#(\"a\", 1), #(\"c\", 1)]\n"
    " ```\n"
).
-spec intersect(bag(AFWA), bag(AFWA)) -> bag(AFWA).
intersect(One, Other) ->
    fold(
        One,
        new(),
        fun(Acc, Item, Copies_in_one) -> case copies(Other, Item) of
                0 ->
                    Acc;

                Copies_in_other ->
                    insert(
                        Acc,
                        gleam@int:min(Copies_in_one, Copies_in_other),
                        Item
                    )
            end end
    ).

-file("src/tote/bag.gleam", 380).
?DOC(
    " Adds all the items of two bags together.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " let bag1 = bag.from_list([\"a\", \"b\"])\n"
    " let bag2 = bag.from_list([\"b\", \"c\"])\n"
    "\n"
    " bag.merge(bag1, bag2)\n"
    " |> bag.to_list\n"
    " // [#(\"a\", 1), #(\"b\", 2), #(\"c\", 1)]\n"
    " ```\n"
).
-spec merge(bag(AFWE), bag(AFWE)) -> bag(AFWE).
merge(One, Other) ->
    fold(
        One,
        Other,
        fun(Acc, Item, Copies_in_one) -> insert(Acc, Copies_in_one, Item) end
    ).

-file("src/tote/bag.gleam", 398).
?DOC(
    " Removes all items of the second bag from the first one.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " let bag1 = bag.from_list([\"a\", \"b\", \"b\"])\n"
    " let bag2 = bag.from_list([\"b\", \"c\"])\n"
    "\n"
    " bag.subtract(from: one, items_of: other)\n"
    " |> bag.to_list\n"
    " // [#(\"a\", 1), #(\"b\", 1)]\n"
    " ```\n"
).
-spec subtract(bag(AFWI), bag(AFWI)) -> bag(AFWI).
subtract(One, Other) ->
    fold(
        Other,
        One,
        fun(Acc, Item, Copies_in_other) ->
            remove(Acc, Copies_in_other, Item)
        end
    ).

-file("src/tote/bag.gleam", 443).
?DOC(
    " Updates all values of a bag calling on each a function that takes as\n"
    " argument the item and its number of copies.\n"
    "\n"
    " If one or more items are mapped to the same item, their occurrences are\n"
    " summed up.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\", \"b\", \"b\"])\n"
    " |> bag.map(fn(item, _) { \"c\" })\n"
    " |> bag.to_list\n"
    " // [#(\"c\", 3)]\n"
    " ```\n"
).
-spec map(bag(AFWP), fun((AFWP, integer()) -> AFWR)) -> bag(AFWR).
map(Bag, Fun) ->
    fold(
        Bag,
        new(),
        fun(Acc, Item, Copies) -> insert(Acc, Copies, Fun(Item, Copies)) end
    ).

-file("src/tote/bag.gleam", 460).
?DOC(
    " Only keeps the items of a bag the respect a given predicate that takes as\n"
    " input an item and the number of its copies.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\", \"b\", \"a\", \"b\", \"c\", \"d\"])\n"
    " |> bag.filter(keeping: fn(_, copies) { copies <= 1 })\n"
    " |> bag.to_list\n"
    " // [#(\"c\", 1), #(\"d\", 1)]\n"
    " ```\n"
).
-spec filter(bag(AFWT), fun((AFWT, integer()) -> boolean())) -> bag(AFWT).
filter(Bag, Predicate) ->
    fold(Bag, new(), fun(Acc, Item, Copies) -> case Predicate(Item, Copies) of
                true ->
                    insert(Acc, Copies, Item);

                false ->
                    Acc
            end end).

-file("src/tote/bag.gleam", 481).
?DOC(
    " Turns a `Bag` into a list of items and their respective number of copies in\n"
    " the bag.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\", \"b\", \"a\", \"c\"])\n"
    " |> bag.to_list\n"
    " // [#(\"a\", 2), #(\"b\", 1), #(\"c\", 1)]\n"
    " ```\n"
).
-spec to_list(bag(AFWW)) -> list({AFWW, integer()}).
to_list(Bag) ->
    maps:to_list(erlang:element(2, Bag)).

-file("src/tote/bag.gleam", 496).
?DOC(
    " Turns a `Bag` into a set of its items, losing all information on their\n"
    " number of copies.\n"
    "\n"
    " ## Examples\n"
    "\n"
    " ```gleam\n"
    " bag.from_list([\"a\", \"b\", \"a\", \"c\"])\n"
    " |> bag.to_set\n"
    " // set.from_list([\"a\", \"b\", \"c\"])\n"
    " ```\n"
).
-spec to_set(bag(AFWZ)) -> gleam@set:set(AFWZ).
to_set(Bag) ->
    gleam@set:from_list(maps:keys(erlang:element(2, Bag))).

-file("src/tote/bag.gleam", 503).
?DOC(
    " Turns a `Bag` into a map. Each item in the bag becomes a key and the\n"
    " associated value is the number of its copies in the bag.\n"
).
-spec to_map(bag(AFXC)) -> gleam@dict:dict(AFXC, integer()).
to_map(Bag) ->
    erlang:element(2, Bag).
