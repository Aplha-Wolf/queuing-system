-module(route@terminal@service).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/route/terminal/service.gleam").
-export([list_all_terminals/1, add_terminal/3, update_terminal/5, delete_terminal/2, find_terminal_by_id/2, find_terminal_by_name/2, find_terminal_by_code/2, terminal_error_to_json/1, terminal_list_to_json/1, add_terminal_result_to_json/1, update_terminal_result_to_json/1, delete_terminal_result_to_json/1]).
-export_type([terminal_list/0, add_terminal_result/0, update_terminal_result/0, delete_terminal_result/0, terminal_error/0]).

-type terminal_list() :: {terminal_list,
        integer(),
        list(shared@terminal:terminal())}.

-type add_terminal_result() :: {add_terminal_result, integer()}.

-type update_terminal_result() :: {update_terminal_result, binary()}.

-type delete_terminal_result() :: {delete_terminal_result, binary()}.

-type terminal_error() :: {database_error, gleam@json:json()} |
    not_found |
    insert_failed.

-file("src/route/terminal/service.gleam", 58).
-spec listallterminals_to_terminal(route@terminal@sql:list_all_terminals_row()) -> shared@terminal:terminal().
listallterminals_to_terminal(Terminal) ->
    {terminal,
        erlang:element(2, Terminal),
        erlang:element(6, Terminal),
        erlang:element(3, Terminal),
        erlang:element(4, Terminal),
        erlang:element(5, Terminal)}.

-file("src/route/terminal/service.gleam", 44).
-spec listallterminalsrow_to_terminals(
    list(route@terminal@sql:list_all_terminals_row()),
    list(shared@terminal:terminal())
) -> list(shared@terminal:terminal()).
listallterminalsrow_to_terminals(In, Out) ->
    case In of
        [] ->
            Out;

        [X | Y] ->
            listallterminalsrow_to_terminals(
                Y,
                lists:append(Out, [listallterminals_to_terminal(X)])
            )
    end.

-file("src/route/terminal/service.gleam", 30).
-spec list_all_terminals(pog:connection()) -> {ok, terminal_list()} |
    {error, terminal_error()}.
list_all_terminals(Db) ->
    case route@terminal@sql:list_all_terminals(Db) of
        {ok, X} ->
            {ok,
                {terminal_list,
                    erlang:element(2, X),
                    listallterminalsrow_to_terminals(erlang:element(3, X), [])}};

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}}
    end.

-file("src/route/terminal/service.gleam", 85).
-spec addterminalrows_to_result(list(route@terminal@sql:add_terminal_row())) -> add_terminal_result().
addterminalrows_to_result(Rows) ->
    Row@1 = case gleam@list:first(Rows) of
        {ok, Row} -> Row;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"route/terminal/service"/utf8>>,
                        function => <<"addterminalrows_to_result"/utf8>>,
                        line => 88,
                        value => _assert_fail,
                        start => 2038,
                        'end' => 2075,
                        pattern_start => 2049,
                        pattern_end => 2056})
    end,
    {add_terminal_result, erlang:element(2, Row@1)}.

-file("src/route/terminal/service.gleam", 70).
-spec add_terminal(pog:connection(), binary(), binary()) -> {ok,
        add_terminal_result()} |
    {error, terminal_error()}.
add_terminal(Db, Code, Name) ->
    case route@terminal@sql:add_terminal(Db, Code, Name) of
        {ok, Ret} ->
            case erlang:element(2, Ret) > 0 of
                true ->
                    {ok, addterminalrows_to_result(erlang:element(3, Ret))};

                false ->
                    {error, insert_failed}
            end;

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}}
    end.

-file("src/route/terminal/service.gleam", 92).
-spec update_terminal(
    pog:connection(),
    binary(),
    binary(),
    boolean(),
    integer()
) -> {ok, update_terminal_result()} | {error, terminal_error()}.
update_terminal(Db, Code, Name, Active, Id) ->
    case route@terminal@sql:update_teminal(Db, Code, Name, Active, Id) of
        {ok, _} ->
            {ok, {update_terminal_result, <<"Successfully updated!"/utf8>>}};

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}}
    end.

-file("src/route/terminal/service.gleam", 107).
-spec delete_terminal(pog:connection(), integer()) -> {ok,
        delete_terminal_result()} |
    {error, terminal_error()}.
delete_terminal(Db, Id) ->
    case route@terminal@sql:find_terminal_by_id(Db, Id) of
        {ok, X} ->
            case erlang:element(2, X) of
                0 ->
                    {error, not_found};

                _ ->
                    case route@terminal@sql:delete_terminal(Db, Id) of
                        {ok, _} ->
                            {ok,
                                {delete_terminal_result,
                                    <<"Successfully deleted!"/utf8>>}};

                        {error, Err} ->
                            {error,
                                {database_error,
                                    helpers@sql:pgo_queryerror_tojson(Err)}}
                    end
            end;

        {error, Err@1} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err@1)}}
    end.

-file("src/route/terminal/service.gleam", 143).
-spec findterminalbyidrow_to_terminal(
    list(route@terminal@sql:find_terminal_by_id_row())
) -> shared@terminal:terminal().
findterminalbyidrow_to_terminal(Terminals) ->
    Row@1 = case gleam@list:first(Terminals) of
        {ok, Row} -> Row;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"route/terminal/service"/utf8>>,
                        function => <<"findterminalbyidrow_to_terminal"/utf8>>,
                        line => 146,
                        value => _assert_fail,
                        start => 3623,
                        'end' => 3665,
                        pattern_start => 3634,
                        pattern_end => 3641})
    end,
    {terminal,
        erlang:element(2, Row@1),
        erlang:element(6, Row@1),
        erlang:element(3, Row@1),
        erlang:element(4, Row@1),
        erlang:element(5, Row@1)}.

-file("src/route/terminal/service.gleam", 128).
-spec find_terminal_by_id(pog:connection(), integer()) -> {ok,
        shared@terminal:terminal()} |
    {error, terminal_error()}.
find_terminal_by_id(Db, Id) ->
    case route@terminal@sql:find_terminal_by_id(Db, Id) of
        {ok, X} ->
            case erlang:element(2, X) of
                0 ->
                    {error, not_found};

                _ ->
                    {ok, findterminalbyidrow_to_terminal(erlang:element(3, X))}
            end;

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}}
    end.

-file("src/route/terminal/service.gleam", 172).
-spec findterminalbynamerow_to_terminal(
    list(route@terminal@sql:find_terminal_by_name_row())
) -> shared@terminal:terminal().
findterminalbynamerow_to_terminal(Terminals) ->
    Row@1 = case gleam@list:first(Terminals) of
        {ok, Row} -> Row;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"route/terminal/service"/utf8>>,
                        function => <<"findterminalbynamerow_to_terminal"/utf8>>,
                        line => 175,
                        value => _assert_fail,
                        start => 4340,
                        'end' => 4382,
                        pattern_start => 4351,
                        pattern_end => 4358})
    end,
    {terminal,
        erlang:element(2, Row@1),
        erlang:element(6, Row@1),
        erlang:element(3, Row@1),
        erlang:element(4, Row@1),
        erlang:element(5, Row@1)}.

-file("src/route/terminal/service.gleam", 157).
-spec find_terminal_by_name(pog:connection(), binary()) -> {ok,
        shared@terminal:terminal()} |
    {error, terminal_error()}.
find_terminal_by_name(Db, Name) ->
    case route@terminal@sql:find_terminal_by_name(Db, Name) of
        {ok, X} ->
            case erlang:element(2, X) of
                0 ->
                    {error, not_found};

                _ ->
                    {ok,
                        findterminalbynamerow_to_terminal(erlang:element(3, X))}
            end;

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}}
    end.

-file("src/route/terminal/service.gleam", 201).
-spec findterminalbycoderow_to_terminal(
    list(route@terminal@sql:find_terminal_by_code_row())
) -> shared@terminal:terminal().
findterminalbycoderow_to_terminal(Terminals) ->
    Row@1 = case gleam@list:first(Terminals) of
        {ok, Row} -> Row;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"route/terminal/service"/utf8>>,
                        function => <<"findterminalbycoderow_to_terminal"/utf8>>,
                        line => 204,
                        value => _assert_fail,
                        start => 5057,
                        'end' => 5099,
                        pattern_start => 5068,
                        pattern_end => 5075})
    end,
    {terminal,
        erlang:element(2, Row@1),
        erlang:element(6, Row@1),
        erlang:element(3, Row@1),
        erlang:element(4, Row@1),
        erlang:element(5, Row@1)}.

-file("src/route/terminal/service.gleam", 186).
-spec find_terminal_by_code(pog:connection(), binary()) -> {ok,
        shared@terminal:terminal()} |
    {error, terminal_error()}.
find_terminal_by_code(Db, Code) ->
    case route@terminal@sql:find_terminal_by_code(Db, Code) of
        {ok, X} ->
            case erlang:element(2, X) of
                0 ->
                    {error, not_found};

                _ ->
                    {ok,
                        findterminalbycoderow_to_terminal(erlang:element(3, X))}
            end;

        {error, Err} ->
            {error, {database_error, helpers@sql:pgo_queryerror_tojson(Err)}}
    end.

-file("src/route/terminal/service.gleam", 215).
-spec terminal_error_to_json(terminal_error()) -> gleam@json:json().
terminal_error_to_json(Error) ->
    case Error of
        {database_error, E} ->
            E;

        not_found ->
            gleam@json:object(
                [{<<"message"/utf8>>,
                        gleam@json:string(<<"Terminal not found"/utf8>>)}]
            );

        insert_failed ->
            gleam@json:object(
                [{<<"error"/utf8>>,
                        gleam@json:string(<<"Insert failed!"/utf8>>)}]
            )
    end.

-file("src/route/terminal/service.gleam", 223).
-spec terminal_list_to_json(terminal_list()) -> gleam@json:json().
terminal_list_to_json(List) ->
    gleam@json:object(
        [{<<"count"/utf8>>, gleam@json:int(erlang:element(2, List))},
            {<<"terminals"/utf8>>,
                gleam@json:preprocessed_array(
                    gleam@list:map(
                        erlang:element(3, List),
                        fun(T) -> shared@terminal:to_json(T) end
                    )
                )}]
    ).

-file("src/route/terminal/service.gleam", 235).
-spec add_terminal_result_to_json(add_terminal_result()) -> gleam@json:json().
add_terminal_result_to_json(Result) ->
    gleam@json:object(
        [{<<"insert_id"/utf8>>, gleam@json:int(erlang:element(2, Result))}]
    ).

-file("src/route/terminal/service.gleam", 239).
-spec update_terminal_result_to_json(update_terminal_result()) -> gleam@json:json().
update_terminal_result_to_json(Result) ->
    gleam@json:object(
        [{<<"message"/utf8>>, gleam@json:string(erlang:element(2, Result))}]
    ).

-file("src/route/terminal/service.gleam", 243).
-spec delete_terminal_result_to_json(delete_terminal_result()) -> gleam@json:json().
delete_terminal_result_to_json(Result) ->
    gleam@json:object(
        [{<<"message"/utf8>>, gleam@json:string(erlang:element(2, Result))}]
    ).
