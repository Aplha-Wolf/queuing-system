-module(squirrel).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/squirrel.gleam").
-export([classify_file_content/1, compare_code_snippets/2, main/0]).
-export_type([mode/0, file_origin/0, check_result/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-type mode() :: generate_code | check_generated_code.

-type file_origin() :: likely_generated | empty | not_generated.

-type check_result() :: different | same.

-file("src/squirrel.gleam", 115).
-spec ensure_no_errors(
    gleam@dict:dict(binary(), {list(squirrel@internal@query:typed_query()),
        list(squirrel@internal@error:error())})
) -> {ok,
        gleam@dict:dict(binary(), list(squirrel@internal@query:typed_query()))} |
    {error, list(squirrel@internal@error:error())}.
ensure_no_errors(Generated_queries) ->
    All_errors = gleam@dict:fold(
        Generated_queries,
        [],
        fun(Errors, _, Queries_and_errors) ->
            {_, New_errors} = Queries_and_errors,
            lists:append(New_errors, Errors)
        end
    ),
    case All_errors of
        [_ | _] ->
            {error, All_errors};

        [] ->
            {ok,
                gleam@dict:map_values(
                    Generated_queries,
                    fun(_, Queries) -> erlang:element(1, Queries) end
                )}
    end.

-file("src/squirrel.gleam", 137).
-spec parse_cli_args() -> {ok, mode()} | {error, nil}.
parse_cli_args() ->
    case erlang:element(4, argv:load()) of
        [] ->
            {ok, generate_code};

        [<<"check"/utf8>>] ->
            {ok, check_generated_code};

        _ ->
            {error, nil}
    end.

-file("src/squirrel.gleam", 266).
-spec check_scheme(gleam@option:option(binary())) -> {ok, nil} | {error, nil}.
check_scheme(Scheme) ->
    case Scheme of
        {some, <<"postgres"/utf8>>} ->
            {ok, nil};

        {some, <<"postgresql"/utf8>>} ->
            {ok, nil};

        none ->
            {ok, nil};

        {some, _} ->
            {error, nil}
    end.

-file("src/squirrel.gleam", 273).
-spec parse_user_and_password_from_userinfo(gleam@option:option(binary())) -> {gleam@option:option(binary()),
    gleam@option:option(binary())}.
parse_user_and_password_from_userinfo(Userinfo) ->
    case Userinfo of
        none ->
            {none, none};

        {some, Userinfo@1} ->
            case gleam@string:split(Userinfo@1, <<":"/utf8>>) of
                [User] ->
                    {{some, User}, none};

                [User@1, Password | _] ->
                    {{some, User@1}, {some, Password}};

                _ ->
                    {none, none}
            end
    end.

-file("src/squirrel.gleam", 287).
-spec parse_database_from_path(binary()) -> gleam@option:option(binary()).
parse_database_from_path(Path) ->
    case gleam@string:split(Path, <<"/"/utf8>>) of
        [<<""/utf8>>, Database | _] ->
            {some, Database};

        _ ->
            none
    end.

-file("src/squirrel.gleam", 297).
?DOC(
    " Finds all `from/**/sql` directories and lists the full paths of the `*.sql`\n"
    " files inside each one.\n"
).
-spec walk(binary()) -> gleam@dict:dict(binary(), list(binary())).
walk(From) ->
    case filepath:base_name(From) of
        <<"sql"/utf8>> ->
            Files@1 = case simplifile_erl:read_directory(From) of
                {ok, Files} -> Files;
                _assert_fail ->
                    erlang:error(#{gleam_error => let_assert,
                                message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                file => <<?FILEPATH/utf8>>,
                                module => <<"squirrel"/utf8>>,
                                function => <<"walk"/utf8>>,
                                line => 300,
                                value => _assert_fail,
                                start => 9073,
                                'end' => 9127,
                                pattern_start => 9084,
                                pattern_end => 9093})
            end,
            Files@2 = begin
                gleam@list:filter_map(
                    Files@1,
                    fun(File) ->
                        gleam@result:'try'(
                            filepath:extension(File),
                            fun(Extension) ->
                                gleam@bool:guard(
                                    Extension /= <<"sql"/utf8>>,
                                    {error, nil},
                                    fun() ->
                                        File_name = filepath:join(From, File),
                                        case simplifile_erl:is_file(File_name) of
                                            {ok, true} ->
                                                {ok, File_name};

                                            {ok, false} ->
                                                {error, nil};

                                            {error, _} ->
                                                {error, nil}
                                        end
                                    end
                                )
                            end
                        )
                    end
                )
            end,
            maps:from_list([{From, Files@2}]);

        _ ->
            Files@4 = case simplifile_erl:read_directory(From) of
                {ok, Files@3} ->
                    Files@3;

                {error, enoent} ->
                    [];

                {error, _} ->
                    erlang:error(#{gleam_error => panic,
                            message => (<<"couldn't read directory: "/utf8,
                                From/binary>>),
                            file => <<?FILEPATH/utf8>>,
                            module => <<"squirrel"/utf8>>,
                            function => <<"walk"/utf8>>,
                            line => 318})
            end,
            Directories = begin
                gleam@list:filter_map(
                    Files@4,
                    fun(File@1) ->
                        File_name@1 = filepath:join(From, File@1),
                        case simplifile_erl:is_directory(File_name@1) of
                            {ok, true} ->
                                {ok, File_name@1};

                            {ok, false} ->
                                {error, nil};

                            {error, _} ->
                                {error, nil}
                        end
                    end
                )
            end,
            _pipe = gleam@list:map(Directories, fun walk/1),
            gleam@list:fold(_pipe, maps:new(), fun maps:merge/2)
    end.

-file("src/squirrel.gleam", 341).
?DOC(
    " Given a dict of directories and their `*.sql` files, performs code\n"
    " generation for each one, bundling all `*.sql` files under the same directory\n"
    " into a single Gleam module.\n"
).
-spec generate_queries(
    gleam@dict:dict(binary(), list(binary())),
    squirrel@internal@database@postgres:context()
) -> gleam@dict:dict(binary(), {list(squirrel@internal@query:typed_query()),
    list(squirrel@internal@error:error())}).
generate_queries(Directories, Connection) ->
    gleam@dict:map_values(
        Directories,
        fun(_, Files) ->
            {Queries, Errors} = begin
                _pipe = gleam@list:map(
                    Files,
                    fun squirrel@internal@query:from_file/1
                ),
                gleam@result:partition(_pipe)
            end,
            case squirrel@internal@database@postgres:main(Queries, Connection) of
                {error, Error} ->
                    {[], [Error | Errors]};

                {ok, {Queries@1, Type_errors}} ->
                    {Queries@1, lists:append(Errors, Type_errors)}
            end
        end
    ).

-file("src/squirrel.gleam", 401).
?DOC(false).
-spec classify_file_content(binary()) -> file_origin().
classify_file_content(Content) ->
    Likely_generated = gleam_stdlib:contains_string(
        Content,
        <<"> 🐿️ This module was generated automatically using"/utf8>>
    )
    orelse gleam_stdlib:contains_string(
        Content,
        <<"> 🐿️ This function was generated automatically using"/utf8>>
    ),
    case Likely_generated of
        true ->
            likely_generated;

        false ->
            case gleam@string:trim(Content) of
                <<""/utf8>> ->
                    empty;

                _ ->
                    not_generated
            end
    end.

-file("src/squirrel.gleam", 386).
-spec safely_overwrite(binary(), binary()) -> {ok, nil} |
    {error, squirrel@internal@error:error()}.
safely_overwrite(File, Code) ->
    case begin
        _pipe = simplifile:read(File),
        gleam@result:map(_pipe, fun classify_file_content/1)
    end of
        {ok, likely_generated} ->
            _pipe@1 = simplifile:write(File, Code),
            gleam@result:map_error(
                _pipe@1,
                fun(_capture) -> {cannot_write_to_file, File, _capture} end
            );

        {ok, empty} ->
            _pipe@1 = simplifile:write(File, Code),
            gleam@result:map_error(
                _pipe@1,
                fun(_capture) -> {cannot_write_to_file, File, _capture} end
            );

        {error, enoent} ->
            _pipe@1 = simplifile:write(File, Code),
            gleam@result:map_error(
                _pipe@1,
                fun(_capture) -> {cannot_write_to_file, File, _capture} end
            );

        {ok, not_generated} ->
            {error, {cannot_overwrite_existing_file, File}};

        {error, Reason} ->
            {error, {cannot_write_to_file, File, Reason}}
    end.

-file("src/squirrel.gleam", 443).
-spec directory_to_output_file(binary()) -> binary().
directory_to_output_file(Directory) ->
    _pipe = filepath:directory_name(Directory),
    filepath:join(_pipe, <<"sql.gleam"/utf8>>).

-file("src/squirrel.gleam", 520).
-spec compare_token_lists(
    list({glexer@token:token(), glexer:position()}),
    list({glexer@token:token(), glexer:position()})
) -> check_result().
compare_token_lists(Expected_tokens, Actual_tokens) ->
    case {Expected_tokens, Actual_tokens} of
        {[], []} ->
            same;

        {[], _} ->
            different;

        {_, []} ->
            different;

        {[{Expected_token, _} | Expected_rest],
            [{Actual_token, _} | Actual_rest]} ->
            case Expected_token =:= Actual_token of
                true ->
                    compare_token_lists(Expected_rest, Actual_rest);

                false ->
                    different
            end
    end.

-file("src/squirrel.gleam", 501).
?DOC(false).
-spec compare_code_snippets(binary(), binary()) -> check_result().
compare_code_snippets(Actual_code, Expected_code) ->
    Actual_tokens = begin
        _pipe = glexer:new(Actual_code),
        _pipe@1 = glexer:discard_comments(_pipe),
        _pipe@2 = glexer:discard_whitespace(_pipe@1),
        glexer:lex(_pipe@2)
    end,
    Expected_tokens = begin
        _pipe@3 = glexer:new(Expected_code),
        _pipe@4 = glexer:discard_comments(_pipe@3),
        _pipe@5 = glexer:discard_whitespace(_pipe@4),
        glexer:lex(_pipe@5)
    end,
    compare_token_lists(Expected_tokens, Actual_tokens).

-file("src/squirrel.gleam", 539).
-spec term_width() -> integer().
term_width() ->
    _pipe = term_size:columns(),
    _pipe@1 = gleam@result:unwrap(_pipe, 80),
    gleam@int:min(_pipe@1, 80).

-file("src/squirrel.gleam", 615).
-spec errors_to_doc(list(squirrel@internal@error:error())) -> glam@doc:document().
errors_to_doc(Errors) ->
    _pipe = gleam@list:map(Errors, fun squirrel@internal@error:to_doc/1),
    glam@doc:join(_pipe, glam@doc:lines(2)).

-file("src/squirrel.gleam", 620).
-spec report_errors(list(squirrel@internal@error:error())) -> {binary(),
    integer()}.
report_errors(Errors) ->
    Report = begin
        _pipe = errors_to_doc(Errors),
        glam@doc:to_string(_pipe, term_width())
    end,
    {Report, 1}.

-file("src/squirrel.gleam", 666).
-spec pluralise(integer(), binary(), binary()) -> binary().
pluralise(Count, Singular, Plural) ->
    case Count of
        1 ->
            Singular;

        _ ->
            Plural
    end.

-file("src/squirrel.gleam", 673).
-spec flexible_string(binary()) -> glam@doc:document().
flexible_string(String) ->
    _pipe = gleam@string:split(String, <<"\n"/utf8>>),
    _pipe@1 = gleam@list:flat_map(
        _pipe,
        fun(_capture) -> gleam@string:split(_capture, <<" "/utf8>>) end
    ),
    _pipe@2 = gleam@list:map(_pipe@1, fun glam@doc:from_string/1),
    _pipe@3 = glam@doc:join(_pipe@2, {flex_break, <<" "/utf8>>, <<""/utf8>>}),
    glam@doc:group(_pipe@3).

-file("src/squirrel.gleam", 656).
-spec text_with_header(binary(), binary()) -> glam@doc:document().
text_with_header(Header, Text) ->
    _pipe@1 = [glam@doc:from_string(Header),
        begin
            _pipe = flexible_string(Text),
            glam@doc:nest(_pipe, string:length(Header))
        end],
    _pipe@2 = glam@doc:concat(_pipe@1),
    glam@doc:group(_pipe@2).

-file("src/squirrel.gleam", 545).
-spec report_written_queries(
    gleam@dict:dict(binary(), {ok, integer()} |
        {error, squirrel@internal@error:error()})
) -> {binary(), integer()}.
report_written_queries(Directories) ->
    {Ok, Errors@1} = begin
        gleam@dict:fold(
            Directories,
            {0, []},
            fun(Acc, _, Outcome) ->
                {Generated_queries, Errors} = Acc,
                case Outcome of
                    {error, Error} ->
                        {Generated_queries, [Error | Errors]};

                    {ok, New_count} ->
                        {Generated_queries + New_count, Errors}
                end
            end
        )
    end,
    Status_code = case Errors@1 of
        [_ | _] ->
            1;

        [] ->
            0
    end,
    Report = case {Ok, Errors@1} of
        {0, [_ | _]} ->
            _pipe = errors_to_doc(Errors@1),
            glam@doc:to_string(_pipe, term_width());

        {0, []} ->
            _pipe@1 = [text_with_header(
                    <<"🐿️  "/utf8>>,
                    <<"I couldn't find any `*.sql` file to generate queries from."/utf8>>
                ),
                glam@doc:lines(2),
                flexible_string(
                    <<"Hint: I look for all `*.sql` files in any directory called `sql`
under your project's `src`, `test`, and `dev` directories."/utf8>>
                )],
            _pipe@2 = glam@doc:concat(_pipe@1),
            _pipe@3 = glam@doc:to_string(_pipe@2, term_width()),
            gleam_community@ansi:yellow(_pipe@3);

        {N, []} ->
            _pipe@4 = text_with_header(
                <<"🐿️  "/utf8>>,
                <<<<<<<<"Generated "/utf8,
                                (erlang:integer_to_binary(N))/binary>>/binary,
                            " "/utf8>>/binary,
                        (pluralise(N, <<"query"/utf8>>, <<"queries"/utf8>>))/binary>>/binary,
                    "!"/utf8>>
            ),
            _pipe@5 = glam@doc:to_string(_pipe@4, term_width()),
            gleam_community@ansi:green(_pipe@5);

        {N@1, [_ | _]} ->
            _pipe@6 = [errors_to_doc(Errors@1),
                glam@doc:lines(2),
                text_with_header(
                    <<"🥜 "/utf8>>,
                    <<<<<<<<"I could still generate "/utf8,
                                    (erlang:integer_to_binary(N@1))/binary>>/binary,
                                " "/utf8>>/binary,
                            (pluralise(
                                N@1,
                                <<"query"/utf8>>,
                                <<"queries"/utf8>>
                            ))/binary>>/binary,
                        "."/utf8>>
                )],
            _pipe@7 = glam@doc:concat(_pipe@6),
            glam@doc:to_string(_pipe@7, term_width())
    end,
    {Report, Status_code}.

-file("src/squirrel.gleam", 625).
-spec report_checked_queries(
    gleam@dict:dict(binary(), {ok, nil} |
        {error, list(squirrel@internal@error:error())})
) -> {binary(), integer()}.
report_checked_queries(Dirs) ->
    Errors@1 = begin
        gleam@dict:fold(Dirs, [], fun(All_errors, _, Result) -> case Result of
                    {error, Errors} ->
                        _pipe = Errors,
                        lists:append(_pipe, All_errors);

                    {ok, _} ->
                        All_errors
                end end)
    end,
    Status_code = case Errors@1 of
        [_ | _] ->
            1;

        [] ->
            0
    end,
    Report = case Errors@1 of
        [_ | _] ->
            _pipe@1 = gleam@list:map(
                Errors@1,
                fun squirrel@internal@error:to_doc/1
            ),
            _pipe@2 = glam@doc:join(_pipe@1, glam@doc:lines(2)),
            glam@doc:to_string(_pipe@2, term_width());

        [] ->
            _pipe@3 = text_with_header(<<"🐿️  "/utf8>>, <<"All good!"/utf8>>),
            _pipe@4 = glam@doc:to_string(_pipe@3, term_width()),
            gleam_community@ansi:green(_pipe@4)
    end,
    {Report, Status_code}.

-file("src/squirrel.gleam", 145).
-spec help_text() -> glam@doc:document().
help_text() ->
    Nesting = 4,
    Title_line = glam@doc:from_string(<<"🐿️  Squirrel "/utf8, "v4.6.0"/utf8>>),
    Usage_line = glam@doc:concat(
        [glam@doc:zero_width_string(
                gleam_community@ansi:yellow(<<"Usage: "/utf8>>)
            ),
            glam@doc:zero_width_string(
                gleam_community@ansi:green(<<"gleam run -m squirrel"/utf8>>)
            ),
            glam@doc:from_string(<<" [COMMAND]"/utf8>>)]
    ),
    Check_command = begin
        _pipe@2 = [glam@doc:from_string(<<"check  "/utf8>>),
            begin
                _pipe = <<"checks the generated code is up to date with the sql files"/utf8>>,
                _pipe@1 = flexible_string(_pipe),
                glam@doc:nest(_pipe@1, 7)
            end],
        _pipe@3 = glam@doc:concat(_pipe@2),
        glam@doc:group(_pipe@3)
    end,
    Commands = begin
        _pipe@4 = [glam@doc:zero_width_string(
                gleam_community@ansi:yellow(<<"Commands:"/utf8>>)
            ),
            glam@doc:nest(Check_command, Nesting)],
        glam@doc:join(_pipe@4, glam@doc:nest({line, 1}, Nesting))
    end,
    _pipe@5 = [Title_line, Usage_line, Commands],
    glam@doc:join(_pipe@5, glam@doc:lines(2)).

-file("src/squirrel.gleam", 370).
-spec write_queries_to_file(
    list(squirrel@internal@query:typed_query()),
    binary(),
    binary()
) -> {ok, integer()} | {error, squirrel@internal@error:error()}.
write_queries_to_file(Queries, Queries_directory, File) ->
    gleam@bool:guard(
        Queries =:= [],
        {ok, 0},
        fun() ->
            Directory = filepath:directory_name(File),
            _ = simplifile:create_directory_all(Directory),
            Code = squirrel@internal@query:generate_code(
                <<"v4.6.0"/utf8>>,
                Queries,
                Queries_directory
            ),
            _pipe = safely_overwrite(File, Code),
            gleam@result:replace(_pipe, erlang:length(Queries))
        end
    ).

-file("src/squirrel.gleam", 362).
?DOC(
    " Given the queries generated by `generate_queries`, tries to write those to\n"
    " their own file and returns a dictionary that - for each file - holds the\n"
    " number of queries that could be generated or the error that occurred trying\n"
    " to write the query.\n"
).
-spec write_queries(
    gleam@dict:dict(binary(), list(squirrel@internal@query:typed_query()))
) -> gleam@dict:dict(binary(), {ok, integer()} |
    {error, squirrel@internal@error:error()}).
write_queries(Queries) ->
    gleam@dict:map_values(
        Queries,
        fun(Directory, Queries@1) ->
            Output_file = directory_to_output_file(Directory),
            write_queries_to_file(Queries@1, Directory, Output_file)
        end
    ).

-file("src/squirrel.gleam", 488).
?DOC(
    " Checks that the given `file`'s code is the same that would be generated from\n"
    " the given `queries`.\n"
    " Returns `Same` if the code is ok, `Different` otherwise.\n"
    "\n"
    " > ⚠️ Note how this comparison doesn't take comments and whitespace into\n"
    " > account! If the only thing that changed are comments and/or formatting\n"
    " > two files will still be considered the same.\n"
).
-spec check_queries_code(list(squirrel@internal@query:typed_query()), binary()) -> check_result().
check_queries_code(Queries, Actual_code) ->
    Expected_code = squirrel@internal@query:generate_code(
        <<"v4.6.0"/utf8>>,
        Queries,
        <<"check-queries"/utf8>>
    ),
    compare_code_snippets(Actual_code, Expected_code).

-file("src/squirrel.gleam", 450).
-spec check_queries(
    gleam@dict:dict(binary(), {list(squirrel@internal@query:typed_query()),
        list(squirrel@internal@error:error())})
) -> gleam@dict:dict(binary(), {ok, nil} |
    {error, list(squirrel@internal@error:error())}).
check_queries(Queries) ->
    gleam@dict:map_values(
        Queries,
        fun(Directory, _use1) ->
            {Queries@1, Errors} = _use1,
            case Errors of
                [_ | _] ->
                    {error, Errors};

                [] ->
                    Output_file = directory_to_output_file(Directory),
                    case simplifile:read(Output_file) of
                        {error, Reason} ->
                            {error, [{cannot_read_file, Output_file, Reason}]};

                        {ok, Actual_code} ->
                            case check_queries_code(Queries@1, Actual_code) of
                                different ->
                                    {error, [{outdated_file, Output_file}]};

                                same ->
                                    {ok, nil}
                            end
                    end
            end
        end
    ).

-file("src/squirrel.gleam", 210).
?DOC(
    " Creates a `ConnectionOptions` reading values from env variables and falling\n"
    " back to some defaults if any required one is not set.\n"
).
-spec connection_options_from_variables() -> squirrel@internal@database@postgres:connection_options().
connection_options_from_variables() ->
    Host = begin
        _pipe = envoy_ffi:get(<<"PGHOST"/utf8>>),
        gleam@result:unwrap(_pipe, <<"localhost"/utf8>>)
    end,
    User = begin
        _pipe@1 = envoy_ffi:get(<<"PGUSER"/utf8>>),
        gleam@result:unwrap(_pipe@1, <<"postgres"/utf8>>)
    end,
    Password = begin
        _pipe@2 = envoy_ffi:get(<<"PGPASSWORD"/utf8>>),
        gleam@result:unwrap(_pipe@2, <<""/utf8>>)
    end,
    Database = begin
        _pipe@3 = envoy_ffi:get(<<"PGDATABASE"/utf8>>),
        _pipe@4 = gleam@result:'or'(_pipe@3, squirrel@internal@project:name()),
        gleam@result:unwrap(_pipe@4, <<"database"/utf8>>)
    end,
    Port = begin
        _pipe@5 = envoy_ffi:get(<<"PGPORT"/utf8>>),
        _pipe@6 = gleam@result:'try'(_pipe@5, fun gleam_stdlib:parse_int/1),
        gleam@result:unwrap(_pipe@6, 5432)
    end,
    Timeout_seconds = begin
        _pipe@7 = envoy_ffi:get(<<"PGCONNECT_TIMEOUT"/utf8>>),
        _pipe@8 = gleam@result:'try'(_pipe@7, fun gleam_stdlib:parse_int/1),
        gleam@result:unwrap(_pipe@8, 5)
    end,
    {connection_options, Host, Port, User, Password, Database, Timeout_seconds}.

-file("src/squirrel.gleam", 240).
?DOC(
    " Parses a connection string into a `ConnectionOptions` failing if it has an\n"
    " invalid format instead of silently producing a default one.\n"
).
-spec parse_connection_url(binary()) -> {ok,
        squirrel@internal@database@postgres:connection_options()} |
    {error, nil}.
parse_connection_url(Raw) ->
    gleam@result:'try'(
        gleam_stdlib:uri_parse(Raw),
        fun(Uri) ->
            {uri, Scheme, Userinfo, Host, Port, Path, Query, _} = Uri,
            gleam@result:'try'(case Query of
                    none ->
                        {ok, []};

                    {some, Parameters} ->
                        gleam_stdlib:parse_query(Parameters)
                end, fun(Parameters@1) ->
                    gleam@result:'try'(
                        check_scheme(Scheme),
                        fun(_) ->
                            {User, Password} = parse_user_and_password_from_userinfo(
                                Userinfo
                            ),
                            Database = parse_database_from_path(Path),
                            gleam@result:'try'(
                                case gleam@list:key_find(
                                    Parameters@1,
                                    <<"connect_timeout"/utf8>>
                                ) of
                                    {error, _} ->
                                        {ok, 5};

                                    {ok, Timeout} ->
                                        gleam_stdlib:parse_int(Timeout)
                                end,
                                fun(Timeout@1) ->
                                    {ok,
                                        {connection_options,
                                            begin
                                                _pipe = Host,
                                                gleam@option:unwrap(
                                                    _pipe,
                                                    <<"localhost"/utf8>>
                                                )
                                            end,
                                            begin
                                                _pipe@1 = Port,
                                                gleam@option:unwrap(
                                                    _pipe@1,
                                                    5432
                                                )
                                            end,
                                            begin
                                                _pipe@2 = User,
                                                gleam@option:unwrap(
                                                    _pipe@2,
                                                    <<"postgres"/utf8>>
                                                )
                                            end,
                                            begin
                                                _pipe@3 = Password,
                                                gleam@option:unwrap(
                                                    _pipe@3,
                                                    <<""/utf8>>
                                                )
                                            end,
                                            begin
                                                _pipe@4 = Database,
                                                gleam@option:unwrap(
                                                    _pipe@4,
                                                    <<"database"/utf8>>
                                                )
                                            end,
                                            Timeout@1}}
                                end
                            )
                        end
                    )
                end)
        end
    ).

-file("src/squirrel.gleam", 186).
?DOC(
    " Returns the connection options to use to connect to the database.\n"
    " It first tries to read and parse a `DATABASE_URL` env variable (failing if\n"
    " it has an invalid format).\n"
    "\n"
    " If the `DATABASE_URL` variable is not set, it uses the Postgres env vars and\n"
    " some defaults if any of those are not set.\n"
).
-spec connection_options() -> {ok,
        squirrel@internal@database@postgres:connection_options()} |
    {error, squirrel@internal@error:error()}.
connection_options() ->
    case envoy_ffi:get(<<"DATABASE_URL"/utf8>>) of
        {ok, Url} ->
            _pipe = parse_connection_url(Url),
            gleam@result:replace_error(_pipe, {invalid_connection_string, Url});

        {error, _} ->
            {ok, connection_options_from_variables()}
    end.

-file("src/squirrel.gleam", 65).
?DOC(
    " 🐿️ Performs code generation for your Gleam project.\n"
    "\n"
    " `squirrel` is not configurable and will discover the queries to generate\n"
    " code for by relying on a conventional project's structure:\n"
    " - `squirrel` first looks for all directories called `sql` under the `src`\n"
    "   directory of your Gleam project, and reads all the `*.sql` files in there\n"
    "   (in glob terms `src/**/sql/*.sql`).\n"
    " - Each `*.sql` file _must contain a single query_ as it is turned into a\n"
    "   Gleam function with the same name.\n"
    " - All functions coming from the same `sql` directory will be grouped under\n"
    "   a Gleam file called `sql.gleam` at the same level: given a `src/$PATH/sql`\n"
    "   directory, you'll end up with a generated `src/$PATH/sql.gleam` file.\n"
    "\n"
    " > ⚠️ In order to generate type safe code, `squirrel` has to connect\n"
    " > to your Postgres database. To know what host, user, etc. values to use\n"
    " > when connecting, it will read the `DATABASE_URL` env variable that has to\n"
    " > be a valid connection string with the following format:\n"
    " >\n"
    " > ```txt\n"
    " > postgres://user:password@host:port/database?connect_timeout=seconds\n"
    " > ```\n"
    " >\n"
    " > If a `DATABASE_URL` variable is not set, Squirrel will instead read your\n"
    " > [Postgres env variables](https://www.postgresql.org/docs/current/libpq-envars.html)\n"
    " > and use the following defaults if one is not set:\n"
    " > - `PGHOST`: `\"localhost\"`\n"
    " > - `PGPORT`: `5432`\n"
    " > - `PGUSER`: `\"postgres\"`\n"
    " > - `PGDATABASE`: the name of your Gleam project\n"
    " > - `PGPASSWORD`: `\"\"`\n"
    " > - `PGCONNECT_TIMEOUT`: `5` seconds\n"
    "\n"
    " > ⚠️ The generated code relies on the\n"
    " > [`pog`](https://hexdocs.pm/pog/) package to work, so make sure to add\n"
    " > that dependency to your project.\n"
).
-spec main() -> nil.
main() ->
    case parse_cli_args() of
        {error, nil} ->
            _pipe = help_text(),
            _pipe@1 = glam@doc:to_string(_pipe, term_width()),
            gleam_stdlib:println(_pipe@1),
            squirrel_ffi:exit(1);

        {ok, Mode} ->
            case gleam@result:'try'(
                connection_options(),
                fun squirrel@internal@database@postgres:connect_and_authenticate/1
            ) of
                {error, Error} ->
                    _pipe@2 = squirrel@internal@error:to_doc(Error),
                    _pipe@3 = glam@doc:to_string(_pipe@2, term_width()),
                    gleam_stdlib:println(_pipe@3),
                    squirrel_ffi:exit(1);

                {ok, Connection} ->
                    Generated_queries = begin
                        _pipe@4 = walk(squirrel@internal@project:src()),
                        _pipe@5 = maps:merge(
                            _pipe@4,
                            walk(squirrel@internal@project:test_())
                        ),
                        _pipe@6 = maps:merge(
                            _pipe@5,
                            walk(squirrel@internal@project:dev())
                        ),
                        generate_queries(_pipe@6, Connection)
                    end,
                    {Report, Status_code} = case Mode of
                        generate_code ->
                            case ensure_no_errors(Generated_queries) of
                                {error, Errors} ->
                                    report_errors(Errors);

                                {ok, Generated_queries@1} ->
                                    _pipe@7 = Generated_queries@1,
                                    _pipe@8 = write_queries(_pipe@7),
                                    report_written_queries(_pipe@8)
                            end;

                        check_generated_code ->
                            _pipe@9 = Generated_queries,
                            _pipe@10 = check_queries(_pipe@9),
                            report_checked_queries(_pipe@10)
                    end,
                    gleam_stdlib:println(Report),
                    squirrel_ffi:exit(Status_code)
            end
    end.
