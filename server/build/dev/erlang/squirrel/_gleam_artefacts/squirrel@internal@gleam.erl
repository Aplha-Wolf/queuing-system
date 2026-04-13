-module(squirrel@internal@gleam).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/squirrel/internal/gleam.gleam").
-export([value_identifier_to_string/1, type_identifier_to_string/1, value_identifier_to_type_identifier/1, type_identifier_to_value_identifier/1, value_identifier/1, type_identifier/1, try_make_enum/2, similar_value_identifier_string/1]).
-export_type([type/0, enum_variant/0, field/0, value_identifier/0, type_identifier/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-type type() :: {list, type()} |
    {option, type()} |
    date |
    time_of_day |
    timestamp |
    bit_array |
    int |
    float |
    numeric |
    bool |
    string |
    json |
    uuid |
    {enum,
        binary(),
        type_identifier(),
        non_empty_list:non_empty_list(enum_variant())}.

-type enum_variant() :: {enum_variant, type_identifier(), binary()}.

-type field() :: {field, value_identifier(), type()}.

-opaque value_identifier() :: {value_identifier, binary()}.

-opaque type_identifier() :: {type_identifier, binary()}.

-file("src/squirrel/internal/gleam.gleam", 124).
?DOC(false).
-spec value_identifier_to_string(value_identifier()) -> binary().
value_identifier_to_string(Identifier) ->
    {value_identifier, Name} = Identifier,
    Name.

-file("src/squirrel/internal/gleam.gleam", 170).
?DOC(false).
-spec type_identifier_to_string(type_identifier()) -> binary().
type_identifier_to_string(Identifier) ->
    {type_identifier, Name} = Identifier,
    Name.

-file("src/squirrel/internal/gleam.gleam", 178).
?DOC(false).
-spec value_identifier_to_type_identifier(value_identifier()) -> type_identifier().
value_identifier_to_type_identifier(Identifier) ->
    {value_identifier, Name} = Identifier,
    Type_identifier = begin
        _pipe = justin:pascal_case(Name),
        _pipe@1 = gleam@string:to_graphemes(_pipe),
        _pipe@2 = gleam@list:filter(_pipe@1, fun(C) -> C /= <<"_"/utf8>> end),
        gleam@string:join(_pipe@2, <<""/utf8>>)
    end,
    {type_identifier, Type_identifier}.

-file("src/squirrel/internal/gleam.gleam", 197).
?DOC(false).
-spec type_identifier_to_value_identifier(type_identifier()) -> value_identifier().
type_identifier_to_value_identifier(Identifier) ->
    {type_identifier, Name} = Identifier,
    {value_identifier, justin:snake_case(Name)}.

-file("src/squirrel/internal/gleam.gleam", 265).
?DOC(false).
-spec is_digit(binary()) -> boolean().
is_digit(Char) ->
    case Char of
        <<"0"/utf8>> ->
            true;

        <<"1"/utf8>> ->
            true;

        <<"2"/utf8>> ->
            true;

        <<"3"/utf8>> ->
            true;

        <<"4"/utf8>> ->
            true;

        <<"5"/utf8>> ->
            true;

        <<"6"/utf8>> ->
            true;

        <<"7"/utf8>> ->
            true;

        <<"8"/utf8>> ->
            true;

        <<"9"/utf8>> ->
            true;

        _ ->
            false
    end.

-file("src/squirrel/internal/gleam.gleam", 272).
?DOC(false).
-spec is_lowercase_letter(binary()) -> boolean().
is_lowercase_letter(Char) ->
    case Char of
        <<"a"/utf8>> ->
            true;

        <<"b"/utf8>> ->
            true;

        <<"c"/utf8>> ->
            true;

        <<"d"/utf8>> ->
            true;

        <<"e"/utf8>> ->
            true;

        <<"f"/utf8>> ->
            true;

        <<"g"/utf8>> ->
            true;

        <<"h"/utf8>> ->
            true;

        <<"i"/utf8>> ->
            true;

        <<"j"/utf8>> ->
            true;

        <<"k"/utf8>> ->
            true;

        <<"l"/utf8>> ->
            true;

        <<"m"/utf8>> ->
            true;

        <<"n"/utf8>> ->
            true;

        <<"o"/utf8>> ->
            true;

        <<"p"/utf8>> ->
            true;

        <<"q"/utf8>> ->
            true;

        <<"r"/utf8>> ->
            true;

        <<"s"/utf8>> ->
            true;

        <<"t"/utf8>> ->
            true;

        <<"u"/utf8>> ->
            true;

        <<"v"/utf8>> ->
            true;

        <<"w"/utf8>> ->
            true;

        <<"x"/utf8>> ->
            true;

        <<"y"/utf8>> ->
            true;

        <<"z"/utf8>> ->
            true;

        _ ->
            false
    end.

-file("src/squirrel/internal/gleam.gleam", 102).
?DOC(false).
-spec to_value_identifier_rest(binary(), binary(), integer()) -> {ok,
        value_identifier()} |
    {error, squirrel@internal@error:value_identifier_error()}.
to_value_identifier_rest(Name, Rest, Position) ->
    case gleam_stdlib:string_pop_grapheme(Rest) of
        {error, _} ->
            {ok, {value_identifier, Name}};

        {ok, {Char, Rest@1}} ->
            Is_valid_char = ((Char =:= <<"_"/utf8>>) orelse is_lowercase_letter(
                Char
            ))
            orelse is_digit(Char),
            case Is_valid_char of
                true ->
                    to_value_identifier_rest(Name, Rest@1, Position + 1);

                false ->
                    {error, {value_contains_invalid_grapheme, Position, Char}}
            end
    end.

-file("src/squirrel/internal/gleam.gleam", 87).
?DOC(false).
-spec value_identifier(binary()) -> {ok, value_identifier()} |
    {error, squirrel@internal@error:value_identifier_error()}.
value_identifier(Name) ->
    case gleam_stdlib:string_pop_grapheme(Name) of
        {error, _} ->
            {error, value_is_empty};

        {ok, {Char, Rest}} ->
            case is_lowercase_letter(Char) of
                true ->
                    to_value_identifier_rest(Name, Rest, 1);

                false ->
                    {error, {value_contains_invalid_grapheme, 0, Char}}
            end
    end.

-file("src/squirrel/internal/gleam.gleam", 282).
?DOC(false).
-spec is_uppercase_letter(binary()) -> boolean().
is_uppercase_letter(Char) ->
    case Char of
        <<"A"/utf8>> ->
            true;

        <<"B"/utf8>> ->
            true;

        <<"C"/utf8>> ->
            true;

        <<"D"/utf8>> ->
            true;

        <<"E"/utf8>> ->
            true;

        <<"F"/utf8>> ->
            true;

        <<"G"/utf8>> ->
            true;

        <<"H"/utf8>> ->
            true;

        <<"I"/utf8>> ->
            true;

        <<"J"/utf8>> ->
            true;

        <<"K"/utf8>> ->
            true;

        <<"L"/utf8>> ->
            true;

        <<"M"/utf8>> ->
            true;

        <<"N"/utf8>> ->
            true;

        <<"O"/utf8>> ->
            true;

        <<"P"/utf8>> ->
            true;

        <<"Q"/utf8>> ->
            true;

        <<"R"/utf8>> ->
            true;

        <<"S"/utf8>> ->
            true;

        <<"T"/utf8>> ->
            true;

        <<"U"/utf8>> ->
            true;

        <<"V"/utf8>> ->
            true;

        <<"W"/utf8>> ->
            true;

        <<"X"/utf8>> ->
            true;

        <<"Y"/utf8>> ->
            true;

        <<"Z"/utf8>> ->
            true;

        _ ->
            false
    end.

-file("src/squirrel/internal/gleam.gleam", 148).
?DOC(false).
-spec to_type_identifier_rest(binary(), binary(), integer()) -> {ok,
        type_identifier()} |
    {error, squirrel@internal@error:type_identifier_error()}.
to_type_identifier_rest(Name, Rest, Position) ->
    case gleam_stdlib:string_pop_grapheme(Rest) of
        {error, _} ->
            {ok, {type_identifier, Name}};

        {ok, {Char, Rest@1}} ->
            Is_valid_char = (is_lowercase_letter(Char) orelse is_uppercase_letter(
                Char
            ))
            orelse is_digit(Char),
            case Is_valid_char of
                true ->
                    to_type_identifier_rest(Name, Rest@1, Position + 1);

                false ->
                    {error, {type_contains_invalid_grapheme, Position, Char}}
            end
    end.

-file("src/squirrel/internal/gleam.gleam", 134).
?DOC(false).
-spec type_identifier(binary()) -> {ok, type_identifier()} |
    {error, squirrel@internal@error:type_identifier_error()}.
type_identifier(Name) ->
    case gleam_stdlib:string_pop_grapheme(Name) of
        {error, _} ->
            {error, type_is_empty};

        {ok, {Char, Rest}} ->
            case is_uppercase_letter(Char) of
                false ->
                    {error, {type_contains_invalid_grapheme, 0, Char}};

                true ->
                    to_type_identifier_rest(Name, Rest, 1)
            end
    end.

-file("src/squirrel/internal/gleam.gleam", 228).
?DOC(false).
-spec try_make_enum(binary(), list(binary())) -> {ok, type()} |
    {error, squirrel@internal@error:enum_error()}.
try_make_enum(Raw_name, Variants) ->
    gleam@result:'try'(
        begin
            _pipe = justin:pascal_case(Raw_name),
            _pipe@1 = type_identifier(_pipe),
            gleam@result:replace_error(_pipe@1, {invalid_enum_name, Raw_name})
        end,
        fun(Name) ->
            {Variants@1, Errors} = gleam@result:partition(
                begin
                    gleam@list:map(
                        Variants,
                        fun(Variant) ->
                            case type_identifier(justin:pascal_case(Variant)) of
                                {ok, Name@1} ->
                                    {ok, {enum_variant, Name@1, Variant}};

                                {error, _} ->
                                    {error, Variant}
                            end
                        end
                    )
                end
            ),
            case Errors of
                [] ->
                    case non_empty_list:from_list(Variants@1) of
                        {ok, Variants@2} ->
                            {ok, {enum, Raw_name, Name, Variants@2}};

                        {error, _} ->
                            {error, enum_with_no_variants}
                    end;

                _ ->
                    {error, {invalid_enum_variants, Errors}}
            end
        end
    ).

-file("src/squirrel/internal/gleam.gleam", 291).
?DOC(false).
-spec is_identifier_char(binary()) -> boolean().
is_identifier_char(Char) ->
    ((Char =:= <<"_"/utf8>>) orelse is_lowercase_letter(Char)) orelse is_digit(
        Char
    ).

-file("src/squirrel/internal/gleam.gleam", 209).
?DOC(false).
-spec similar_value_identifier_string(binary()) -> {ok, binary()} | {error, nil}.
similar_value_identifier_string(String) ->
    Proposal = begin
        _pipe = gleam@string:trim(String),
        _pipe@1 = justin:snake_case(_pipe),
        _pipe@2 = gleam@string:to_graphemes(_pipe@1),
        _pipe@3 = gleam@list:drop_while(
            _pipe@2,
            fun(G) -> (G =:= <<"_"/utf8>>) orelse is_digit(G) end
        ),
        _pipe@4 = gleam@list:filter(_pipe@3, fun is_identifier_char/1),
        gleam@string:join(_pipe@4, <<""/utf8>>)
    end,
    case Proposal of
        <<""/utf8>> ->
            {error, nil};

        _ ->
            {ok, Proposal}
    end.
