-module(common@json_formatter).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/common/json_formatter.gleam").
-export([page_to_json/2]).

-file("src/common/json_formatter.gleam", 3).
-spec page_to_json(integer(), integer()) -> gleam@json:json().
page_to_json(Count, Total) ->
    gleam@json:object(
        [{<<"count"/utf8>>, gleam@json:int(Count)},
            {<<"total"/utf8>>, gleam@json:int(Total)}]
    ).
