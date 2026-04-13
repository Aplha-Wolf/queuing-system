-module(squirrel@internal@error).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/squirrel/internal/error.gleam").
-export([to_doc/1]).
-export_type([error/0, value_identifier_error/0, type_identifier_error/0, enum_error/0, pointer/0, pointer_kind/0, printable_error/0, paragraph/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-type error() :: {pg_cannot_establish_tcp_connection,
        binary(),
        integer(),
        mug:connect_error()} |
    {pg_invalid_user_database, binary(), binary()} |
    {pg_unexpected_auth_method_message, binary(), binary()} |
    {pg_invalid_password, binary()} |
    {pg_unexpected_cleartext_auth_message, binary(), binary()} |
    {pg_unexpected_sha256_auth_message, binary(), binary()} |
    pg_invalid_sha256_server_proof |
    {pg_unsupported_authentication, binary()} |
    {pg_cannot_send_message, binary()} |
    {pg_cannot_decode_received_message, binary()} |
    {pg_cannot_receive_message, binary()} |
    {pg_cannot_describe_query, binary(), binary(), binary(), binary()} |
    {pg_permission_denied, binary(), binary()} |
    {pg_cannot_explain_query, binary(), binary(), binary(), binary()} |
    {invalid_connection_string, binary()} |
    {cannot_read_file, binary(), simplifile:file_error()} |
    {cannot_write_to_file, binary(), simplifile:file_error()} |
    {query_file_has_invalid_name,
        binary(),
        gleam@option:option(binary()),
        value_identifier_error()} |
    {query_has_invalid_column,
        binary(),
        binary(),
        gleam@option:option(binary()),
        binary(),
        integer(),
        value_identifier_error()} |
    {query_has_unsupported_type,
        binary(),
        binary(),
        binary(),
        integer(),
        binary()} |
    {query_has_invalid_enum,
        binary(),
        binary(),
        integer(),
        binary(),
        enum_error()} |
    {cannot_parse_query,
        binary(),
        binary(),
        binary(),
        integer(),
        gleam@option:option(binary()),
        gleam@option:option(pointer()),
        gleam@option:option(binary()),
        gleam@option:option(binary())} |
    {query_returns_multiple_values_with_the_same_name,
        binary(),
        binary(),
        integer(),
        list(binary())} |
    {cannot_parse_plan_for_query, binary(), gleam@json:decode_error()} |
    postgres_version_is_too_old |
    {postgres_version_has_invalid_format, bitstring()} |
    {outdated_file, binary()} |
    {cannot_overwrite_existing_file, binary()}.

-type value_identifier_error() :: {value_contains_invalid_grapheme,
        integer(),
        binary()} |
    value_is_empty.

-type type_identifier_error() :: {type_contains_invalid_grapheme,
        integer(),
        binary()} |
    type_is_empty.

-type enum_error() :: enum_with_no_variants |
    {invalid_enum_name, binary()} |
    {invalid_enum_variants, list(binary())}.

-type pointer() :: {pointer, pointer_kind(), binary()}.

-type pointer_kind() :: {name, binary()} | {byte_index, integer()}.

-type printable_error() :: {printable_error,
        binary(),
        list(paragraph()),
        gleam@option:option(binary()),
        gleam@option:option(binary()),
        gleam@option:option(binary())}.

-type paragraph() :: {simple, binary()} |
    {code, binary(), binary(), gleam@option:option(pointer()), integer()}.

-file("src/squirrel/internal/error.gleam", 672).
?DOC(false).
-spec style_file(binary()) -> binary().
style_file(File) ->
    gleam_community@ansi:underline(File).

-file("src/squirrel/internal/error.gleam", 676).
?DOC(false).
-spec style_inline_code(binary()) -> binary().
style_inline_code(Code) ->
    <<<<"`"/utf8, Code/binary>>/binary, "`"/utf8>>.

-file("src/squirrel/internal/error.gleam", 680).
?DOC(false).
-spec style_link(binary()) -> binary().
style_link(Link) ->
    gleam_community@ansi:underline(Link).

-file("src/squirrel/internal/error.gleam", 710).
?DOC(false).
-spec printable_error(binary()) -> printable_error().
printable_error(Title) ->
    {printable_error, Title, [], none, none, none}.

-file("src/squirrel/internal/error.gleam", 720).
?DOC(false).
-spec add_paragraph(printable_error(), binary()) -> printable_error().
add_paragraph(Error, String) ->
    {printable_error,
        erlang:element(2, Error),
        lists:append(erlang:element(3, Error), [{simple, String}]),
        erlang:element(4, Error),
        erlang:element(5, Error),
        erlang:element(6, Error)}.

-file("src/squirrel/internal/error.gleam", 724).
?DOC(false).
-spec add_code_paragraph(
    printable_error(),
    binary(),
    binary(),
    gleam@option:option(pointer()),
    integer()
) -> printable_error().
add_code_paragraph(Error, File, Content, Point, Starting_line) ->
    {printable_error,
        erlang:element(2, Error),
        lists:append(
            erlang:element(3, Error),
            [{code, File, Content, Point, Starting_line}]
        ),
        erlang:element(4, Error),
        erlang:element(5, Error),
        erlang:element(6, Error)}.

-file("src/squirrel/internal/error.gleam", 741).
?DOC(false).
-spec report_bug(printable_error(), binary()) -> printable_error().
report_bug(Error, Report_bug) ->
    {printable_error,
        erlang:element(2, Error),
        erlang:element(3, Error),
        {some, Report_bug},
        erlang:element(5, Error),
        erlang:element(6, Error)}.

-file("src/squirrel/internal/error.gleam", 747).
?DOC(false).
-spec hint(printable_error(), binary()) -> printable_error().
hint(Error, Hint) ->
    {printable_error,
        erlang:element(2, Error),
        erlang:element(3, Error),
        erlang:element(4, Error),
        erlang:element(5, Error),
        {some, Hint}}.

-file("src/squirrel/internal/error.gleam", 753).
?DOC(false).
-spec maybe_hint(printable_error(), gleam@option:option(binary())) -> printable_error().
maybe_hint(Error, Hint) ->
    {printable_error,
        erlang:element(2, Error),
        erlang:element(3, Error),
        erlang:element(4, Error),
        erlang:element(5, Error),
        Hint}.

-file("src/squirrel/internal/error.gleam", 761).
?DOC(false).
-spec call_to_action(printable_error(), binary()) -> printable_error().
call_to_action(Error, Wanted) ->
    {printable_error,
        erlang:element(2, Error),
        erlang:element(3, Error),
        erlang:element(4, Error),
        {some, Wanted},
        erlang:element(6, Error)}.

-file("src/squirrel/internal/error.gleam", 781).
?DOC(false).
-spec title_doc(binary()) -> glam@doc:document().
title_doc(Title) ->
    glam@doc:from_string(
        gleam_community@ansi:red(
            <<(gleam_community@ansi:bold(<<"Error: "/utf8>>))/binary,
                Title/binary>>
        )
    ).

-file("src/squirrel/internal/error.gleam", 861).
?DOC(false).
-spec digits_loop(integer(), list(integer())) -> list(integer()).
digits_loop(Int, Acc) ->
    case Int < 10 of
        true ->
            [Int | Acc];

        false ->
            digits_loop(Int div 10, [Int rem 10 | Acc])
    end.

-file("src/squirrel/internal/error.gleam", 857).
?DOC(false).
-spec digits(integer()) -> list(integer()).
digits(Int) ->
    digits_loop(gleam@int:absolute_value(Int), []).

-file("src/squirrel/internal/error.gleam", 898).
?DOC(false).
-spec find_name_span(binary(), integer(), binary(), integer(), integer()) -> {ok,
        {integer(), integer(), integer()}} |
    {error, nil}.
find_name_span(Name, Name_len, String, Row, Col) ->
    case gleam_stdlib:string_starts_with(String, Name) of
        true ->
            {ok, {Row, Col, (Col + Name_len) - 1}};

        false ->
            case gleam_stdlib:string_pop_grapheme(String) of
                {ok, {<<"\n"/utf8>>, Rest}} ->
                    find_name_span(Name, Name_len, Rest, Row + 1, 0);

                {ok, {_, Rest@1}} ->
                    find_name_span(Name, Name_len, Rest@1, Row, Col + 1);

                {error, _} ->
                    {error, nil}
            end
    end.

-file("src/squirrel/internal/error.gleam", 916).
?DOC(false).
-spec find_byte_span(integer(), binary(), integer(), integer()) -> {ok,
        {integer(), integer(), integer()}} |
    {error, nil}.
find_byte_span(Position, String, Row, Col) ->
    case Position of
        0 ->
            {ok, {Row, Col, Col}};

        N ->
            case gleam_stdlib:string_pop_grapheme(String) of
                {ok, {<<"\n"/utf8>>, Rest}} ->
                    find_byte_span(N - 1, Rest, Row + 1, 0);

                {ok, {_, Rest@1}} ->
                    find_byte_span(N - 1, Rest@1, Row, Col + 1);

                {error, _} ->
                    {error, nil}
            end
    end.

-file("src/squirrel/internal/error.gleam", 891).
?DOC(false).
-spec find_span(pointer_kind(), binary()) -> {ok,
        {integer(), integer(), integer()}} |
    {error, nil}.
find_span(Kind, String) ->
    case Kind of
        {name, Name} ->
            find_name_span(Name, string:length(Name), String, 0, 0);

        {byte_index, N} ->
            find_byte_span(N - 1, String, 0, 0)
    end.

-file("src/squirrel/internal/error.gleam", 990).
?DOC(false).
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

-file("src/squirrel/internal/error.gleam", 868).
?DOC(false).
-spec pointer_doc(pointer(), binary()) -> {ok,
        {integer(), integer(), glam@doc:document()}} |
    {error, nil}.
pointer_doc(Pointer, Content) ->
    {pointer, Kind, Message} = Pointer,
    gleam@result:'try'(
        find_span(Kind, Content),
        fun(_use0) ->
            {Line, From, To} = _use0,
            Width = (To - From) + 1,
            Doc = begin
                _pipe@1 = [glam@doc:zero_width_string(<<"\x{001B}[31m"/utf8>>),
                    glam@doc:from_string(
                        <<"┬"/utf8,
                            (gleam@string:repeat(<<"─"/utf8>>, Width - 1))/binary>>
                    ),
                    {line, 1},
                    glam@doc:from_string(<<"╰─ "/utf8>>),
                    begin
                        _pipe = flexible_string(Message),
                        glam@doc:nest(_pipe, 3)
                    end,
                    glam@doc:zero_width_string(<<"\x{001B}[0m"/utf8>>)],
                _pipe@2 = glam@doc:concat(_pipe@1),
                glam@doc:group(_pipe@2)
            end,
            {ok, {Line, From, Doc}}
        end
    ).

-file("src/squirrel/internal/error.gleam", 977).
?DOC(false).
-spec call_to_action_doc(binary()) -> glam@doc:document().
call_to_action_doc(Wanted) ->
    flexible_string(
        <<<<<<"If you would like for "/utf8, Wanted/binary>>/binary,
                ", please open an issue at "/utf8>>/binary,
            (style_link(
                <<"https://github.com/giacomocavalieri/squirrel/issues/new"/utf8>>
            ))/binary>>
    ).

-file("src/squirrel/internal/error.gleam", 986).
?DOC(false).
-spec hint_doc(binary()) -> glam@doc:document().
hint_doc(Hint) ->
    flexible_string(<<"Hint: "/utf8, Hint/binary>>).

-file("src/squirrel/internal/error.gleam", 998).
?DOC(false).
-spec option_to_doc(gleam@option:option(SRG), fun((SRG) -> glam@doc:document())) -> glam@doc:document().
option_to_doc(Option, Fun) ->
    case Option of
        {some, A} ->
            Fun(A);

        none ->
            {concat, []}
    end.

-file("src/squirrel/internal/error.gleam", 963).
?DOC(false).
-spec report_bug_doc(binary()) -> glam@doc:document().
report_bug_doc(Additional_info) ->
    _pipe@1 = [flexible_string(
            <<<<"Please open an issue at "/utf8,
                    (style_link(
                        <<"https://github.com/giacomocavalieri/squirrel/issues/new"/utf8>>
                    ))/binary>>/binary,
                " with some details about what you where doing, including the following message:"/utf8>>
        ),
        begin
            _pipe = {line, 1},
            glam@doc:nest(_pipe, 2)
        end,
        glam@doc:from_string(Additional_info)],
    _pipe@2 = glam@doc:concat(_pipe@1),
    glam@doc:group(_pipe@2).

-file("src/squirrel/internal/error.gleam", 942).
?DOC(false).
-spec syntax_highlight(binary()) -> binary().
syntax_highlight(Content) ->
    Keywords = gleam@string:join(
        [<<"and"/utf8>>,
            <<"any"/utf8>>,
            <<"as"/utf8>>,
            <<"asc"/utf8>>,
            <<"begin"/utf8>>,
            <<"between"/utf8>>,
            <<"by"/utf8>>,
            <<"case"/utf8>>,
            <<"commit"/utf8>>,
            <<"conflict"/utf8>>,
            <<"constraint"/utf8>>,
            <<"count"/utf8>>,
            <<"desc"/utf8>>,
            <<"distinct"/utf8>>,
            <<"do"/utf8>>,
            <<"drop"/utf8>>,
            <<"else"/utf8>>,
            <<"end"/utf8>>,
            <<"exists"/utf8>>,
            <<"from"/utf8>>,
            <<"full"/utf8>>,
            <<"group"/utf8>>,
            <<"having"/utf8>>,
            <<"if"/utf8>>,
            <<"in"/utf8>>,
            <<"inner"/utf8>>,
            <<"insert"/utf8>>,
            <<"into"/utf8>>,
            <<"join"/utf8>>,
            <<"key"/utf8>>,
            <<"left"/utf8>>,
            <<"like"/utf8>>,
            <<"not"/utf8>>,
            <<"nothing"/utf8>>,
            <<"null"/utf8>>,
            <<"on"/utf8>>,
            <<"or"/utf8>>,
            <<"order"/utf8>>,
            <<"primary"/utf8>>,
            <<"revert"/utf8>>,
            <<"right"/utf8>>,
            <<"select"/utf8>>,
            <<"set"/utf8>>,
            <<"table"/utf8>>,
            <<"top"/utf8>>,
            <<"trigger"/utf8>>,
            <<"union"/utf8>>,
            <<"update"/utf8>>,
            <<"use"/utf8>>,
            <<"values"/utf8>>,
            <<"view"/utf8>>,
            <<"where"/utf8>>,
            <<"with"/utf8>>],
        <<"|"/utf8>>
    ),
    Not_inside_string = <<"(?=(?:[^']*'[^']*')*[^']*$)"/utf8>>,
    Keyword@1 = case begin
        _pipe = (<<<<<<"\\b("/utf8, Keywords/binary>>/binary, ")\\b"/utf8>>/binary,
            Not_inside_string/binary>>),
        gleam@regexp:compile(_pipe, {options, true, false})
    end of
        {ok, Keyword} -> Keyword;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"squirrel/internal/error"/utf8>>,
                        function => <<"syntax_highlight"/utf8>>,
                        line => 946,
                        value => _assert_fail,
                        start => 29613,
                        'end' => 29746,
                        pattern_start => 29624,
                        pattern_end => 29635})
    end,
    Number@1 = case gleam@regexp:from_string(
        <<"(?<!\\$)\\b(\\d+(\\.\\d+)?\\b)"/utf8, Not_inside_string/binary>>
    ) of
        {ok, Number} -> Number;
        _assert_fail@1 ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"squirrel/internal/error"/utf8>>,
                        function => <<"syntax_highlight"/utf8>>,
                        line => 949,
                        value => _assert_fail@1,
                        start => 29749,
                        'end' => 29850,
                        pattern_start => 29760,
                        pattern_end => 29770})
    end,
    Comment@1 = case gleam@regexp:from_string(<<"(^\\s*--.*)"/utf8>>) of
        {ok, Comment} -> Comment;
        _assert_fail@2 ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"squirrel/internal/error"/utf8>>,
                        function => <<"syntax_highlight"/utf8>>,
                        line => 951,
                        value => _assert_fail@2,
                        start => 29853,
                        'end' => 29911,
                        pattern_start => 29864,
                        pattern_end => 29875})
    end,
    String@1 = case gleam@regexp:from_string(<<"(\\'.*\\')"/utf8>>) of
        {ok, String} -> String;
        _assert_fail@3 ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"squirrel/internal/error"/utf8>>,
                        function => <<"syntax_highlight"/utf8>>,
                        line => 952,
                        value => _assert_fail@3,
                        start => 29914,
                        'end' => 29970,
                        pattern_start => 29925,
                        pattern_end => 29935})
    end,
    Hole@1 = case gleam@regexp:from_string(
        <<"(\\$\\d+)"/utf8, Not_inside_string/binary>>
    ) of
        {ok, Hole} -> Hole;
        _assert_fail@4 ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"squirrel/internal/error"/utf8>>,
                        function => <<"syntax_highlight"/utf8>>,
                        line => 953,
                        value => _assert_fail@4,
                        start => 29973,
                        'end' => 30047,
                        pattern_start => 29984,
                        pattern_end => 29992})
    end,
    _pipe@1 = Content,
    _pipe@2 = gleam_regexp_ffi:replace(
        Comment@1,
        _pipe@1,
        <<"\x{001B}[2m\\1\x{001B}[0m"/utf8>>
    ),
    _pipe@3 = gleam_regexp_ffi:replace(
        Keyword@1,
        _pipe@2,
        <<"\x{001B}[36m\\1\x{001B}[39m"/utf8>>
    ),
    _pipe@4 = gleam_regexp_ffi:replace(
        String@1,
        _pipe@3,
        <<"\x{001B}[33m\\1\x{001B}[39m"/utf8>>
    ),
    _pipe@5 = gleam_regexp_ffi:replace(
        Number@1,
        _pipe@4,
        <<"\x{001B}[32m\\1\x{001B}[39m"/utf8>>
    ),
    gleam_regexp_ffi:replace(
        Hole@1,
        _pipe@5,
        <<"\x{001B}[35m\\1\x{001B}[39m"/utf8>>
    ).

-file("src/squirrel/internal/error.gleam", 799).
?DOC(false).
-spec code_doc(binary(), binary(), gleam@option:option(pointer()), integer()) -> glam@doc:document().
code_doc(File, Content, Pointer, Starting_line) ->
    Pointer@1 = begin
        _pipe = gleam@option:to_result(Pointer, nil),
        gleam@result:'try'(
            _pipe,
            fun(_capture) -> pointer_doc(_capture, Content) end
        )
    end,
    Content@1 = syntax_highlight(Content),
    Lines = gleam@string:split(Content@1, <<"\n"/utf8>>),
    Lines_count = erlang:length(Lines),
    Digits = digits(Lines_count + Starting_line),
    Max_digits = erlang:length(Digits),
    Code_lines = begin
        gleam@list:index_map(
            Lines,
            fun(Line, I) ->
                Prefix = begin
                    _pipe@1 = erlang:integer_to_binary(I + Starting_line),
                    gleam@string:pad_start(
                        _pipe@1,
                        Max_digits + 2,
                        <<" "/utf8>>
                    )
                end,
                _pipe@4 = case Pointer@1 of
                    {ok, {Pointer_line, From, Pointer_doc}} when Pointer_line =:= I ->
                        [glam@doc:from_string(
                                gleam_community@ansi:dim(
                                    <<Prefix/binary, " │ "/utf8>>
                                )
                            ),
                            glam@doc:from_string(Line),
                            begin
                                _pipe@2 = [{line, 1}, Pointer_doc],
                                _pipe@3 = glam@doc:concat(_pipe@2),
                                glam@doc:nest(_pipe@3, (From + Max_digits) + 5)
                            end];

                    {ok, _} ->
                        [glam@doc:from_string(
                                gleam_community@ansi:dim(
                                    <<Prefix/binary, " │ "/utf8>>
                                )
                            ),
                            glam@doc:from_string(gleam_community@ansi:dim(Line))];

                    {error, _} ->
                        [glam@doc:from_string(
                                <<(gleam_community@ansi:dim(
                                        <<Prefix/binary, " │ "/utf8>>
                                    ))/binary,
                                    Line/binary>>
                            )]
                end,
                glam@doc:concat(_pipe@4)
            end
        )
    end,
    Padding = gleam@string:repeat(<<" "/utf8>>, Max_digits + 3),
    _pipe@5 = [glam@doc:from_string(
            <<Padding/binary,
                (gleam_community@ansi:dim(<<"╭─ "/utf8, File/binary>>))/binary>>
        ),
        case Starting_line of
            1 ->
                glam@doc:from_string(
                    <<Padding/binary,
                        (gleam_community@ansi:dim(<<"│"/utf8>>))/binary>>
                );

            _ ->
                glam@doc:from_string(
                    <<Padding/binary,
                        (gleam_community@ansi:dim(<<"┆"/utf8>>))/binary>>
                )
        end |
        Code_lines],
    _pipe@6 = glam@doc:join(_pipe@5, {line, 1}),
    _pipe@7 = glam@doc:append(_pipe@6, {line, 1}),
    _pipe@8 = glam@doc:append(
        _pipe@7,
        glam@doc:from_string(
            <<Padding/binary, (gleam_community@ansi:dim(<<"┆"/utf8>>))/binary>>
        )
    ),
    glam@doc:group(_pipe@8).

-file("src/squirrel/internal/error.gleam", 791).
?DOC(false).
-spec paragraph_doc(paragraph()) -> glam@doc:document().
paragraph_doc(Paragraph) ->
    case Paragraph of
        {simple, String} ->
            flexible_string(String);

        {code, File, Content, Pointer, Starting_line} ->
            code_doc(File, Content, Pointer, Starting_line)
    end.

-file("src/squirrel/internal/error.gleam", 785).
?DOC(false).
-spec body_doc(list(paragraph())) -> glam@doc:document().
body_doc(Body) ->
    _pipe = gleam@list:map(Body, fun paragraph_doc/1),
    _pipe@1 = glam@doc:join(_pipe, glam@doc:lines(2)),
    glam@doc:group(_pipe@1).

-file("src/squirrel/internal/error.gleam", 765).
?DOC(false).
-spec printable_error_to_doc(printable_error()) -> glam@doc:document().
printable_error_to_doc(Error) ->
    {printable_error, Title, Body, Report_bug, Call_to_action, Hint} = Error,
    _pipe = [title_doc(Title),
        body_doc(Body),
        option_to_doc(Report_bug, fun report_bug_doc/1),
        option_to_doc(Call_to_action, fun call_to_action_doc/1),
        option_to_doc(Hint, fun hint_doc/1)],
    _pipe@1 = gleam@list:filter(_pipe, fun(Doc) -> Doc /= {concat, []} end),
    _pipe@2 = glam@doc:join(_pipe@1, glam@doc:lines(2)),
    glam@doc:group(_pipe@2).

-file("src/squirrel/internal/error.gleam", 255).
?DOC(false).
-spec to_doc(error()) -> glam@doc:document().
to_doc(Error) ->
    Printable_error = case Error of
        {pg_cannot_establish_tcp_connection, Host, Port, Reason} ->
            Mug_error = case Reason of
                {connect_failed_both, Error@1, _} ->
                    Error@1;

                {connect_failed_ipv4, Error@1} ->
                    Error@1;

                {connect_failed_ipv6, Error@1} ->
                    Error@1
            end,
            _pipe = printable_error(<<"Cannot establish TCP connection"/utf8>>),
            add_paragraph(_pipe, case Mug_error of
                    econnrefused ->
                        <<<<<<<<"I couldn't connect to the database because "/utf8,
                                        (style_inline_code(Host))/binary>>/binary,
                                    " refused the connection to port "/utf8>>/binary,
                                (erlang:integer_to_binary(Port))/binary>>/binary,
                            "."/utf8>>;

                    closed ->
                        <<<<<<<<"I couldn't connect to the database because "/utf8,
                                        (style_inline_code(Host))/binary>>/binary,
                                    " closed the connection to port "/utf8>>/binary,
                                (erlang:integer_to_binary(Port))/binary>>/binary,
                            "."/utf8>>;

                    ehostunreach ->
                        <<<<"I couldn't connect to the database because "/utf8,
                                (style_inline_code(Host))/binary>>/binary,
                            " is unreachable."/utf8>>;

                    timeout ->
                        <<<<<<<<"I couldn't connect to "/utf8,
                                        (style_inline_code(Host))/binary>>/binary,
                                    " at port "/utf8>>/binary,
                                (erlang:integer_to_binary(Port))/binary>>/binary,
                            " because the connection timed out."/utf8>>;

                    _ ->
                        <<<<<<<<<<"I couldn't connect to the database because I ran into the following
problem while trying to establish a TCP connection to
"/utf8,
                                            (style_inline_code(Host))/binary>>/binary,
                                        " at port "/utf8>>/binary,
                                    (erlang:integer_to_binary(Port))/binary>>/binary,
                                ":
"/utf8>>/binary,
                            (gleam@string:inspect(Reason))/binary>>
                end);

        {pg_invalid_user_database, User, Database} ->
            _pipe@1 = printable_error(<<"Cannot connect"/utf8>>),
            _pipe@2 = add_paragraph(
                _pipe@1,
                <<<<<<<<"I couldn't connect to database "/utf8,
                                (style_inline_code(Database))/binary>>/binary,
                            " with user "/utf8>>/binary,
                        (style_inline_code(User))/binary>>/binary,
                    "."/utf8>>
            ),
            hint(
                _pipe@2,
                <<<<<<<<"You can change the default user and database by setting the "/utf8,
                                (style_inline_code(<<"PGUSER"/utf8>>))/binary>>/binary,
                            " and "/utf8>>/binary,
                        (style_inline_code(<<"PGDATABASE"/utf8>>))/binary>>/binary,
                    " environment variables."/utf8>>
            );

        {pg_unexpected_auth_method_message, Expected, Got} ->
            _pipe@3 = printable_error(
                <<"Cannot authenticate (no-method)"/utf8>>
            ),
            _pipe@4 = add_paragraph(
                _pipe@3,
                <<"I ran into an unexpected problem while trying to authenticate with the
Postgres server. This is most definitely a bug!"/utf8>>
            ),
            report_bug(
                _pipe@4,
                <<<<<<"Expected: "/utf8, Expected/binary>>/binary,
                        ", Got: "/utf8>>/binary,
                    Got/binary>>
            );

        {pg_invalid_password, User@1} ->
            _pipe@5 = printable_error(<<"Cannot authenticate"/utf8>>),
            _pipe@6 = add_paragraph(
                _pipe@5,
                <<<<"Invalid password for user "/utf8,
                        (style_inline_code(User@1))/binary>>/binary,
                    "."/utf8>>
            ),
            hint(
                _pipe@6,
                <<<<"You can change the default password used to
authenticate by setting the "/utf8,
                        (style_inline_code(<<"PGPASSWORD"/utf8>>))/binary>>/binary,
                    " environment variable."/utf8>>
            );

        {pg_unexpected_cleartext_auth_message, Expected@1, Got@1} ->
            _pipe@7 = printable_error(
                <<"Cannot authenticate (cleartext)"/utf8>>
            ),
            _pipe@8 = add_paragraph(
                _pipe@7,
                <<"I ran into an unexpected problem while trying to authenticate with the
Postgres server. This is most definitely a bug!"/utf8>>
            ),
            report_bug(
                _pipe@8,
                <<<<<<"Expected: "/utf8, Expected@1/binary>>/binary,
                        ", Got: "/utf8>>/binary,
                    Got@1/binary>>
            );

        {pg_unexpected_sha256_auth_message, Expected@2, Got@2} ->
            _pipe@9 = printable_error(<<"Cannot authenticate (sha256)"/utf8>>),
            _pipe@10 = add_paragraph(
                _pipe@9,
                <<"I ran into an unexpected problem while trying to authenticate with the
Postgres server. This is most definitely a bug!"/utf8>>
            ),
            report_bug(
                _pipe@10,
                <<<<<<"Expected: "/utf8, Expected@2/binary>>/binary,
                        ", Got: "/utf8>>/binary,
                    Got@2/binary>>
            );

        pg_invalid_sha256_server_proof ->
            _pipe@11 = printable_error(<<"Cannot authenticate"/utf8>>),
            add_paragraph(
                _pipe@11,
                <<"I couldn't authenticate with the Postgres server."/utf8>>
            );

        {pg_unsupported_authentication, Auth} ->
            _pipe@12 = printable_error(
                <<"Unsupported authentication method"/utf8>>
            ),
            _pipe@13 = add_paragraph(
                _pipe@12,
                <<<<"The Postgres server is asking to authenticate using the "/utf8,
                        Auth/binary>>/binary,
                    " authentication method, which I currently do not support."/utf8>>
            ),
            call_to_action(
                _pipe@13,
                <<"this authentication method to be supported"/utf8>>
            );

        {pg_cannot_send_message, Reason@1} ->
            _pipe@14 = printable_error(<<"Cannot send message"/utf8>>),
            _pipe@15 = add_paragraph(
                _pipe@14,
                <<"I ran into an unexpected error while trying to talk to the Postgres
database server."/utf8>>
            ),
            report_bug(_pipe@15, Reason@1);

        {pg_cannot_decode_received_message, Reason@2} ->
            _pipe@16 = printable_error(<<"Cannot decode message"/utf8>>),
            _pipe@17 = add_paragraph(
                _pipe@16,
                <<"I ran into an unexpected error while trying to decode a message
received from the Postgres database server."/utf8>>
            ),
            report_bug(_pipe@17, Reason@2);

        {pg_cannot_receive_message, Reason@3} ->
            _pipe@18 = printable_error(<<"Cannot receive message"/utf8>>),
            _pipe@19 = add_paragraph(
                _pipe@18,
                <<"I ran into an unexpected error while trying to listen to the Postgres
database server."/utf8>>
            ),
            report_bug(_pipe@19, Reason@3);

        {pg_cannot_describe_query, File, Query_name, Expected@3, Got@3} ->
            _pipe@20 = printable_error(<<"Cannot inspect query"/utf8>>),
            _pipe@21 = add_paragraph(
                _pipe@20,
                <<<<<<<<"I ran into an unexpected problem while trying to figure
out the types of query "/utf8,
                                (style_inline_code(Query_name))/binary>>/binary,
                            "
defined in "/utf8>>/binary,
                        (style_file(File))/binary>>/binary,
                    ". This is most definitely a bug!"/utf8>>
            ),
            report_bug(
                _pipe@21,
                <<<<<<"Expected: "/utf8, Expected@3/binary>>/binary,
                        ", Got: "/utf8>>/binary,
                    Got@3/binary>>
            );

        {pg_permission_denied, Query_file, Reason@4} ->
            _pipe@22 = printable_error(<<"Permission denied"/utf8>>),
            _pipe@23 = add_paragraph(
                _pipe@22,
                <<<<<<<<"I cannot type the query defined in "/utf8,
                                (style_link(Query_file))/binary>>/binary,
                            "
because the server denied me permission with the following message: "/utf8>>/binary,
                        Reason@4/binary>>/binary,
                    "."/utf8>>
            ),
            hint(
                _pipe@23,
                <<"Make sure the current user has the privileges to run this query."/utf8>>
            );

        {pg_cannot_explain_query, File@1, Query_name@1, Expected@4, Got@4} ->
            _pipe@24 = printable_error(<<"Cannot explain query"/utf8>>),
            _pipe@25 = add_paragraph(
                _pipe@24,
                <<<<<<<<"I ran into an unexpected problem while trying to figure
out the types of query "/utf8,
                                (style_inline_code(Query_name@1))/binary>>/binary,
                            "
defined in "/utf8>>/binary,
                        (style_file(File@1))/binary>>/binary,
                    ". This is most definitely a bug!"/utf8>>
            ),
            report_bug(
                _pipe@25,
                <<<<<<"Expected: "/utf8, Expected@4/binary>>/binary,
                        ", Got: "/utf8>>/binary,
                    Got@4/binary>>
            );

        {invalid_connection_string, String} ->
            _pipe@26 = printable_error(<<"Invalid connection string"/utf8>>),
            _pipe@27 = add_paragraph(
                _pipe@26,
                <<<<<<<<"The value of the "/utf8,
                                (style_inline_code(<<"DATABASE_URL"/utf8>>))/binary>>/binary,
                            " variable "/utf8>>/binary,
                        (style_inline_code(String))/binary>>/binary,
                    " is not a valid connection string."/utf8>>
            ),
            hint(
                _pipe@27,
                <<"A connection string should have the following format: "/utf8,
                    (style_inline_code(
                        <<"postgres://username:password@host:port/database_name"/utf8>>
                    ))/binary>>
            );

        {cannot_read_file, File@2, Reason@5} ->
            _pipe@28 = printable_error(<<"Cannot read file"/utf8>>),
            add_paragraph(
                _pipe@28,
                <<<<<<"I couldn't read "/utf8, (style_file(File@2))/binary>>/binary,
                        " because of the following error: "/utf8>>/binary,
                    (simplifile:describe_error(Reason@5))/binary>>
            );

        {cannot_write_to_file, File@3, Reason@6} ->
            _pipe@29 = printable_error(<<"Cannot write to file"/utf8>>),
            add_paragraph(
                _pipe@29,
                <<<<<<"I couldn't write to "/utf8, (style_file(File@3))/binary>>/binary,
                        " because of the following error: "/utf8>>/binary,
                    (simplifile:describe_error(Reason@6))/binary>>
            );

        {query_file_has_invalid_name, File@4, Suggested_name, _} ->
            _pipe@30 = printable_error(<<"Query file with invalid name"/utf8>>),
            _pipe@31 = add_paragraph(
                _pipe@30,
                <<<<"File "/utf8, (style_file(File@4))/binary>>/binary,
                    " doesn't have a valid name.
The name of a file is used to generate a corresponding Gleam function, so it
should be a valid Gleam name."/utf8>>
            ),
            hint(
                _pipe@31,
                <<"A file name must start with a lowercase letter and can only
contain lowercase letters, numbers and underscores."/utf8,
                    (case Suggested_name of
                        {some, Name} ->
                            <<<<"\nMaybe try renaming it to "/utf8,
                                    (style_inline_code(Name))/binary>>/binary,
                                "?"/utf8>>;

                        none ->
                            <<""/utf8>>
                    end)/binary>>
            );

        {query_has_invalid_column,
            File@5,
            Column_name,
            Suggested_name@1,
            Content,
            Starting_line,
            Reason@7} ->
            case Reason@7 of
                value_is_empty ->
                    _pipe@32 = printable_error(
                        <<"Column with empty name"/utf8>>
                    ),
                    _pipe@33 = add_code_paragraph(
                        _pipe@32,
                        File@5,
                        Content,
                        none,
                        Starting_line
                    ),
                    add_paragraph(
                        _pipe@33,
                        <<"A column returned by this query has the empty string as a name,
all columns should have a valid Gleam name as name."/utf8>>
                    );

                _ ->
                    Message = case Suggested_name@1 of
                        none ->
                            <<"This is not a valid Gleam name"/utf8>>;

                        {some, Suggestion} ->
                            <<<<"This is not a valid Gleam name, maybe try "/utf8,
                                    (style_inline_code(Suggestion))/binary>>/binary,
                                "?"/utf8>>
                    end,
                    _pipe@34 = printable_error(
                        <<"Column with invalid name"/utf8>>
                    ),
                    _pipe@35 = add_code_paragraph(
                        _pipe@34,
                        File@5,
                        Content,
                        {some, {pointer, {name, Column_name}, Message}},
                        Starting_line
                    ),
                    hint(
                        _pipe@35,
                        <<"A column name must start with a lowercase letter and can only
contain lowercase letters, numbers and underscores."/utf8>>
                    )
            end;

        {query_has_invalid_enum,
            File@6,
            Content@1,
            Starting_line@1,
            Enum_name,
            Reason@8} ->
            _pipe@36 = printable_error(<<"Query with invalid enum"/utf8>>),
            _pipe@37 = add_code_paragraph(
                _pipe@36,
                File@6,
                Content@1,
                none,
                Starting_line@1
            ),
            _pipe@39 = add_paragraph(
                _pipe@37,
                <<<<<<"One of the values in this query is the "/utf8,
                            (style_inline_code(Enum_name))/binary>>/binary,
                        " enum, but I cannot turn it into a Gleam type definition because "/utf8>>/binary,
                    (case Reason@8 of
                        enum_with_no_variants ->
                            <<"it has no variants."/utf8>>;

                        {invalid_enum_name, _} ->
                            <<"its name cannot be turned into a valid type name."/utf8>>;

                        {invalid_enum_variants, Fields} ->
                            Pretty_fields = begin
                                _pipe@38 = gleam@list:map(
                                    Fields,
                                    fun style_inline_code/1
                                ),
                                gleam@string:join(_pipe@38, <<", "/utf8>>)
                            end,
                            <<<<"some of its possible values ("/utf8,
                                    Pretty_fields/binary>>/binary,
                                ") cannot be turned into valid type variants."/utf8>>
                    end)/binary>>
            ),
            maybe_hint(_pipe@39, case Reason@8 of
                    {invalid_enum_variants, _} ->
                        {some,
                            <<"A valid enum variant must start with a letter and can only contain
letters, underscores and numbers. I will take care of automatically converting
any snake_case variant to PascalCase so that it can be used as a variant of a
Gleam type!"/utf8>>};

                    {invalid_enum_name, _} ->
                        {some,
                            <<"A valid enum name must start with a letter and can only contain
letters, underscores and numbers. I will take care automatically of converting
any snake_case name to PascalCase so that it can be used as the name of a
Gleam type!"/utf8>>};

                    enum_with_no_variants ->
                        none
                end);

        {query_has_unsupported_type,
            File@7,
            _,
            Content@2,
            Starting_line@2,
            Type_} ->
            Base_error = begin
                _pipe@40 = printable_error(<<"Unsupported type"/utf8>>),
                _pipe@41 = add_code_paragraph(
                    _pipe@40,
                    File@7,
                    Content@2,
                    none,
                    Starting_line@2
                ),
                add_paragraph(
                    _pipe@41,
                    <<<<"One of the rows returned by this query has type "/utf8,
                            (style_inline_code(Type_))/binary>>/binary,
                        " which I cannot currently generate code for."/utf8>>
                )
            end,
            case Type_ of
                <<"timestamptz"/utf8>> ->
                    _pipe@42 = Base_error,
                    hint(
                        _pipe@42,
                        <<<<<<<<"In Postgres a "/utf8,
                                        (style_inline_code(
                                            <<"timestamptz"/utf8>>
                                        ))/binary>>/binary,
                                    " is converted to a regular "/utf8>>/binary,
                                (style_inline_code(<<"timestamp"/utf8>>))/binary>>/binary,
                            " using the connection's time zone. This is very error prone and
should be avoided in favour of using regular timestamps."/utf8>>
                    );

                _ ->
                    _pipe@43 = Base_error,
                    call_to_action(
                        _pipe@43,
                        <<"this type to be supported"/utf8>>
                    )
            end;

        {cannot_parse_query,
            File@8,
            _,
            Content@3,
            Starting_line@3,
            Error_code,
            Pointer,
            Additional_error_message,
            Hint} ->
            Error@2 = begin
                _pipe@44 = printable_error(case Error_code of
                        {some, Code} ->
                            <<<<"Invalid query ["/utf8, Code/binary>>/binary,
                                "]"/utf8>>;

                        none ->
                            <<"Invalid query"/utf8>>
                    end),
                _pipe@45 = add_code_paragraph(
                    _pipe@44,
                    File@8,
                    Content@3,
                    Pointer,
                    Starting_line@3
                ),
                maybe_hint(_pipe@45, Hint)
            end,
            case Additional_error_message of
                {some, Message@1} ->
                    add_paragraph(Error@2, Message@1);

                none ->
                    Error@2
            end;

        {query_returns_multiple_values_with_the_same_name,
            File@9,
            Content@4,
            Starting_line@4,
            Names} ->
            Pretty_names = begin
                _pipe@46 = gleam@list:map(Names, fun style_inline_code/1),
                gleam@string:join(_pipe@46, <<", "/utf8>>)
            end,
            Name@1 = case Names of
                [] ->
                    <<"names"/utf8>>;

                [_, _ | _] ->
                    <<"names"/utf8>>;

                [_] ->
                    <<"name"/utf8>>
            end,
            _pipe@47 = printable_error(<<"Duplicate names"/utf8>>),
            _pipe@48 = add_code_paragraph(
                _pipe@47,
                File@9,
                Content@4,
                none,
                Starting_line@4
            ),
            add_paragraph(
                _pipe@48,
                <<<<<<<<"This query returns multiple values sharing the same "/utf8,
                                Name@1/binary>>/binary,
                            ": "/utf8>>/binary,
                        Pretty_names/binary>>/binary,
                    "."/utf8>>
            );

        {cannot_parse_plan_for_query, File@10, Reason@9} ->
            _pipe@49 = printable_error(<<"Cannot decode query plan"/utf8>>),
            _pipe@50 = add_paragraph(
                _pipe@49,
                <<<<"I ran into an unexpected error while trying to figure out how to
generate code for query "/utf8,
                        (style_file(File@10))/binary>>/binary,
                    "."/utf8>>
            ),
            report_bug(_pipe@50, gleam@string:inspect(Reason@9));

        postgres_version_is_too_old ->
            _pipe@51 = printable_error(<<"Outdated Postgres version"/utf8>>),
            _pipe@52 = add_paragraph(
                _pipe@51,
                <<"Squirrel only works with Postgres versions >= 16"/utf8>>
            ),
            add_paragraph(
                _pipe@52,
                <<"If you have a good reason that's blocking you from upgrading Postgres
version and you want to use Squirrel, please open an issue at "/utf8,
                    (style_link(
                        <<"https://github.com/giacomocavalieri/squirrel/issues/new"/utf8>>
                    ))/binary>>
            );

        {postgres_version_has_invalid_format, Invalid_version} ->
            _pipe@53 = printable_error(
                <<"Postgres version with unexpected format"/utf8>>
            ),
            _pipe@54 = add_paragraph(
                _pipe@53,
                <<"It looks like your Postgres server's version has an unexpected format.
This is most definitely a bug!"/utf8>>
            ),
            report_bug(_pipe@54, gleam@bit_array:inspect(Invalid_version));

        {outdated_file, File@11} ->
            _pipe@55 = printable_error(<<"Outdated file"/utf8>>),
            add_paragraph(
                _pipe@55,
                <<<<"It looks like "/utf8, (style_file(File@11))/binary>>/binary,
                    " is outdated, try running `gleam run -m squirrel` to generate a new
up to date version."/utf8>>
            );

        {cannot_overwrite_existing_file, File@12} ->
            _pipe@56 = printable_error(<<"Cannot overwrite file"/utf8>>),
            _pipe@57 = add_paragraph(
                _pipe@56,
                <<<<"It looks like "/utf8, (style_file(File@12))/binary>>/binary,
                    " already exists and was not
generated by Squirrel, I cannot overwrite it!"/utf8>>
            ),
            hint(
                _pipe@57,
                <<"Rename the file and run `gleam run -m squirrel` again."/utf8>>
            )
    end,
    printable_error_to_doc(Printable_error).
