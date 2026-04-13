-module(shared@groceries).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/shared/groceries.gleam").
-export([grocery_list_decoder/0, grocery_list_to_json/1]).
-export_type([grocery_item/0]).

-type grocery_item() :: {grocery_item, binary(), integer()}.

-file("src/shared/groceries.gleam", 8).
-spec grocery_item_decoder() -> gleam@dynamic@decode:decoder(grocery_item()).
grocery_item_decoder() ->
    gleam@dynamic@decode:field(
        <<"name"/utf8>>,
        {decoder, fun gleam@dynamic@decode:decode_string/1},
        fun(Name) ->
            gleam@dynamic@decode:field(
                <<"quantity"/utf8>>,
                {decoder, fun gleam@dynamic@decode:decode_int/1},
                fun(Quantity) ->
                    gleam@dynamic@decode:success({grocery_item, Name, Quantity})
                end
            )
        end
    ).

-file("src/shared/groceries.gleam", 14).
-spec grocery_list_decoder() -> gleam@dynamic@decode:decoder(list(grocery_item())).
grocery_list_decoder() ->
    gleam@dynamic@decode:list(grocery_item_decoder()).

-file("src/shared/groceries.gleam", 18).
-spec grocery_item_to_json(grocery_item()) -> gleam@json:json().
grocery_item_to_json(Grocery_item) ->
    {grocery_item, Name, Quantity} = Grocery_item,
    gleam@json:object(
        [{<<"name"/utf8>>, gleam@json:string(Name)},
            {<<"quantity"/utf8>>, gleam@json:int(Quantity)}]
    ).

-file("src/shared/groceries.gleam", 23).
-spec grocery_list_to_json(list(grocery_item())) -> gleam@json:json().
grocery_list_to_json(Items) ->
    gleam@json:array(Items, fun grocery_item_to_json/1).
