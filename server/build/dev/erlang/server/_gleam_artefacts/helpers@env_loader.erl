-module(helpers@env_loader).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/helpers/env_loader.gleam").
-export([load_env_file/1]).

-file("src/helpers/env_loader.gleam", 26).
-spec read_env_file(binary()) -> {ok, binary()} | {error, nil}.
read_env_file(Path) ->
    case simplifile:read(Path) of
        {ok, Content} ->
            {ok, Content};

        {error, _} ->
            {error, nil}
    end.

-file("src/helpers/env_loader.gleam", 52).
-spec remove_quotes(binary()) -> binary().
remove_quotes(Value) ->
    Has_start = gleam_stdlib:string_starts_with(Value, <<"\""/utf8>>),
    Has_end = gleam_stdlib:string_ends_with(Value, <<"\""/utf8>>),
    case {Has_start, Has_end} of
        {true, true} ->
            _pipe = gleam@string:drop_end(Value, 1),
            gleam@string:drop_start(_pipe, 1);

        {true, false} ->
            gleam@string:drop_start(Value, 1);

        {false, true} ->
            gleam@string:drop_end(Value, 1);

        {false, false} ->
            Value
    end.

-file("src/helpers/env_loader.gleam", 33).
-spec parse_line(binary()) -> {ok, {binary(), binary()}} | {error, nil}.
parse_line(Line) ->
    Line@1 = gleam@string:trim(Line),
    case {gleam@string:is_empty(Line@1),
        gleam_stdlib:string_starts_with(Line@1, <<"#"/utf8>>)} of
        {true, _} ->
            {error, nil};

        {_, true} ->
            {error, nil};

        {_, _} ->
            case gleam@string:split_once(Line@1, <<"="/utf8>>) of
                {ok, {Key, Value}} ->
                    Key@1 = gleam@string:trim(Key),
                    Value@1 = gleam@string:trim(Value),
                    Value@2 = remove_quotes(Value@1),
                    {ok, {Key@1, Value@2}};

                {error, nil} ->
                    {error, nil}
            end
    end.

-file("src/helpers/env_loader.gleam", 7).
-spec load_env_file(binary()) -> nil.
load_env_file(Path) ->
    case read_env_file(Path) of
        {ok, Content} ->
            _pipe = Content,
            _pipe@1 = gleam@string:split(_pipe, <<"\n"/utf8>>),
            gleam@list:each(_pipe@1, fun(Line) -> case parse_line(Line) of
                        {ok, {Key, Value}} ->
                            envoy_ffi:set(Key, Value),
                            gleam_stdlib:println(
                                <<"Loaded: "/utf8, Key/binary>>
                            );

                        {error, nil} ->
                            nil
                    end end);

        {error, _} ->
            gleam_stdlib:println(<<"Warning: Could not load .env file"/utf8>>)
    end.
