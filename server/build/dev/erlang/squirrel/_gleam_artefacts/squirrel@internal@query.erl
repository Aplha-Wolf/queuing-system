-module(squirrel@internal@query).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/squirrel/internal/query.gleam").
-export([add_types/3, from_file/1, generate_code/3]).
-export_type([untyped_query/0, typed_query/0, code_gen_state/0, enum_code_gen_data/0, required_helpers/0, type_position/0, publicity/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-type untyped_query() :: {untyped_query,
        binary(),
        integer(),
        squirrel@internal@gleam:value_identifier(),
        list(binary()),
        binary()}.

-type typed_query() :: {typed_query,
        binary(),
        integer(),
        squirrel@internal@gleam:value_identifier(),
        list(binary()),
        binary(),
        list(squirrel@internal@gleam:type()),
        list(squirrel@internal@gleam:field())}.

-type code_gen_state() :: {code_gen_state,
        gleam@dict:dict(binary(), gleam@set:set(binary())),
        boolean(),
        gleam@dict:dict(squirrel@internal@gleam:type_identifier(), enum_code_gen_data())}.

-type enum_code_gen_data() :: {enum_code_gen_data,
        required_helpers(),
        binary(),
        non_empty_list:non_empty_list(squirrel@internal@gleam:enum_variant())}.

-type required_helpers() :: needs_encoder_and_decoder |
    needs_decoder |
    needs_encoder |
    no_helpers.

-type type_position() :: enum_field | function_argument.

-type publicity() :: public | private.

-file("src/squirrel/internal/query.gleam", 88).
?DOC(false).
-spec duplicate_names(list(squirrel@internal@gleam:field())) -> list(binary()).
duplicate_names(Fields) ->
    Names = begin
        gleam@list:fold(
            Fields,
            tote@bag:new(),
            fun(Bag, _use1) ->
                {field, Label, _} = _use1,
                tote@bag:insert(
                    Bag,
                    1,
                    squirrel@internal@gleam:value_identifier_to_string(Label)
                )
            end
        )
    end,
    tote@bag:fold(
        Names,
        [],
        fun(Duplicate_names, Field, Copies) -> case Copies of
                1 ->
                    Duplicate_names;

                _ ->
                    [Field | Duplicate_names]
            end end
    ).

-file("src/squirrel/internal/query.gleam", 59).
?DOC(false).
-spec add_types(
    untyped_query(),
    list(squirrel@internal@gleam:type()),
    list(squirrel@internal@gleam:field())
) -> {ok, typed_query()} | {error, squirrel@internal@error:error()}.
add_types(Query, Params, Returns) ->
    {untyped_query, File, Starting_line, Name, Comment, Content} = Query,
    case duplicate_names(Returns) of
        [] ->
            {ok,
                {typed_query,
                    File,
                    Starting_line,
                    Name,
                    Comment,
                    Content,
                    Params,
                    Returns}};

        Names ->
            {error,
                {query_returns_multiple_values_with_the_same_name,
                    File,
                    Content,
                    Starting_line,
                    Names}}
    end.

-file("src/squirrel/internal/query.gleam", 143).
?DOC(false).
-spec do_take_comment(binary(), list(binary())) -> list(binary()).
do_take_comment(Query, Lines) ->
    case gleam@string:trim_start(Query) of
        <<"--"/utf8, Rest/binary>> ->
            case gleam@string:split_once(Rest, <<"\n"/utf8>>) of
                {ok, {Line, Rest@1}} ->
                    do_take_comment(Rest@1, [gleam@string:trim(Line) | Lines]);

                _ ->
                    do_take_comment(
                        <<""/utf8>>,
                        [gleam@string:trim(Rest) | Lines]
                    )
            end;

        _ ->
            lists:reverse(Lines)
    end.

-file("src/squirrel/internal/query.gleam", 139).
?DOC(false).
-spec take_comment(binary()) -> list(binary()).
take_comment(Query) ->
    do_take_comment(Query, []).

-file("src/squirrel/internal/query.gleam", 107).
?DOC(false).
-spec from_file(binary()) -> {ok, untyped_query()} |
    {error, squirrel@internal@error:error()}.
from_file(File) ->
    Read_file = begin
        _pipe = simplifile:read(File),
        gleam@result:map_error(
            _pipe,
            fun(_capture) -> {cannot_read_file, File, _capture} end
        )
    end,
    gleam@result:'try'(
        Read_file,
        fun(Content) ->
            File_name = begin
                _pipe@1 = filepath:base_name(File),
                filepath:strip_extension(_pipe@1)
            end,
            Name = begin
                _pipe@2 = squirrel@internal@gleam:value_identifier(File_name),
                gleam@result:map_error(
                    _pipe@2,
                    fun(_capture@1) ->
                        {query_file_has_invalid_name,
                            File,
                            begin
                                _pipe@3 = squirrel@internal@gleam:similar_value_identifier_string(
                                    File_name
                                ),
                                gleam@option:from_result(_pipe@3)
                            end,
                            _capture@1}
                    end
                )
            end,
            gleam@result:'try'(
                Name,
                fun(Name@1) ->
                    {ok,
                        {untyped_query,
                            File,
                            1,
                            Name@1,
                            take_comment(Content),
                            Content}}
                end
            )
        end
    ).

-file("src/squirrel/internal/query.gleam", 193).
?DOC(false).
-spec merge_helpers(required_helpers(), required_helpers()) -> required_helpers().
merge_helpers(One, Other) ->
    case {One, Other} of
        {no_helpers, Other@1} ->
            Other@1;

        {Other@1, no_helpers} ->
            Other@1;

        {needs_encoder_and_decoder, _} ->
            needs_encoder_and_decoder;

        {_, needs_encoder_and_decoder} ->
            needs_encoder_and_decoder;

        {needs_decoder, needs_encoder} ->
            needs_encoder_and_decoder;

        {needs_encoder, needs_decoder} ->
            needs_encoder_and_decoder;

        {needs_encoder, needs_encoder} ->
            needs_encoder;

        {needs_decoder, needs_decoder} ->
            needs_decoder
    end.

-file("src/squirrel/internal/query.gleam", 256).
?DOC(false).
-spec enum_decoder_name(squirrel@internal@gleam:type_identifier()) -> binary().
enum_decoder_name(Enum_name) ->
    _pipe = squirrel@internal@gleam:type_identifier_to_value_identifier(
        Enum_name
    ),
    _pipe@1 = squirrel@internal@gleam:value_identifier_to_string(_pipe),
    gleam@string:append(_pipe@1, <<"_decoder"/utf8>>).

-file("src/squirrel/internal/query.gleam", 306).
?DOC(false).
-spec enum_encoder_name(squirrel@internal@gleam:type_identifier()) -> binary().
enum_encoder_name(Enum_name) ->
    _pipe = squirrel@internal@gleam:type_identifier_to_value_identifier(
        Enum_name
    ),
    _pipe@1 = squirrel@internal@gleam:value_identifier_to_string(_pipe),
    gleam@string:append(_pipe@1, <<"_encoder"/utf8>>).

-file("src/squirrel/internal/query.gleam", 448).
?DOC(false).
-spec separator_comment(binary()) -> glam@doc:document().
separator_comment(Value) ->
    _pipe = gleam@string:pad_end(
        <<<<"// --- "/utf8, Value/binary>>/binary, " "/utf8>>,
        80,
        <<"-"/utf8>>
    ),
    glam@doc:from_string(_pipe).

-file("src/squirrel/internal/query.gleam", 561).
?DOC(false).
-spec module_doc(binary(), binary()) -> binary().
module_doc(Version, Directory) ->
    <<<<<<<<"//// This module contains the code to run the sql queries defined in
//// `"/utf8,
                    Directory/binary>>/binary,
                "`.
//// > 🐿️ This module was generated automatically using "/utf8>>/binary,
            Version/binary>>/binary,
        " of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////"/utf8>>.

-file("src/squirrel/internal/query.gleam", 569).
?DOC(false).
-spec function_doc(binary(), typed_query()) -> binary().
function_doc(Version, Query) ->
    {typed_query, File, _, Name, Comment, _, _, _} = Query,
    Function_name = squirrel@internal@gleam:value_identifier_to_string(Name),
    Base = case Comment of
        [] ->
            <<<<<<<<"/// Runs the `"/utf8, Function_name/binary>>/binary,
                        "` query
/// defined in `"/utf8>>/binary,
                    File/binary>>/binary,
                "`."/utf8>>;

        [_ | _] ->
            _pipe = gleam@list:map(
                Comment,
                fun(_capture) ->
                    gleam@string:append(<<"/// "/utf8>>, _capture)
                end
            ),
            gleam@string:join(_pipe, <<"\n"/utf8>>)
    end,
    <<<<<<Base/binary,
                "
///
/// > 🐿️ This function was generated automatically using "/utf8>>/binary,
            Version/binary>>/binary,
        " of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///"/utf8>>.

-file("src/squirrel/internal/query.gleam", 989).
?DOC(false).
-spec let_var(binary(), glam@doc:document()) -> glam@doc:document().
let_var(Name, Body) ->
    _pipe = [glam@doc:from_string(
            <<<<"let "/utf8, Name/binary>>/binary, " ="/utf8>>
        ),
        {break, <<" "/utf8>>, <<""/utf8>>},
        Body],
    _pipe@1 = glam@doc:concat(_pipe),
    glam@doc:group(_pipe@1).

-file("src/squirrel/internal/query.gleam", 1000).
?DOC(false).
-spec string_doc(binary()) -> glam@doc:document().
string_doc(Content) ->
    Escaped_string = begin
        _pipe = Content,
        _pipe@1 = gleam@string:replace(_pipe, <<"\\"/utf8>>, <<"\\\\"/utf8>>),
        _pipe@2 = gleam@string:replace(_pipe@1, <<"\""/utf8>>, <<"\\\""/utf8>>),
        glam@doc:from_string(_pipe@2)
    end,
    _pipe@3 = [glam@doc:from_string(<<"\""/utf8>>),
        Escaped_string,
        glam@doc:from_string(<<"\""/utf8>>)],
    glam@doc:concat(_pipe@3).

-file("src/squirrel/internal/query.gleam", 1036).
?DOC(false).
-spec import_module(code_gen_state(), binary()) -> code_gen_state().
import_module(State, Name) ->
    Imports = case gleam@dict:has_key(erlang:element(2, State), Name) of
        false ->
            gleam@dict:insert(erlang:element(2, State), Name, gleam@set:new());

        true ->
            erlang:element(2, State)
    end,
    {code_gen_state,
        Imports,
        erlang:element(3, State),
        erlang:element(4, State)}.

-file("src/squirrel/internal/query.gleam", 208).
?DOC(false).
-spec default_codegen_state() -> code_gen_state().
default_codegen_state() ->
    _pipe = {code_gen_state, maps:new(), false, maps:new()},
    _pipe@1 = import_module(_pipe, <<"gleam/dynamic/decode"/utf8>>),
    import_module(_pipe@1, <<"pog"/utf8>>).

-file("src/squirrel/internal/query.gleam", 1044).
?DOC(false).
-spec import_qualified(code_gen_state(), binary(), binary()) -> code_gen_state().
import_qualified(State, Module, Imported) ->
    Imports = gleam@dict:upsert(
        erlang:element(2, State),
        Module,
        fun(Imported_values) -> case Imported_values of
                {some, Imported_values@1} ->
                    gleam@set:insert(Imported_values@1, Imported);

                none ->
                    gleam@set:from_list([Imported])
            end end
    ),
    {code_gen_state,
        Imports,
        erlang:element(3, State),
        erlang:element(4, State)}.

-file("src/squirrel/internal/query.gleam", 1060).
?DOC(false).
-spec add_enum_helpers(
    code_gen_state(),
    binary(),
    squirrel@internal@gleam:type_identifier(),
    non_empty_list:non_empty_list(squirrel@internal@gleam:enum_variant()),
    required_helpers()
) -> code_gen_state().
add_enum_helpers(State, Original_name, Name, Variants, Required_helpers) ->
    {code_gen_state,
        erlang:element(2, State),
        erlang:element(3, State),
        begin
            gleam@dict:upsert(
                erlang:element(4, State),
                Name,
                fun(Value) -> case Value of
                        none ->
                            {enum_code_gen_data,
                                Required_helpers,
                                Original_name,
                                Variants};

                        {some, {enum_code_gen_data, Helpers, _, _} = Data} ->
                            Required_helpers@1 = merge_helpers(
                                Required_helpers,
                                Helpers
                            ),
                            {enum_code_gen_data,
                                Required_helpers@1,
                                erlang:element(3, Data),
                                erlang:element(4, Data)}
                    end end
            )
        end}.

-file("src/squirrel/internal/query.gleam", 1081).
?DOC(false).
-spec prepend_if(list(AIDO), boolean(), AIDO) -> list(AIDO).
prepend_if(List, Condition, Item) ->
    case Condition of
        true ->
            [Item | List];

        false ->
            List
    end.

-file("src/squirrel/internal/query.gleam", 453).
?DOC(false).
-spec imports_doc(gleam@dict:dict(binary(), gleam@set:set(binary()))) -> glam@doc:document().
imports_doc(Imports) ->
    Sorted_imports = begin
        _pipe = maps:to_list(Imports),
        gleam@list:sort(
            _pipe,
            fun(One, Other) ->
                gleam@string:compare(
                    erlang:element(1, One),
                    erlang:element(1, Other)
                )
            end
        )
    end,
    _pipe@9 = begin
        gleam@list:map(
            Sorted_imports,
            fun(_use0) ->
                {Module, Imported_values} = _use0,
                Import_line = glam@doc:from_string(
                    <<"import "/utf8, Module/binary>>
                ),
                gleam@bool:guard(
                    gleam@set:is_empty(Imported_values),
                    Import_line,
                    fun() ->
                        Imported_values@1 = begin
                            _pipe@1 = gleam@set:to_list(Imported_values),
                            _pipe@2 = gleam@list:sort(
                                _pipe@1,
                                fun gleam@string:compare/2
                            ),
                            _pipe@3 = gleam@list:map(
                                _pipe@2,
                                fun glam@doc:from_string/1
                            ),
                            _pipe@4 = glam@doc:join(
                                _pipe@3,
                                glam@doc:break(<<", "/utf8>>, <<","/utf8>>)
                            ),
                            glam@doc:group(_pipe@4)
                        end,
                        _pipe@8 = [Import_line,
                            glam@doc:from_string(<<".{"/utf8>>),
                            begin
                                _pipe@5 = [{break, <<""/utf8>>, <<""/utf8>>},
                                    Imported_values@1],
                                _pipe@6 = glam@doc:concat(_pipe@5),
                                _pipe@7 = glam@doc:group(_pipe@6),
                                glam@doc:nest(_pipe@7, 2)
                            end,
                            {break, <<""/utf8>>, <<""/utf8>>},
                            glam@doc:from_string(<<"}"/utf8>>)],
                        glam@doc:concat(_pipe@8)
                    end
                )
            end
        )
    end,
    glam@doc:join(_pipe@9, {line, 1}).

-file("src/squirrel/internal/query.gleam", 924).
?DOC(false).
-spec block(list(glam@doc:document())) -> glam@doc:document().
block(Body) ->
    _pipe@3 = [glam@doc:from_string(<<"{"/utf8>>),
        begin
            _pipe = {line, 1},
            glam@doc:nest(_pipe, 2)
        end,
        begin
            _pipe@1 = Body,
            _pipe@2 = glam@doc:join(_pipe@1, {line, 1}),
            glam@doc:nest(_pipe@2, 2)
        end,
        {line, 1},
        glam@doc:from_string(<<"}"/utf8>>)],
    glam@doc:concat(_pipe@3).

-file("src/squirrel/internal/query.gleam", 687).
?DOC(false).
-spec enum_type_definition_doc(
    binary(),
    squirrel@internal@gleam:type_identifier(),
    binary(),
    non_empty_list:non_empty_list(squirrel@internal@gleam:enum_variant())
) -> glam@doc:document().
enum_type_definition_doc(Version, Enum_name, Original_name, Variants) ->
    String_enum_name = squirrel@internal@gleam:type_identifier_to_string(
        Enum_name
    ),
    Variants@1 = non_empty_list:map(
        Variants,
        fun(Variant) ->
            _pipe = squirrel@internal@gleam:type_identifier_to_string(
                erlang:element(2, Variant)
            ),
            glam@doc:from_string(_pipe)
        end
    ),
    Enum_doc = <<<<<<<<"/// Corresponds to the Postgres `"/utf8,
                    Original_name/binary>>/binary,
                "` enum.
///
/// > 🐿️ This type definition was generated automatically using "/utf8>>/binary,
            Version/binary>>/binary,
        " of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///"/utf8>>,
    glam@doc:concat(
        [glam@doc:from_string(Enum_doc),
            {line, 1},
            glam@doc:from_string(
                <<<<"pub type "/utf8, String_enum_name/binary>>/binary,
                    " "/utf8>>
            ),
            block(non_empty_list:to_list(Variants@1))]
    ).

-file("src/squirrel/internal/query.gleam", 1013).
?DOC(false).
-spec comma_list(binary(), list(glam@doc:document()), binary()) -> glam@doc:document().
comma_list(Open, Content, Close) ->
    case Content of
        [] ->
            glam@doc:from_string(<<Open/binary, Close/binary>>);

        _ ->
            _pipe@2 = [glam@doc:from_string(Open),
                begin
                    _pipe = [{break, <<""/utf8>>, <<""/utf8>>},
                        glam@doc:join(
                            Content,
                            glam@doc:break(<<", "/utf8>>, <<","/utf8>>)
                        )],
                    _pipe@1 = glam@doc:concat(_pipe),
                    glam@doc:nest(_pipe@1, 2)
                end,
                glam@doc:break(<<""/utf8>>, <<","/utf8>>),
                glam@doc:from_string(Close)],
            glam@doc:concat(_pipe@2)
    end.

-file("src/squirrel/internal/query.gleam", 875).
?DOC(false).
-spec call_doc(binary(), list(glam@doc:document())) -> glam@doc:document().
call_doc(Function, Args) ->
    _pipe@1 = [glam@doc:from_string(Function),
        begin
            _pipe = comma_list(<<"("/utf8>>, Args, <<")"/utf8>>),
            glam@doc:group(_pipe)
        end],
    _pipe@2 = glam@doc:concat(_pipe@1),
    glam@doc:group(_pipe@2).

-file("src/squirrel/internal/query.gleam", 218).
?DOC(false).
-spec gleam_type_to_decoder(code_gen_state(), squirrel@internal@gleam:type()) -> {code_gen_state(),
    glam@doc:document()}.
gleam_type_to_decoder(State, Type_) ->
    case Type_ of
        uuid ->
            State@1 = begin
                _pipe = {code_gen_state,
                    erlang:element(2, State),
                    true,
                    erlang:element(4, State)},
                import_module(_pipe, <<"youid/uuid"/utf8>>)
            end,
            {State@1, glam@doc:from_string(<<"uuid_decoder()"/utf8>>)};

        {list, Type_@1} ->
            {State@2, Inner_decoder} = gleam_type_to_decoder(State, Type_@1),
            {State@2, call_doc(<<"decode.list"/utf8>>, [Inner_decoder])};

        {option, Type_@2} ->
            {State@3, Inner_decoder@1} = gleam_type_to_decoder(State, Type_@2),
            {State@3, call_doc(<<"decode.optional"/utf8>>, [Inner_decoder@1])};

        date ->
            {State,
                glam@doc:from_string(<<"pog.calendar_date_decoder()"/utf8>>)};

        time_of_day ->
            {State,
                glam@doc:from_string(
                    <<"pog.calendar_time_of_day_decoder()"/utf8>>
                )};

        timestamp ->
            {State, glam@doc:from_string(<<"pog.timestamp_decoder()"/utf8>>)};

        int ->
            {State, glam@doc:from_string(<<"decode.int"/utf8>>)};

        float ->
            {State, glam@doc:from_string(<<"decode.float"/utf8>>)};

        numeric ->
            {State, glam@doc:from_string(<<"pog.numeric_decoder()"/utf8>>)};

        bool ->
            {State, glam@doc:from_string(<<"decode.bool"/utf8>>)};

        string ->
            {State, glam@doc:from_string(<<"decode.string"/utf8>>)};

        bit_array ->
            {State, glam@doc:from_string(<<"decode.bit_array"/utf8>>)};

        json ->
            {State, glam@doc:from_string(<<"decode.string"/utf8>>)};

        {enum, Original_name, Enum_name, Variants} ->
            {add_enum_helpers(
                    State,
                    Original_name,
                    Enum_name,
                    Variants,
                    needs_decoder
                ),
                glam@doc:from_string(
                    <<(enum_decoder_name(Enum_name))/binary, "()"/utf8>>
                )}
    end.

-file("src/squirrel/internal/query.gleam", 317).
?DOC(false).
-spec gleam_type_to_field_type(
    code_gen_state(),
    squirrel@internal@gleam:type(),
    type_position()
) -> {code_gen_state(), glam@doc:document()}.
gleam_type_to_field_type(State, Type_, Position) ->
    case Type_ of
        {list, Type_@1} ->
            {State@1, Inner_type} = gleam_type_to_field_type(
                State,
                Type_@1,
                Position
            ),
            {State@1, call_doc(<<"List"/utf8>>, [Inner_type])};

        {option, Type_@2} ->
            State@2 = begin
                _pipe = State,
                import_qualified(
                    _pipe,
                    <<"gleam/option"/utf8>>,
                    <<"type Option"/utf8>>
                )
            end,
            {State@3, Inner_type@1} = gleam_type_to_field_type(
                State@2,
                Type_@2,
                Position
            ),
            {State@3, call_doc(<<"Option"/utf8>>, [Inner_type@1])};

        uuid ->
            {begin
                    _pipe@1 = State,
                    import_qualified(
                        _pipe@1,
                        <<"youid/uuid"/utf8>>,
                        <<"type Uuid"/utf8>>
                    )
                end,
                glam@doc:from_string(<<"Uuid"/utf8>>)};

        date ->
            State@4 = begin
                _pipe@2 = State,
                import_qualified(
                    _pipe@2,
                    <<"gleam/time/calendar"/utf8>>,
                    <<"type Date"/utf8>>
                )
            end,
            {State@4, glam@doc:from_string(<<"Date"/utf8>>)};

        time_of_day ->
            State@5 = begin
                _pipe@3 = State,
                import_qualified(
                    _pipe@3,
                    <<"gleam/time/calendar"/utf8>>,
                    <<"type TimeOfDay"/utf8>>
                )
            end,
            {State@5, glam@doc:from_string(<<"TimeOfDay"/utf8>>)};

        timestamp ->
            State@6 = begin
                _pipe@4 = State,
                import_qualified(
                    _pipe@4,
                    <<"gleam/time/timestamp"/utf8>>,
                    <<"type Timestamp"/utf8>>
                )
            end,
            {State@6, glam@doc:from_string(<<"Timestamp"/utf8>>)};

        int ->
            {State, glam@doc:from_string(<<"Int"/utf8>>)};

        float ->
            {State, glam@doc:from_string(<<"Float"/utf8>>)};

        numeric ->
            {State, glam@doc:from_string(<<"Float"/utf8>>)};

        bool ->
            {State, glam@doc:from_string(<<"Bool"/utf8>>)};

        string ->
            {State, glam@doc:from_string(<<"String"/utf8>>)};

        json ->
            case Position of
                enum_field ->
                    {State, glam@doc:from_string(<<"String"/utf8>>)};

                function_argument ->
                    State@7 = begin
                        _pipe@5 = State,
                        import_qualified(
                            _pipe@5,
                            <<"gleam/json"/utf8>>,
                            <<"type Json"/utf8>>
                        )
                    end,
                    {State@7, glam@doc:from_string(<<"Json"/utf8>>)}
            end;

        bit_array ->
            {State, glam@doc:from_string(<<"BitArray"/utf8>>)};

        {enum, Original_name, Name, Variants} ->
            {add_enum_helpers(State, Original_name, Name, Variants, no_helpers),
                begin
                    _pipe@6 = squirrel@internal@gleam:type_identifier_to_string(
                        Name
                    ),
                    glam@doc:from_string(_pipe@6)
                end}
    end.

-file("src/squirrel/internal/query.gleam", 595).
?DOC(false).
-spec record_doc(code_gen_state(), binary(), binary(), typed_query()) -> {ok,
        {code_gen_state(), glam@doc:document()}} |
    {error, nil}.
record_doc(State, Version, Type_name, Query) ->
    {typed_query, File, _, Name, _, _, _, Returns} = Query,
    gleam@bool:guard(
        Returns =:= [],
        {error, nil},
        fun() ->
            Function_name = squirrel@internal@gleam:value_identifier_to_string(
                Name
            ),
            Record_doc = <<<<<<<<<<<<"/// A row you get from running the `"/utf8,
                                    Function_name/binary>>/binary,
                                "` query
/// defined in `"/utf8>>/binary,
                            File/binary>>/binary,
                        "`.
///
/// > 🐿️ This type definition was generated automatically using "/utf8>>/binary,
                    Version/binary>>/binary,
                " of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///"/utf8>>,
            {State@3, Fields@1} = begin
                gleam@list:fold(
                    Returns,
                    {State, []},
                    fun(_use0, Field) ->
                        {State@1, Fields} = _use0,
                        Label = glam@doc:from_string(
                            <<(squirrel@internal@gleam:value_identifier_to_string(
                                    erlang:element(2, Field)
                                ))/binary,
                                ": "/utf8>>
                        ),
                        {State@2, Field_type} = gleam_type_to_field_type(
                            State@1,
                            erlang:element(3, Field),
                            enum_field
                        ),
                        Field@1 = begin
                            _pipe = [Label, Field_type],
                            _pipe@1 = glam@doc:concat(_pipe),
                            glam@doc:group(_pipe@1)
                        end,
                        {State@2, [Field@1 | Fields]}
                    end
                )
            end,
            Fields@2 = lists:reverse(Fields@1),
            Result = begin
                _pipe@6 = [glam@doc:from_string(Record_doc),
                    {line, 1},
                    begin
                        _pipe@4 = [glam@doc:from_string(
                                <<<<"pub type "/utf8, Type_name/binary>>/binary,
                                    " {"/utf8>>
                            ),
                            begin
                                _pipe@2 = [{line, 1},
                                    call_doc(Type_name, Fields@2)],
                                _pipe@3 = glam@doc:concat(_pipe@2),
                                glam@doc:nest(_pipe@3, 2)
                            end,
                            {line, 1},
                            glam@doc:from_string(<<"}"/utf8>>)],
                        _pipe@5 = glam@doc:concat(_pipe@4),
                        glam@doc:group(_pipe@5)
                    end],
                glam@doc:concat(_pipe@6)
            end,
            {ok, {State@3, Result}}
        end
    ).

-file("src/squirrel/internal/query.gleam", 859).
?DOC(false).
-spec pipe_call_doc(binary(), glam@doc:document(), list(glam@doc:document())) -> glam@doc:document().
pipe_call_doc(Function, First, Rest) ->
    Function@1 = case Rest of
        [] ->
            glam@doc:from_string(<<"|> "/utf8, Function/binary>>);

        [_ | _] ->
            call_doc(<<"|> "/utf8, Function/binary>>, Rest)
    end,
    _pipe = [First, {line, 1}, Function@1],
    glam@doc:concat(_pipe).

-file("src/squirrel/internal/query.gleam", 556).
?DOC(false).
-spec pipe_all_encoders(glam@doc:document(), list(glam@doc:document())) -> glam@doc:document().
pipe_all_encoders(Doc, Decoders) ->
    gleam@list:fold(Decoders, Doc, fun(Doc@1, Decoder) -> _pipe = Doc@1,
            pipe_call_doc(<<"pog.parameter"/utf8>>, _pipe, [Decoder]) end).

-file("src/squirrel/internal/query.gleam", 903).
?DOC(false).
-spec nested_calls_doc(binary(), binary(), list(glam@doc:document())) -> glam@doc:document().
nested_calls_doc(First, Second, Arguments) ->
    _pipe = [glam@doc:from_string(First),
        glam@doc:from_string(<<"("/utf8>>),
        call_doc(Second, Arguments),
        glam@doc:from_string(<<")"/utf8>>)],
    glam@doc:concat(_pipe).

-file("src/squirrel/internal/query.gleam", 944).
?DOC(false).
-spec fun_doc(
    publicity(),
    binary(),
    list(glam@doc:document()),
    glam@doc:document(),
    list(glam@doc:document())
) -> glam@doc:document().
fun_doc(Publicity, Name, Args, Return_type, Body) ->
    Publicity@1 = case Publicity of
        private ->
            <<""/utf8>>;

        public ->
            <<"pub "/utf8>>
    end,
    _pipe@2 = [begin
            _pipe = [glam@doc:from_string(
                    <<<<Publicity@1/binary, "fn "/utf8>>/binary, Name/binary>>
                ),
                comma_list(<<"("/utf8>>, Args, <<")"/utf8>>),
                glam@doc:from_string(<<" -> "/utf8>>),
                Return_type,
                glam@doc:from_string(<<" "/utf8>>)],
            _pipe@1 = glam@doc:concat(_pipe),
            glam@doc:group(_pipe@1)
        end,
        block(Body)],
    _pipe@3 = glam@doc:concat(_pipe@2),
    glam@doc:group(_pipe@3).

-file("src/squirrel/internal/query.gleam", 715).
?DOC(false).
-spec enum_encoder_doc(
    squirrel@internal@gleam:type_identifier(),
    non_empty_list:non_empty_list(squirrel@internal@gleam:enum_variant())
) -> glam@doc:document().
enum_encoder_doc(Name, Variants) ->
    Case_lines = begin
        non_empty_list:map(
            Variants,
            fun(Variant) ->
                _pipe = [glam@doc:from_string(
                        squirrel@internal@gleam:type_identifier_to_string(
                            erlang:element(2, Variant)
                        )
                    ),
                    glam@doc:from_string(<<" -> "/utf8>>),
                    string_doc(erlang:element(3, Variant))],
                glam@doc:concat(_pipe)
            end
        )
    end,
    Var_name = begin
        _pipe@1 = Name,
        _pipe@2 = squirrel@internal@gleam:type_identifier_to_value_identifier(
            _pipe@1
        ),
        squirrel@internal@gleam:value_identifier_to_string(_pipe@2)
    end,
    Case_ = glam@doc:concat(
        [glam@doc:from_string(
                <<<<"case "/utf8, Var_name/binary>>/binary, " "/utf8>>
            ),
            block(non_empty_list:to_list(Case_lines))]
    ),
    Case_@1 = pipe_call_doc(<<"pog.text"/utf8>>, Case_, []),
    fun_doc(
        private,
        enum_encoder_name(Name),
        [glam@doc:from_string(Var_name)],
        glam@doc:from_string(<<"pog.Value"/utf8>>),
        [Case_@1]
    ).

-file("src/squirrel/internal/query.gleam", 751).
?DOC(false).
-spec enum_decoder_doc(
    squirrel@internal@gleam:type_identifier(),
    non_empty_list:non_empty_list(squirrel@internal@gleam:enum_variant())
) -> glam@doc:document().
enum_decoder_doc(Name, Variants) ->
    Success_case_lines = begin
        non_empty_list:map(
            Variants,
            fun(Variant) ->
                glam@doc:concat(
                    [string_doc(erlang:element(3, Variant)),
                        glam@doc:from_string(<<" -> "/utf8>>),
                        call_doc(
                            <<"decode.success"/utf8>>,
                            [begin
                                    _pipe = squirrel@internal@gleam:type_identifier_to_string(
                                        erlang:element(2, Variant)
                                    ),
                                    glam@doc:from_string(_pipe)
                                end]
                        )]
                )
            end
        )
    end,
    Failure_case_line = begin
        _pipe@1 = [glam@doc:from_string(<<"_ -> "/utf8>>),
            call_doc(
                <<"decode.failure"/utf8>>,
                [glam@doc:from_string(
                        squirrel@internal@gleam:type_identifier_to_string(
                            erlang:element(2, erlang:element(2, Variants))
                        )
                    ),
                    string_doc(
                        squirrel@internal@gleam:type_identifier_to_string(Name)
                    )]
            )],
        glam@doc:concat(_pipe@1)
    end,
    Var_name = begin
        _pipe@2 = Name,
        _pipe@3 = squirrel@internal@gleam:type_identifier_to_value_identifier(
            _pipe@2
        ),
        squirrel@internal@gleam:value_identifier_to_string(_pipe@3)
    end,
    Case_ = glam@doc:concat(
        [glam@doc:from_string(
                <<<<"case "/utf8, Var_name/binary>>/binary, " "/utf8>>
            ),
            begin
                _pipe@4 = Success_case_lines,
                _pipe@5 = non_empty_list:to_list(_pipe@4),
                _pipe@6 = lists:append(_pipe@5, [Failure_case_line]),
                block(_pipe@6)
            end]
    ),
    Enum_decoder_type = glam@doc:from_string(
        <<<<"decode.Decoder("/utf8,
                (squirrel@internal@gleam:type_identifier_to_string(Name))/binary>>/binary,
            ")"/utf8>>
    ),
    fun_doc(
        private,
        enum_decoder_name(Name),
        [],
        Enum_decoder_type,
        [glam@doc:from_string(
                <<<<"use "/utf8, Var_name/binary>>/binary,
                    " <- decode.then(decode.string)"/utf8>>
            ),
            Case_]
    ).

-file("src/squirrel/internal/query.gleam", 659).
?DOC(false).
-spec enum_doc(
    binary(),
    squirrel@internal@gleam:type_identifier(),
    enum_code_gen_data()
) -> glam@doc:document().
enum_doc(Version, Enum_name, Enum_data) ->
    {enum_code_gen_data, Required_helpers, Original_name, Variants} = Enum_data,
    _pipe = case Required_helpers of
        needs_decoder ->
            [enum_type_definition_doc(
                    Version,
                    Enum_name,
                    Original_name,
                    Variants
                ),
                enum_decoder_doc(Enum_name, Variants)];

        needs_encoder ->
            [enum_type_definition_doc(
                    Version,
                    Enum_name,
                    Original_name,
                    Variants
                ),
                enum_encoder_doc(Enum_name, Variants)];

        needs_encoder_and_decoder ->
            [enum_type_definition_doc(
                    Version,
                    Enum_name,
                    Original_name,
                    Variants
                ),
                enum_decoder_doc(Enum_name, Variants),
                enum_encoder_doc(Enum_name, Variants)];

        no_helpers ->
            [enum_type_definition_doc(
                    Version,
                    Enum_name,
                    Original_name,
                    Variants
                )]
    end,
    glam@doc:join(_pipe, glam@doc:lines(2)).

-file("src/squirrel/internal/query.gleam", 648).
?DOC(false).
-spec enums_doc(
    binary(),
    gleam@dict:dict(squirrel@internal@gleam:type_identifier(), enum_code_gen_data())
) -> glam@doc:document().
enums_doc(Version, Enums) ->
    gleam@dict:fold(
        Enums,
        {concat, []},
        fun(Doc, Name, Enum_data) ->
            glam@doc:append(Doc, enum_doc(Version, Name, Enum_data))
        end
    ).

-file("src/squirrel/internal/query.gleam", 972).
?DOC(false).
-spec fn_doc(list(binary()), glam@doc:document()) -> glam@doc:document().
fn_doc(Args, Body) ->
    _pipe@3 = [glam@doc:from_string(<<"fn"/utf8>>),
        begin
            _pipe = comma_list(
                <<"("/utf8>>,
                gleam@list:map(Args, fun glam@doc:from_string/1),
                <<") {"/utf8>>
            ),
            glam@doc:group(_pipe)
        end,
        begin
            _pipe@1 = [{break, <<" "/utf8>>, <<""/utf8>>}, Body],
            _pipe@2 = glam@doc:concat(_pipe@1),
            glam@doc:nest(_pipe@2, 2)
        end,
        {break, <<" "/utf8>>, <<""/utf8>>},
        glam@doc:from_string(<<"}"/utf8>>)],
    _pipe@4 = glam@doc:concat(_pipe@3),
    glam@doc:group(_pipe@4).

-file("src/squirrel/internal/query.gleam", 262).
?DOC(false).
-spec gleam_type_to_encoder(
    code_gen_state(),
    squirrel@internal@gleam:type(),
    binary()
) -> {code_gen_state(), glam@doc:document()}.
gleam_type_to_encoder(State, Type_, Name) ->
    Name@1 = glam@doc:from_string(Name),
    case Type_ of
        {list, Type_@1} ->
            {State@1, Inner_encoder} = gleam_type_to_encoder(
                State,
                Type_@1,
                <<"value"/utf8>>
            ),
            Map_fn = fn_doc([<<"value"/utf8>>], Inner_encoder),
            Doc = call_doc(<<"pog.array"/utf8>>, [Map_fn, Name@1]),
            {State@1, Doc};

        {option, Type_@2} ->
            {State@2, Inner_encoder@1} = gleam_type_to_encoder(
                State,
                Type_@2,
                <<"value"/utf8>>
            ),
            Doc@1 = call_doc(
                <<"pog.nullable"/utf8>>,
                [fn_doc([<<"value"/utf8>>], Inner_encoder@1), Name@1]
            ),
            {State@2, Doc@1};

        uuid ->
            State@3 = begin
                _pipe = State,
                import_module(_pipe, <<"youid/uuid"/utf8>>)
            end,
            Doc@2 = call_doc(
                <<"pog.text"/utf8>>,
                [call_doc(<<"uuid.to_string"/utf8>>, [Name@1])]
            ),
            {State@3, Doc@2};

        json ->
            State@4 = begin
                _pipe@1 = State,
                import_module(_pipe@1, <<"gleam/json"/utf8>>)
            end,
            Doc@3 = call_doc(
                <<"pog.text"/utf8>>,
                [call_doc(<<"json.to_string"/utf8>>, [Name@1])]
            ),
            {State@4, Doc@3};

        date ->
            {State, call_doc(<<"pog.calendar_date"/utf8>>, [Name@1])};

        time_of_day ->
            {State, call_doc(<<"pog.calendar_time_of_day"/utf8>>, [Name@1])};

        timestamp ->
            {State, call_doc(<<"pog.timestamp"/utf8>>, [Name@1])};

        int ->
            {State, call_doc(<<"pog.int"/utf8>>, [Name@1])};

        float ->
            {State, call_doc(<<"pog.float"/utf8>>, [Name@1])};

        numeric ->
            {State, call_doc(<<"pog.float"/utf8>>, [Name@1])};

        bool ->
            {State, call_doc(<<"pog.bool"/utf8>>, [Name@1])};

        string ->
            {State, call_doc(<<"pog.text"/utf8>>, [Name@1])};

        bit_array ->
            {State, call_doc(<<"pog.bytea"/utf8>>, [Name@1])};

        {enum, Original_name, Enum_name, Variants} ->
            {add_enum_helpers(
                    State,
                    Original_name,
                    Enum_name,
                    Variants,
                    needs_encoder
                ),
                call_doc(enum_encoder_name(Enum_name), [Name@1])}
    end.

-file("src/squirrel/internal/query.gleam", 822).
?DOC(false).
-spec decoder_doc(
    code_gen_state(),
    binary(),
    list(squirrel@internal@gleam:field())
) -> {code_gen_state(), glam@doc:document()}.
decoder_doc(State, Constructor, Returns) ->
    Fallback = {State,
        glam@doc:from_string(
            <<"decode.map(decode.dynamic, fn(_) { Nil })"/utf8>>
        )},
    gleam@bool:guard(
        Returns =:= [],
        Fallback,
        fun() ->
            {State@3, Parameters@2, Labelled_names@2} = begin
                gleam@list:index_fold(
                    Returns,
                    {State, [], []},
                    fun(Acc, Field, I) ->
                        {State@1, Parameters, Labelled_names} = Acc,
                        Label = squirrel@internal@gleam:value_identifier_to_string(
                            erlang:element(2, Field)
                        ),
                        Labelled_names@1 = [glam@doc:from_string(
                                <<Label/binary, ":"/utf8>>
                            ) |
                            Labelled_names],
                        Position = begin
                            _pipe = erlang:integer_to_binary(I),
                            glam@doc:from_string(_pipe)
                        end,
                        {State@2, Decoder} = gleam_type_to_decoder(
                            State@1,
                            erlang:element(3, Field)
                        ),
                        Param = begin
                            _pipe@1 = glam@doc:from_string(
                                <<<<"use "/utf8, Label/binary>>/binary,
                                    " <- "/utf8>>
                            ),
                            glam@doc:append(
                                _pipe@1,
                                call_doc(
                                    <<"decode.field"/utf8>>,
                                    [Position, Decoder]
                                )
                            )
                        end,
                        Parameters@1 = [Param | Parameters],
                        {State@2, Parameters@1, Labelled_names@1}
                    end
                )
            end,
            Parameters@3 = lists:reverse(Parameters@2),
            Labelled_names@3 = lists:reverse(Labelled_names@2),
            Success_line = nested_calls_doc(
                <<"decode.success"/utf8>>,
                Constructor,
                Labelled_names@3
            ),
            Doc = block(lists:append(Parameters@3, [Success_line])),
            {State@3, Doc}
        end
    ).

-file("src/squirrel/internal/query.gleam", 488).
?DOC(false).
-spec query_doc(code_gen_state(), binary(), typed_query()) -> {code_gen_state(),
    glam@doc:document()}.
query_doc(State, Version, Query) ->
    {typed_query, _, _, Name, _, Content, Params, Returns} = Query,
    Constructor_name = begin
        _pipe = squirrel@internal@gleam:value_identifier_to_type_identifier(
            Name
        ),
        _pipe@1 = squirrel@internal@gleam:type_identifier_to_string(_pipe),
        gleam@string:append(_pipe@1, <<"Row"/utf8>>)
    end,
    Record_result = record_doc(State, Version, Constructor_name, Query),
    {State@2, Record@1} = case Record_result of
        {ok, {State@1, Record}} ->
            {State@1, glam@doc:append(Record, glam@doc:lines(2))};

        {error, _} ->
            {State, {concat, []}}
    end,
    {State@6, Args@1, Encoders@1} = begin
        Acc = {State@2, [], []},
        gleam@list:index_fold(
            Params,
            Acc,
            fun(_use0, Param, I) ->
                {State@3, Args, Encoders} = _use0,
                Arg = <<"arg_"/utf8, (erlang:integer_to_binary(I + 1))/binary>>,
                {State@4, Arg_type} = gleam_type_to_field_type(
                    State@3,
                    Param,
                    function_argument
                ),
                {State@5, Encoder} = gleam_type_to_encoder(State@4, Param, Arg),
                Arg@1 = glam@doc:concat(
                    [glam@doc:from_string(<<Arg/binary, ": "/utf8>>), Arg_type]
                ),
                {State@5, [Arg@1 | Args], [Encoder | Encoders]}
            end
        )
    end,
    Args@2 = lists:reverse(Args@1),
    Encoders@2 = lists:reverse(Encoders@1),
    {State@7, Decoder} = decoder_doc(State@6, Constructor_name, Returns),
    Args@3 = [glam@doc:from_string(<<"db: pog.Connection"/utf8>>) | Args@2],
    Returned = case Returns of
        [] ->
            glam@doc:from_string(<<"pog.Returned(Nil)"/utf8>>);

        _ ->
            call_doc(
                <<"pog.Returned"/utf8>>,
                [glam@doc:from_string(Constructor_name)]
            )
    end,
    Return = call_doc(
        <<"Result"/utf8>>,
        [Returned, glam@doc:from_string(<<"pog.QueryError"/utf8>>)]
    ),
    Code = glam@doc:concat(
        [Record@1,
            glam@doc:from_string(function_doc(Version, Query)),
            {line, 1},
            fun_doc(
                public,
                squirrel@internal@gleam:value_identifier_to_string(Name),
                Args@3,
                Return,
                [begin
                        _pipe@2 = let_var(<<"decoder"/utf8>>, Decoder),
                        glam@doc:append(
                            _pipe@2,
                            glam@doc:from_string(<<"\n"/utf8>>)
                        )
                    end,
                    begin
                        _pipe@3 = string_doc(Content),
                        _pipe@4 = pipe_call_doc(
                            <<"pog.query"/utf8>>,
                            _pipe@3,
                            []
                        ),
                        _pipe@5 = pipe_all_encoders(_pipe@4, Encoders@2),
                        _pipe@6 = pipe_call_doc(
                            <<"pog.returning"/utf8>>,
                            _pipe@5,
                            [glam@doc:from_string(<<"decoder"/utf8>>)]
                        ),
                        pipe_call_doc(
                            <<"pog.execute"/utf8>>,
                            _pipe@6,
                            [glam@doc:from_string(<<"db"/utf8>>)]
                        )
                    end]
            )]
    ),
    {State@7, Code}.

-file("src/squirrel/internal/query.gleam", 374).
?DOC(false).
-spec generate_code(binary(), list(typed_query()), binary()) -> binary().
generate_code(Version, Queries, Directory) ->
    Queries@1 = gleam@list:sort(
        Queries,
        fun(One, Other) ->
            gleam@string:compare(
                erlang:element(2, One),
                erlang:element(2, Other)
            )
        end
    ),
    {State@3, Queries_docs} = begin
        State = default_codegen_state(),
        gleam@list:fold(
            Queries@1,
            {State, []},
            fun(_use0, Query) ->
                {State@1, Docs} = _use0,
                {State@2, Doc} = query_doc(State@1, Version, Query),
                {State@2, [Doc | Docs]}
            end
        )
    end,
    Queries_docs@1 = lists:reverse(Queries_docs),
    {code_gen_state, Imports, Needs_uuid_decoder, Enums} = State@3,
    Utils = begin
        _pipe = [],
        prepend_if(
            _pipe,
            Needs_uuid_decoder,
            glam@doc:from_string(
                <<"/// A decoder to decode `Uuid`s coming from a Postgres query.
///
fn uuid_decoder() {
  use bit_array <- decode.then(decode.bit_array)
  case uuid.from_bit_array(bit_array) {
    Ok(uuid) -> decode.success(uuid)
    Error(_) -> decode.failure(uuid.v7(), \"Uuid\")
  }
}"/utf8>>
            )
        )
    end,
    Code = begin
        _pipe@1 = [imports_doc(Imports),
            glam@doc:lines(2),
            glam@doc:join(Queries_docs@1, glam@doc:lines(2))],
        glam@doc:concat(_pipe@1)
    end,
    Code@1 = case gleam@dict:is_empty(Enums) of
        true ->
            Code;

        false ->
            _pipe@2 = [Code,
                glam@doc:lines(2),
                separator_comment(<<"Enums"/utf8>>),
                glam@doc:lines(2),
                enums_doc(Version, Enums)],
            glam@doc:concat(_pipe@2)
    end,
    Code@2 = case Utils of
        [] ->
            Code@1;

        [_ | _] ->
            _pipe@3 = [Code@1,
                glam@doc:lines(2),
                separator_comment(<<"Encoding/decoding utils"/utf8>>),
                glam@doc:lines(2),
                glam@doc:join(Utils, glam@doc:lines(2))],
            glam@doc:concat(_pipe@3)
    end,
    _pipe@4 = glam@doc:concat(
        [glam@doc:from_string(module_doc(Version, Directory)),
            glam@doc:lines(2),
            Code@2,
            {line, 1}]
    ),
    glam@doc:to_string(_pipe@4, 80).
