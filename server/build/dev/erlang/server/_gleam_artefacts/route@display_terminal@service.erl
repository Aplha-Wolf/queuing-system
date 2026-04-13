-module(route@display_terminal@service).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/display_terminal/service.gleam").
-export([get_display_terminals/3, display_terminal_list_to_json/1, display_terminal_error_to_json/1]).
-export_type([display_terminal_error/0]).

-type display_terminal_error() :: {database_error, gleam@json:json()}.

-file("src/route/display_terminal/service.gleam", 37).
-spec getdisplayterminalsrow_to_displayterminal(
    route@display_terminal@sql:get_display_terminals_row()
) -> shared@display_terminal:display_terminal().
getdisplayterminalsrow_to_displayterminal(Terminal) ->
    {display_terminal,
        erlang:element(2, Terminal),
        erlang:element(3, Terminal),
        erlang:element(4, Terminal),
        erlang:element(5, Terminal)}.

-file("src/route/display_terminal/service.gleam", 23).
-spec listaldisplayallterminalsrow_to_displayterminals(
    list(route@display_terminal@sql:get_display_terminals_row()),
    list(shared@display_terminal:display_terminal())
) -> list(shared@display_terminal:display_terminal()).
listaldisplayallterminalsrow_to_displayterminals(In, Out) ->
    case In of
        [] ->
            Out;

        [X | Y] ->
            listaldisplayallterminalsrow_to_displayterminals(
                Y,
                lists:append(
                    Out,
                    [getdisplayterminalsrow_to_displayterminal(X)]
                )
            )
    end.

-file("src/route/display_terminal/service.gleam", 12).
-spec get_display_terminals(pog:connection(), integer(), integer()) -> {ok,
        list(shared@display_terminal:display_terminal())} |
    {error, display_terminal_error()}.
get_display_terminals(Db, Id, Limit) ->
    case route@display_terminal@sql:get_display_terminals(Db, Id, Limit) of
        {ok, X} ->
            {ok,
                listaldisplayallterminalsrow_to_displayterminals(
                    erlang:element(3, X),
                    []
                )};

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}}
    end.

-file("src/route/display_terminal/service.gleam", 48).
-spec display_terminal_list_to_json(
    list(shared@display_terminal:display_terminal())
) -> gleam@json:json().
display_terminal_list_to_json(Terminals) ->
    gleam@json:preprocessed_array(
        gleam@list:map(
            Terminals,
            fun(T) -> shared@display_terminal:to_json(T) end
        )
    ).

-file("src/route/display_terminal/service.gleam", 56).
-spec display_terminal_error_to_json(display_terminal_error()) -> gleam@json:json().
display_terminal_error_to_json(Error) ->
    case Error of
        {database_error, E} ->
            E
    end.
