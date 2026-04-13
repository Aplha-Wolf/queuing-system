-module(squirrel@internal@database@postgres_protocol).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/squirrel/internal/database/postgres_protocol.gleam").
-export([connect/3, send_builder/2, send/2, encode_backend_message/1, decode_frontend_message/1, decode_frontend_packet/1, decode_backend_message/1, decode_backend_packet/1, 'receive'/1, start/2, encode_frontend_message/1]).
-export_type([connection/0, state_initial/0, state/0, startup_failed/0, read_error/0, message_decoding_error/0, command/0, backend_message/0, copy_direction/0, format/0, format_value/0, parameter_value/0, frontend_message/0, fe_ambigous/0, what/0, transaction_status/0, data_row/0, row_description_field/0, error_or_notice_field/0, binary_split_option/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-type connection() :: {connection, mug:socket(), bitstring(), integer()}.

-type state_initial() :: {state_initial, gleam@dict:dict(binary(), binary())}.

-type state() :: {state,
        integer(),
        integer(),
        gleam@dict:dict(binary(), binary()),
        gleam@dict:dict(integer(), fun((bitstring()) -> {ok, integer()} |
            {error, nil}))}.

-type startup_failed() :: {startup_failed_with_unexpected_message,
        backend_message()} |
    {startup_failed_with_error, read_error()}.

-type read_error() :: {socket_error, mug:error()} |
    {read_decode_error, message_decoding_error()}.

-type message_decoding_error() :: {message_decoding_error, binary()} |
    {message_incomplete, bitstring()} |
    {unknown_message, bitstring()}.

-type command() :: insert |
    delete |
    update |
    merge |
    select |
    move |
    fetch |
    copy.

-type backend_message() :: be_bind_complete |
    be_close_complete |
    {be_command_complete, command(), integer()} |
    {be_copy_data, bitstring()} |
    be_copy_done |
    be_authentication_ok |
    be_authentication_kerberos_v5 |
    be_authentication_cleartext_password |
    {be_authentication_m_d5_password, bitstring()} |
    be_authentication_g_s_s |
    {be_authentication_g_s_s_continue, bitstring()} |
    be_authentication_s_s_p_i |
    {be_authentication_s_a_s_l, list(binary())} |
    {be_authentication_s_a_s_l_continue, bitstring()} |
    {be_authentication_s_a_s_l_final, bitstring()} |
    {be_ready_for_query, transaction_status()} |
    {be_row_descriptions, list(row_description_field())} |
    {be_message_data_row, list(bitstring())} |
    {be_backend_key_data, integer(), integer()} |
    {be_parameter_status, binary(), binary()} |
    {be_copy_response, copy_direction(), format(), list(format())} |
    {be_negotiate_protocol_version, integer(), list(binary())} |
    be_no_data |
    {be_notice_response, gleam@set:set(error_or_notice_field())} |
    {be_notification_response, integer(), binary(), binary()} |
    {be_parameter_description, list(integer())} |
    be_parse_complete |
    be_portal_suspended |
    {be_error_response, gleam@set:set(error_or_notice_field())}.

-type copy_direction() :: in | out | both.

-type format() :: text | binary.

-type format_value() :: format_all_text |
    {format_all, format()} |
    {formats, list(format())}.

-type parameter_value() :: {parameter, bitstring()} | null.

-type frontend_message() :: {fe_bind,
        binary(),
        binary(),
        format_value(),
        list(parameter_value()),
        format_value()} |
    {fe_cancel_request, integer(), integer()} |
    {fe_close, what(), binary()} |
    {fe_copy_data, bitstring()} |
    fe_copy_done |
    {fe_copy_fail, binary()} |
    {fe_describe, what(), binary()} |
    {fe_execute, binary(), integer()} |
    fe_flush |
    {fe_function_call,
        integer(),
        format_value(),
        list(parameter_value()),
        format()} |
    fe_gss_enc_request |
    {fe_parse, binary(), binary(), list(integer())} |
    {fe_query, binary()} |
    {fe_startup_message, list({binary(), binary()})} |
    fe_ssl_request |
    fe_terminate |
    fe_sync |
    {fe_ambigous, fe_ambigous()}.

-type fe_ambigous() :: {fe_gss_response, bitstring()} |
    {fe_sasl_initial_response, binary(), bitstring()} |
    {fe_sasl_response, bitstring()} |
    {fe_password_message, binary()}.

-type what() :: prepared_statement | portal.

-type transaction_status() :: transaction_status_idle |
    transaction_status_in_transaction |
    transaction_status_failed.

-type data_row() :: {data_row, list(bitstring())}.

-type row_description_field() :: {row_description_field,
        binary(),
        integer(),
        integer(),
        integer(),
        integer(),
        integer(),
        integer()}.

-type error_or_notice_field() :: {code, binary()} |
    {detail, binary()} |
    {file, binary()} |
    {hint, binary()} |
    {line, binary()} |
    {message, binary()} |
    {position, binary()} |
    {routine, binary()} |
    {severity_localized, binary()} |
    {severity, binary()} |
    {where, binary()} |
    {column, binary()} |
    {data_type, binary()} |
    {constraint, binary()} |
    {internal_position, binary()} |
    {internal_query, binary()} |
    {schema, binary()} |
    {table, binary()} |
    {unknown, bitstring(), binary()}.

-type binary_split_option() :: global.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 27).
?DOC(false).
-spec connect(binary(), integer(), integer()) -> {ok, connection()} |
    {error, mug:connect_error()}.
connect(Host, Port, Timeout) ->
    Options = {connection_options, Host, Port, Timeout, ipv4_preferred},
    gleam@result:'try'(
        mug:connect(Options),
        fun(Socket) -> {ok, {connection, Socket, <<>>, Timeout}} end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 52).
?DOC(false).
-spec default_oids() -> gleam@dict:dict(integer(), fun((bitstring()) -> {ok,
        integer()} |
    {error, nil})).
default_oids() ->
    _pipe = maps:new(),
    gleam@dict:insert(
        _pipe,
        23,
        fun(Col) ->
            gleam@result:'try'(
                gleam@bit_array:to_string(Col),
                fun(Converted) -> gleam_stdlib:parse_int(Converted) end
            )
        end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 124).
?DOC(false).
-spec dec_err(binary(), bitstring()) -> {ok, any()} |
    {error, message_decoding_error()}.
dec_err(Desc, Data) ->
    {error,
        {message_decoding_error,
            <<<<Desc/binary, "; data: "/utf8>>/binary,
                (gleam@bit_array:inspect(Data))/binary>>}}.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 128).
?DOC(false).
-spec msg_dec_err(binary(), bitstring()) -> message_decoding_error().
msg_dec_err(Desc, Data) ->
    {message_decoding_error,
        <<<<Desc/binary, "; data: "/utf8>>/binary,
            (gleam@bit_array:inspect(Data))/binary>>}.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 225).
?DOC(false).
-spec parameters_to_bytes(list(parameter_value())) -> bitstring().
parameters_to_bytes(Parameters) ->
    Mapped = begin
        _pipe = Parameters,
        gleam@list:map(_pipe, fun(Parameter) -> case Parameter of
                    {parameter, Value} ->
                        <<(erlang:byte_size(Value)):32, Value/bitstring>>;

                    null ->
                        <<-1:32>>
                end end)
    end,
    <<(erlang:length(Parameters)):16,
        (gleam_stdlib:bit_array_concat(Mapped))/bitstring>>.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 283).
?DOC(false).
-spec wire_what(what()) -> bitstring().
wire_what(What) ->
    case What of
        portal ->
            <<"P"/utf8>>;

        prepared_statement ->
            <<"S"/utf8>>
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 290).
?DOC(false).
-spec decode_what(bitstring()) -> {ok, {what(), bitstring()}} |
    {error, message_decoding_error()}.
decode_what(Binary) ->
    case Binary of
        <<"P"/utf8, Rest/binary>> ->
            {ok, {portal, Rest}};

        <<"S"/utf8, Rest@1/binary>> ->
            {ok, {prepared_statement, Rest@1}};

        _ ->
            dec_err(
                <<"only portal and prepared statement are allowed"/utf8>>,
                Binary
            )
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 313).
?DOC(false).
-spec encode_field(error_or_notice_field()) -> bitstring().
encode_field(Field) ->
    case Field of
        {severity, Value} ->
            <<"S"/utf8, Value/binary, 0>>;

        {severity_localized, Value@1} ->
            <<"V"/utf8, Value@1/binary, 0>>;

        {code, Value@2} ->
            <<"C"/utf8, Value@2/binary, 0>>;

        {message, Value@3} ->
            <<"M"/utf8, Value@3/binary, 0>>;

        {detail, Value@4} ->
            <<"D"/utf8, Value@4/binary, 0>>;

        {hint, Value@5} ->
            <<"H"/utf8, Value@5/binary, 0>>;

        {position, Value@6} ->
            <<"P"/utf8, Value@6/binary, 0>>;

        {internal_position, Value@7} ->
            <<"p"/utf8, Value@7/binary, 0>>;

        {internal_query, Value@8} ->
            <<"q"/utf8, Value@8/binary, 0>>;

        {where, Value@9} ->
            <<"W"/utf8, Value@9/binary, 0>>;

        {schema, Value@10} ->
            <<"s"/utf8, Value@10/binary, 0>>;

        {table, Value@11} ->
            <<"t"/utf8, Value@11/binary, 0>>;

        {column, Value@12} ->
            <<"c"/utf8, Value@12/binary, 0>>;

        {data_type, Value@13} ->
            <<"d"/utf8, Value@13/binary, 0>>;

        {constraint, Value@14} ->
            <<"n"/utf8, Value@14/binary, 0>>;

        {file, Value@15} ->
            <<"F"/utf8, Value@15/binary, 0>>;

        {line, Value@16} ->
            <<"L"/utf8, Value@16/binary, 0>>;

        {routine, Value@17} ->
            <<"R"/utf8, Value@17/binary, 0>>;

        {unknown, Key, Value@18} ->
            <<Key/bitstring, 0, Value@18/binary, 0>>
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 524).
?DOC(false).
-spec encode(binary(), bitstring()) -> bitstring().
encode(Type_char, Data) ->
    case Data of
        <<>> ->
            <<Type_char/binary, 4:32>>;

        _ ->
            Len = erlang:byte_size(Data) + 4,
            <<Type_char/binary, Len:32, Data/bitstring>>
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 298).
?DOC(false).
-spec encode_message_data_row(list(bitstring())) -> bitstring().
encode_message_data_row(Columns) ->
    _pipe = <<(erlang:length(Columns)):16>>,
    _pipe@1 = gleam@list:fold(
        Columns,
        _pipe,
        fun(Sum, Column) ->
            Len = erlang:byte_size(Column),
            <<Sum/bitstring, Len:32, Column/bitstring>>
        end
    ),
    encode(<<"D"/utf8>>, _pipe@1).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 307).
?DOC(false).
-spec encode_error_response(gleam@set:set(error_or_notice_field())) -> bitstring().
encode_error_response(Fields) ->
    _pipe = Fields,
    _pipe@1 = gleam@set:fold(
        _pipe,
        <<>>,
        fun(Sum, Field) ->
            <<Sum/bitstring, (encode_field(Field))/bitstring>>
        end
    ),
    encode(<<"E"/utf8>>, _pipe@1).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 412).
?DOC(false).
-spec encode_notice_response(gleam@set:set(error_or_notice_field())) -> bitstring().
encode_notice_response(Fields) ->
    _pipe = Fields,
    _pipe@1 = gleam@set:fold(
        _pipe,
        <<>>,
        fun(Sum, Field) ->
            <<Sum/bitstring, (encode_field(Field))/bitstring>>
        end
    ),
    encode(<<"N"/utf8>>, _pipe@1).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 418).
?DOC(false).
-spec encode_notification_response(integer(), binary(), binary()) -> bitstring().
encode_notification_response(Process_id, Channel, Payload) ->
    encode(
        <<"A"/utf8>>,
        <<Process_id:32, Channel/binary, 0, Payload/binary, 0>>
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 426).
?DOC(false).
-spec encode_parameter_description(list(integer())) -> bitstring().
encode_parameter_description(Descriptions) ->
    _pipe = Descriptions,
    _pipe@1 = gleam@list:fold(
        _pipe,
        <<(erlang:length(Descriptions)):16>>,
        fun(Sum, Description) -> <<Sum/bitstring, Description:32>> end
    ),
    encode(<<"t"/utf8>>, _pipe@1).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 534).
?DOC(false).
-spec encode_string(binary()) -> bitstring().
encode_string(Str) ->
    <<Str/binary, 0>>.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 337).
?DOC(false).
-spec encode_authentication_sasl(list(binary())) -> bitstring().
encode_authentication_sasl(Mechanisms) ->
    _pipe = gleam@list:fold(
        Mechanisms,
        <<10:32>>,
        fun(Sum, Mechanism) ->
            <<Sum/bitstring, (encode_string(Mechanism))/bitstring>>
        end
    ),
    encode(<<"R"/utf8>>, _pipe).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 344).
?DOC(false).
-spec encode_command_complete(command(), integer()) -> bitstring().
encode_command_complete(Command, Rows_num) ->
    Rows = erlang:integer_to_binary(Rows_num),
    Data = begin
        _pipe = case Command of
            insert ->
                <<"INSERT 0 "/utf8, Rows/binary>>;

            delete ->
                <<"DELETE "/utf8, Rows/binary>>;

            update ->
                <<"UPDATE "/utf8, Rows/binary>>;

            merge ->
                <<"MERGE "/utf8, Rows/binary>>;

            select ->
                <<"SELECT "/utf8, Rows/binary>>;

            move ->
                <<"MOVE "/utf8, Rows/binary>>;

            fetch ->
                <<"FETCH "/utf8, Rows/binary>>;

            copy ->
                <<"COPY "/utf8, Rows/binary>>
        end,
        encode_string(_pipe)
    end,
    encode(<<"C"/utf8>>, Data).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 396).
?DOC(false).
-spec encode_parameter_status(binary(), binary()) -> bitstring().
encode_parameter_status(Name, Value) ->
    encode(
        <<"S"/utf8>>,
        <<(encode_string(Name))/bitstring, (encode_string(Value))/bitstring>>
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 400).
?DOC(false).
-spec encode_negotiate_protocol_version(integer(), list(binary())) -> bitstring().
encode_negotiate_protocol_version(Newest_minor, Unrecognized_options) ->
    _pipe = gleam@list:fold(
        Unrecognized_options,
        <<Newest_minor:32, (erlang:length(Unrecognized_options)):32>>,
        fun(Sum, Option) ->
            <<Sum/bitstring, (encode_string(Option))/bitstring>>
        end
    ),
    encode(<<"v"/utf8>>, _pipe).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 434).
?DOC(false).
-spec encode_row_descriptions(list(row_description_field())) -> bitstring().
encode_row_descriptions(Fields) ->
    _pipe = Fields,
    _pipe@1 = gleam@list:fold(
        _pipe,
        <<(erlang:length(Fields)):16>>,
        fun(Sum, Field) ->
            <<Sum/bitstring,
                (encode_string(erlang:element(2, Field)))/bitstring,
                (erlang:element(3, Field)):32,
                (erlang:element(4, Field)):16,
                (erlang:element(5, Field)):32,
                (erlang:element(6, Field)):16,
                (erlang:element(7, Field)):32,
                (erlang:element(8, Field)):16>>
        end
    ),
    encode(<<"T"/utf8>>, _pipe@1).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 560).
?DOC(false).
-spec encode_sasl_initial_response(binary(), bitstring()) -> bitstring().
encode_sasl_initial_response(Name, Data) ->
    Len = erlang:byte_size(Data),
    encode(
        <<"p"/utf8>>,
        <<(encode_string(Name))/bitstring, Len:32, Data/bitstring>>
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 565).
?DOC(false).
-spec encode_parse(binary(), binary(), list(integer())) -> bitstring().
encode_parse(Name, Query, Parameter_object_ids) ->
    Oids = gleam@list:fold(
        Parameter_object_ids,
        <<>>,
        fun(Sum, Oid) -> <<Sum/bitstring, Oid:32>> end
    ),
    Len = erlang:length(Parameter_object_ids),
    encode(
        <<"P"/utf8>>,
        <<(encode_string(Name))/bitstring,
            (encode_string(Query))/bitstring,
            Len:16,
            Oids/bitstring>>
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 610).
?DOC(false).
-spec send_builder(connection(), gleam@bytes_tree:bytes_tree()) -> {ok,
        connection()} |
    {error, mug:error()}.
send_builder(Conn, Message) ->
    case mug_ffi:send(erlang:element(2, Conn), Message) of
        {ok, nil} ->
            {ok, Conn};

        {error, Err} ->
            {error, Err}
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 618).
?DOC(false).
-spec send(connection(), bitstring()) -> {ok, connection()} |
    {error, mug:error()}.
send(Conn, Message) ->
    case mug:send(erlang:element(2, Conn), Message) of
        {ok, nil} ->
            {ok, Conn};

        {error, Err} ->
            {error, Err}
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 642).
?DOC(false).
-spec with_buffer(connection(), bitstring()) -> connection().
with_buffer(Conn, Buffer) ->
    {connection, erlang:element(2, Conn), Buffer, erlang:element(4, Conn)}.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 814).
?DOC(false).
-spec decode_parameter_object_ids_rec(bitstring(), integer(), list(integer())) -> {ok,
        list(integer())} |
    {error, message_decoding_error()}.
decode_parameter_object_ids_rec(Binary, Count, Result) ->
    case {Count, Binary} of
        {0, <<>>} ->
            {ok, lists:reverse(Result)};

        {_, <<Id:32, Rest/binary>>} ->
            decode_parameter_object_ids_rec(Rest, Count - 1, [Id | Result]);

        {_, _} ->
            dec_err(<<"expected parameter object id"/utf8>>, Binary)
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 807).
?DOC(false).
-spec decode_parameter_object_ids(bitstring()) -> {ok, list(integer())} |
    {error, message_decoding_error()}.
decode_parameter_object_ids(Binary) ->
    case Binary of
        <<Count:16, Rest/binary>> ->
            decode_parameter_object_ids_rec(Rest, Count, []);

        _ ->
            dec_err(<<"expected object id count"/utf8>>, Binary)
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 971).
?DOC(false).
-spec read_parameter(format(), bitstring()) -> parameter_value().
read_parameter(Format, Value) ->
    case Format of
        text ->
            {parameter, Value};

        binary ->
            {parameter, Value}
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 939).
?DOC(false).
-spec read_parameters_rec(
    list(format()),
    integer(),
    bitstring(),
    list(parameter_value())
) -> {ok, {list(parameter_value()), bitstring()}} |
    {error, message_decoding_error()}.
read_parameters_rec(Formats, Count, Binary, Result) ->
    Actual = erlang:length(Formats),
    gleam@bool:guard(
        Actual /= Count,
        dec_err(
            <<<<<<"expected "/utf8, (erlang:integer_to_binary(Count))/binary>>/binary,
                    " parameters, but got "/utf8>>/binary,
                (erlang:integer_to_binary(Actual))/binary>>,
            Binary
        ),
        fun() -> case {Count, Formats, Binary} of
                {0, _, Rest} ->
                    {ok, {lists:reverse(Result), Rest}};

                {_, [_ | Rest_formats], <<-1:32/signed, Rest@1/binary>>} ->
                    read_parameters_rec(
                        Rest_formats,
                        Count - 1,
                        Rest@1,
                        [null | Result]
                    );

                {_,
                    [Format | Rest_formats@1],
                    <<Len:32, Value:Len/binary, Rest@2/binary>>} ->
                    read_parameters_rec(
                        Rest_formats@1,
                        Count - 1,
                        Rest@2,
                        [read_parameter(Format, Value) | Result]
                    );

                {_, _, Rest@3} ->
                    dec_err(<<"invalid parameter value"/utf8>>, Rest@3)
            end end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 925).
?DOC(false).
-spec read_parameters(bitstring(), format_value()) -> {ok,
        {list(parameter_value()), bitstring()}} |
    {error, message_decoding_error()}.
read_parameters(Binary, Parameter_format) ->
    case Binary of
        <<Count:16, Rest/binary>> ->
            _pipe = case Parameter_format of
                format_all_text ->
                    gleam@list:repeat(text, Count);

                {format_all, Format} ->
                    gleam@list:repeat(Format, Count);

                {formats, Formats} ->
                    Formats
            end,
            read_parameters_rec(_pipe, Count, Rest, []);

        _ ->
            dec_err(<<"parameters without count"/utf8>>, Binary)
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 978).
?DOC(false).
-spec read_wire_formats(integer(), bitstring(), list(format())) -> {ok,
        {format_value(), bitstring()}} |
    {error, message_decoding_error()}.
read_wire_formats(Count, Binary, Result) ->
    case {Count, Binary} of
        {0, _} ->
            {ok, {{formats, lists:reverse(Result)}, Binary}};

        {_, <<0:16, Rest/binary>>} ->
            read_wire_formats(Count - 1, Rest, [text | Result]);

        {_, <<1:16, Rest@1/binary>>} ->
            read_wire_formats(Count - 1, Rest@1, [binary | Result]);

        {_, _} ->
            dec_err(<<"unknown format"/utf8>>, Binary)
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 913).
?DOC(false).
-spec read_parameter_format(bitstring()) -> {ok, {format_value(), bitstring()}} |
    {error, message_decoding_error()}.
read_parameter_format(Binary) ->
    case Binary of
        <<0:16, Rest/binary>> ->
            {ok, {format_all_text, Rest}};

        <<1:16, 0:16, Rest@1/binary>> ->
            {ok, {{format_all, text}, Rest@1}};

        <<1:16, 1:16, Rest@2/binary>> ->
            {ok, {{format_all, binary}, Rest@2}};

        <<N:16, Rest@3/binary>> ->
            read_wire_formats(N, Rest@3, []);

        _ ->
            dec_err(<<"invalid parameter format"/utf8>>, Binary)
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 993).
?DOC(false).
-spec decode_command_complete(bitstring()) -> {ok, backend_message()} |
    {error, message_decoding_error()}.
decode_command_complete(Binary) ->
    _pipe@2 = begin
        gleam@result:'try'(case Binary of
                <<"INSERT 0 "/utf8, Rows/binary>> ->
                    {ok, {insert, Rows}};

                <<"DELETE "/utf8, Rows@1/binary>> ->
                    {ok, {delete, Rows@1}};

                <<"UPDATE "/utf8, Rows@2/binary>> ->
                    {ok, {update, Rows@2}};

                <<"MERGE "/utf8, Rows@3/binary>> ->
                    {ok, {merge, Rows@3}};

                <<"SELECT "/utf8, Rows@4/binary>> ->
                    {ok, {select, Rows@4}};

                <<"MOVE "/utf8, Rows@5/binary>> ->
                    {ok, {move, Rows@5}};

                <<"FETCH "/utf8, Rows@6/binary>> ->
                    {ok, {fetch, Rows@6}};

                <<"COPY "/utf8, Rows@7/binary>> ->
                    {ok, {copy, Rows@7}};

                _ ->
                    dec_err(<<"invalid command"/utf8>>, Binary)
            end, fun(Fine) ->
                {Command, Rows_raw} = Fine,
                Len = erlang:byte_size(Rows_raw) - 1,
                gleam@result:'try'(case Rows_raw of
                        <<Rows_bits:Len/binary, 0>> ->
                            {ok, Rows_bits};

                        _ ->
                            dec_err(
                                <<"invalid command row count"/utf8>>,
                                Binary
                            )
                    end, fun(Rows_bits@1) ->
                        gleam@result:'try'(
                            begin
                                _pipe = gleam@bit_array:to_string(Rows_bits@1),
                                gleam@result:replace_error(
                                    _pipe,
                                    msg_dec_err(
                                        <<"failed to convert row count to string"/utf8>>,
                                        Rows_bits@1
                                    )
                                )
                            end,
                            fun(Rows_string) ->
                                gleam@result:'try'(
                                    begin
                                        _pipe@1 = gleam_stdlib:parse_int(
                                            Rows_string
                                        ),
                                        gleam@result:replace_error(
                                            _pipe@1,
                                            msg_dec_err(
                                                <<"failed to convert row count to int"/utf8>>,
                                                Rows_bits@1
                                            )
                                        )
                                    end,
                                    fun(Rows@8) ->
                                        {ok,
                                            {be_command_complete,
                                                Command,
                                                Rows@8}}
                                    end
                                )
                            end
                        )
                    end)
            end)
    end,
    gleam@result:'or'(_pipe@2, {ok, {be_command_complete, insert, -1}}).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1044).
?DOC(false).
-spec decode_parameter_description(integer(), bitstring(), list(integer())) -> {ok,
        backend_message()} |
    {error, message_decoding_error()}.
decode_parameter_description(Count, Binary, Results) ->
    case {Count, Binary} of
        {0, <<>>} ->
            {ok, {be_parameter_description, lists:reverse(Results)}};

        {_, <<Value:32, Tail/binary>>} ->
            decode_parameter_description(Count - 1, Tail, [Value | Results]);

        {_, _} ->
            dec_err(<<"invalid parameter description"/utf8>>, Binary)
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1122).
?DOC(false).
-spec decode_format(integer()) -> {ok, format()} |
    {error, message_decoding_error()}.
decode_format(Num) ->
    case Num of
        0 ->
            {ok, text};

        1 ->
            {ok, binary};

        _ ->
            dec_err(
                <<"invalid format code: "/utf8,
                    (erlang:integer_to_binary(Num))/binary>>,
                <<>>
            )
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1107).
?DOC(false).
-spec decode_format_codes(bitstring(), list(format())) -> {ok, list(format())} |
    {error, message_decoding_error()}.
decode_format_codes(Binary, Result) ->
    case Binary of
        <<Code:16, Tail/binary>> ->
            case decode_format(Code) of
                {ok, Format} ->
                    decode_format_codes(Tail, [Format | Result]);

                {error, Err} ->
                    {error, Err}
            end;

        <<>> ->
            {ok, lists:reverse(Result)};

        _ ->
            dec_err(<<"invalid format codes"/utf8>>, Binary)
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1088).
?DOC(false).
-spec decode_copy_response(copy_direction(), integer(), integer(), bitstring()) -> {ok,
        backend_message()} |
    {error, message_decoding_error()}.
decode_copy_response(Direction, Format_raw, Count, Rest) ->
    gleam@result:'try'(
        decode_format(Format_raw),
        fun(Overall_format) ->
            gleam@bool:guard(
                erlang:byte_size(Rest) /= (Count * 2),
                dec_err(<<"size must be count * 2"/utf8>>, Rest),
                fun() ->
                    gleam@result:'try'(
                        decode_format_codes(Rest, []),
                        fun(Codes) -> case Overall_format =:= text of
                                false ->
                                    {ok,
                                        {be_copy_response,
                                            Direction,
                                            Overall_format,
                                            Codes}};

                                true ->
                                    case gleam@list:all(
                                        Codes,
                                        fun(Code) -> Code =:= text end
                                    ) of
                                        true ->
                                            {ok,
                                                {be_copy_response,
                                                    Direction,
                                                    Overall_format,
                                                    Codes}};

                                        false ->
                                            dec_err(
                                                <<"invalid copy response format"/utf8>>,
                                                Rest
                                            )
                                    end
                            end end
                    )
                end
            )
        end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1130).
?DOC(false).
-spec read_format(bitstring()) -> {ok, {format(), bitstring()}} |
    {error, message_decoding_error()}.
read_format(Binary) ->
    case Binary of
        <<0:16, Rest/binary>> ->
            {ok, {text, Rest}};

        <<1:16, Rest@1/binary>> ->
            {ok, {binary, Rest@1}};

        _ ->
            dec_err(<<"invalid format code"/utf8>>, Binary)
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 823).
?DOC(false).
-spec decode_function_call(bitstring()) -> {ok, frontend_message()} |
    {error, message_decoding_error()}.
decode_function_call(Binary) ->
    case Binary of
        <<Object_id:32, Rest/binary>> ->
            gleam@result:'try'(
                read_parameter_format(Rest),
                fun(_use0) ->
                    {Argument_format, Rest@1} = _use0,
                    gleam@result:'try'(
                        read_parameters(Rest@1, Argument_format),
                        fun(_use0@1) ->
                            {Arguments, Rest@2} = _use0@1,
                            gleam@result:'try'(
                                read_format(Rest@2),
                                fun(_use0@2) ->
                                    {Result_format, Rest@3} = _use0@2,
                                    case Rest@3 of
                                        <<>> ->
                                            {ok,
                                                {fe_function_call,
                                                    Object_id,
                                                    Argument_format,
                                                    Arguments,
                                                    Result_format}};

                                        _ ->
                                            dec_err(
                                                <<"invalid function call, data remains"/utf8>>,
                                                Rest@3
                                            )
                                    end
                                end
                            )
                        end
                    )
                end
            );

        _ ->
            dec_err(
                <<"invalid function call, no object id found"/utf8>>,
                Binary
            )
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1138).
?DOC(false).
-spec encode_format(format()) -> integer().
encode_format(Format_raw) ->
    case Format_raw of
        text ->
            0;

        binary ->
            1
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 203).
?DOC(false).
-spec encode_format_value(format_value()) -> bitstring().
encode_format_value(Format) ->
    case Format of
        format_all_text ->
            <<(encode_format(text)):16>>;

        {format_all, text} ->
            <<1:16, (encode_format(text)):16>>;

        {format_all, binary} ->
            <<1:16, (encode_format(binary)):16>>;

        {formats, Formats} ->
            Size = erlang:length(Formats),
            gleam@list:fold(
                Formats,
                <<Size:16>>,
                fun(Sum, Fmt) -> <<Sum/bitstring, (encode_format(Fmt)):16>> end
            )
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 379).
?DOC(false).
-spec encode_copy_response_rec(format(), list(format())) -> bitstring().
encode_copy_response_rec(Overall_format, Codes) ->
    case Overall_format of
        text ->
            _pipe = Codes,
            gleam@list:fold(
                _pipe,
                <<(encode_format(Overall_format)):8, (erlang:length(Codes)):16>>,
                fun(Sum, _) -> <<Sum/bitstring, (encode_format(text)):16>> end
            );

        binary ->
            _pipe@1 = Codes,
            gleam@list:fold(
                _pipe@1,
                <<(encode_format(Overall_format)):8, (erlang:length(Codes)):16>>,
                fun(Sum@1, Code) ->
                    <<Sum@1/bitstring, (encode_format(Code)):16>>
                end
            )
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 363).
?DOC(false).
-spec encode_copy_response(copy_direction(), format(), list(format())) -> bitstring().
encode_copy_response(Direction, Overall_format, Codes) ->
    Data = encode_copy_response_rec(Overall_format, Codes),
    case Direction of
        in ->
            encode(<<"G"/utf8>>, Data);

        out ->
            encode(<<"H"/utf8>>, Data);

        both ->
            encode(<<"W"/utf8>>, Data)
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 451).
?DOC(false).
-spec encode_backend_message(backend_message()) -> bitstring().
encode_backend_message(Message) ->
    case Message of
        {be_message_data_row, Columns} ->
            encode_message_data_row(Columns);

        {be_error_response, Fields} ->
            encode_error_response(Fields);

        be_authentication_ok ->
            encode(<<"R"/utf8>>, <<0:32>>);

        be_authentication_kerberos_v5 ->
            encode(<<"R"/utf8>>, <<2:32>>);

        be_authentication_cleartext_password ->
            encode(<<"R"/utf8>>, <<3:32>>);

        {be_authentication_m_d5_password, Salt} ->
            encode(<<"R"/utf8>>, <<5:32, Salt/bitstring>>);

        be_authentication_g_s_s ->
            encode(<<"R"/utf8>>, <<7:32>>);

        {be_authentication_g_s_s_continue, Data} ->
            encode(<<"R"/utf8>>, <<8:32, Data/bitstring>>);

        be_authentication_s_s_p_i ->
            encode(<<"R"/utf8>>, <<9:32>>);

        {be_authentication_s_a_s_l, A} ->
            encode_authentication_sasl(A);

        {be_authentication_s_a_s_l_continue, Data@1} ->
            encode(<<"R"/utf8>>, <<11:32, Data@1/bitstring>>);

        {be_authentication_s_a_s_l_final, Data@2} ->
            encode(<<"R"/utf8>>, <<12:32, Data@2/bitstring>>);

        {be_backend_key_data, Pid, Sk} ->
            encode(<<"K"/utf8>>, <<Pid:32, Sk:32>>);

        be_bind_complete ->
            encode(<<"2"/utf8>>, <<>>);

        be_close_complete ->
            encode(<<"3"/utf8>>, <<>>);

        {be_command_complete, A@1, B} ->
            encode_command_complete(A@1, B);

        {be_copy_data, Data@3} ->
            encode(<<"d"/utf8>>, Data@3);

        be_copy_done ->
            encode(<<"c"/utf8>>, <<>>);

        {be_copy_response, A@2, B@1, C} ->
            encode_copy_response(A@2, B@1, C);

        {be_parameter_status, Name, Value} ->
            encode_parameter_status(Name, Value);

        {be_negotiate_protocol_version, A@3, B@2} ->
            encode_negotiate_protocol_version(A@3, B@2);

        be_no_data ->
            encode(<<"n"/utf8>>, <<>>);

        {be_notice_response, Data@4} ->
            encode_notice_response(Data@4);

        {be_notification_response, A@4, B@3, C@1} ->
            encode_notification_response(A@4, B@3, C@1);

        {be_parameter_description, A@5} ->
            encode_parameter_description(A@5);

        be_parse_complete ->
            encode(<<"1"/utf8>>, <<>>);

        be_portal_suspended ->
            encode(<<"s"/utf8>>, <<>>);

        {be_row_descriptions, A@6} ->
            encode_row_descriptions(A@6);

        {be_ready_for_query, transaction_status_idle} ->
            encode(<<"Z"/utf8>>, <<"I"/utf8>>);

        {be_ready_for_query, transaction_status_in_transaction} ->
            encode(<<"Z"/utf8>>, <<"T"/utf8>>);

        {be_ready_for_query, transaction_status_failed} ->
            encode(<<"Z"/utf8>>, <<"E"/utf8>>)
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 577).
?DOC(false).
-spec encode_bind(
    binary(),
    binary(),
    format_value(),
    list(parameter_value()),
    format_value()
) -> bitstring().
encode_bind(Portal, Statement_name, Parameter_format, Parameters, Result_format) ->
    encode(
        <<"B"/utf8>>,
        <<Portal/binary,
            0,
            Statement_name/binary,
            0,
            (encode_format_value(Parameter_format))/bitstring,
            (parameters_to_bytes(Parameters))/bitstring,
            (encode_format_value(Result_format))/bitstring>>
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 595).
?DOC(false).
-spec encode_function_call(
    integer(),
    format_value(),
    list(parameter_value()),
    format()
) -> bitstring().
encode_function_call(Object_id, Argument_format, Arguments, Result_format) ->
    encode(
        <<"F"/utf8>>,
        <<Object_id:32,
            (encode_format_value(Argument_format))/bitstring,
            (parameters_to_bytes(Arguments))/bitstring,
            (encode_format(Result_format)):16>>
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1163).
?DOC(false).
-spec decode_message_data_row_rec(bitstring(), integer(), list(bitstring())) -> {ok,
        list(bitstring())} |
    {error, message_decoding_error()}.
decode_message_data_row_rec(Binary, Count, Result) ->
    case {Count, Binary} of
        {0, _} ->
            {ok, lists:reverse(Result)};

        {_, <<Length:32, Value:Length/binary, Rest/binary>>} ->
            decode_message_data_row_rec(Rest, Count - 1, [Value | Result]);

        {_, _} ->
            dec_err(
                <<"failed to parse data row at count "/utf8,
                    (erlang:integer_to_binary(Count))/binary>>,
                Binary
            )
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1149).
?DOC(false).
-spec decode_message_data_row(integer(), bitstring()) -> {ok, backend_message()} |
    {error, message_decoding_error()}.
decode_message_data_row(Count, Rest) ->
    case decode_message_data_row_rec(Rest, Count, []) of
        {ok, Cols} ->
            case erlang:length(Cols) =:= Count of
                true ->
                    {ok, {be_message_data_row, Cols}};

                false ->
                    dec_err(<<"column count doesn't match"/utf8>>, Rest)
            end;

        {error, Err} ->
            {error, Err}
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 900).
?DOC(false).
-spec decode_string(bitstring()) -> {ok, {binary(), bitstring()}} |
    {error, message_decoding_error()}.
decode_string(Binary) ->
    case binary:split(Binary, <<0>>, []) of
        [Head, Tail] ->
            case gleam@bit_array:to_string(Head) of
                {ok, Str} ->
                    {ok, {Str, Tail}};

                {error, nil} ->
                    dec_err(<<"invalid string encoding"/utf8>>, Head)
            end;

        _ ->
            dec_err(<<"invalid string"/utf8>>, Binary)
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 779).
?DOC(false).
-spec decode_startup_message_pairs(bitstring(), list({binary(), binary()})) -> {ok,
        frontend_message()} |
    {error, message_decoding_error()}.
decode_startup_message_pairs(Binary, Result) ->
    case Binary of
        <<0>> ->
            {ok, {fe_startup_message, lists:reverse(Result)}};

        _ ->
            gleam@result:'try'(
                decode_string(Binary),
                fun(_use0) ->
                    {Key, Binary@1} = _use0,
                    gleam@result:'try'(
                        decode_string(Binary@1),
                        fun(_use0@1) ->
                            {Value, Binary@2} = _use0@1,
                            decode_startup_message_pairs(
                                Binary@2,
                                [{Key, Value} | Result]
                            )
                        end
                    )
                end
            )
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 770).
?DOC(false).
-spec decode_startup_message(bitstring(), integer()) -> {ok,
        {frontend_message(), bitstring()}} |
    {error, message_decoding_error()}.
decode_startup_message(Binary, Size) ->
    case Binary of
        <<Data:Size/binary, Next/binary>> ->
            _pipe = decode_startup_message_pairs(Data, []),
            gleam@result:map(_pipe, fun(R) -> {R, Next} end);

        _ ->
            dec_err(<<"invalid startup message"/utf8>>, Binary)
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 790).
?DOC(false).
-spec decode_query(bitstring()) -> {ok, frontend_message()} |
    {error, message_decoding_error()}.
decode_query(Binary) ->
    gleam@result:'try'(
        decode_string(Binary),
        fun(_use0) ->
            {Query, Rest} = _use0,
            case Rest of
                <<>> ->
                    {ok, {fe_query, Query}};

                _ ->
                    dec_err(<<"Query message too long"/utf8>>, Binary)
            end
        end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 800).
?DOC(false).
-spec decode_parse(bitstring()) -> {ok, frontend_message()} |
    {error, message_decoding_error()}.
decode_parse(Binary) ->
    gleam@result:'try'(
        decode_string(Binary),
        fun(_use0) ->
            {Name, Binary@1} = _use0,
            gleam@result:'try'(
                decode_string(Binary@1),
                fun(_use0@1) ->
                    {Query, Binary@2} = _use0@1,
                    gleam@result:'try'(
                        decode_parameter_object_ids(Binary@2),
                        fun(Parameter_object_ids) ->
                            {ok, {fe_parse, Name, Query, Parameter_object_ids}}
                        end
                    )
                end
            )
        end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 844).
?DOC(false).
-spec decode_execute(bitstring()) -> {ok, frontend_message()} |
    {error, message_decoding_error()}.
decode_execute(Binary) ->
    gleam@result:'try'(
        decode_string(Binary),
        fun(_use0) ->
            {Portal, Binary@1} = _use0,
            case Binary@1 of
                <<Count:32>> ->
                    {ok, {fe_execute, Portal, Count}};

                _ ->
                    dec_err(
                        <<"no execute return_row_count found"/utf8>>,
                        Binary@1
                    )
            end
        end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 852).
?DOC(false).
-spec decode_describe(bitstring()) -> {ok, frontend_message()} |
    {error, message_decoding_error()}.
decode_describe(Binary) ->
    gleam@result:'try'(
        decode_what(Binary),
        fun(_use0) ->
            {What, Binary@1} = _use0,
            gleam@result:'try'(
                decode_string(Binary@1),
                fun(_use0@1) ->
                    {Name, Binary@2} = _use0@1,
                    case Binary@2 of
                        <<>> ->
                            {ok, {fe_describe, What, Name}};

                        _ ->
                            dec_err(
                                <<"Describe message too long"/utf8>>,
                                Binary@2
                            )
                    end
                end
            )
        end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 861).
?DOC(false).
-spec decode_copy_fail(bitstring()) -> {ok, frontend_message()} |
    {error, message_decoding_error()}.
decode_copy_fail(Binary) ->
    gleam@result:'try'(
        decode_string(Binary),
        fun(_use0) ->
            {Error, Binary@1} = _use0,
            case Binary@1 of
                <<>> ->
                    {ok, {fe_copy_fail, Error}};

                _ ->
                    dec_err(<<"CopyFail message too long"/utf8>>, Binary@1)
            end
        end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 869).
?DOC(false).
-spec decode_close(bitstring()) -> {ok, frontend_message()} |
    {error, message_decoding_error()}.
decode_close(Binary) ->
    gleam@result:'try'(
        decode_what(Binary),
        fun(_use0) ->
            {What, Binary@1} = _use0,
            gleam@result:'try'(
                decode_string(Binary@1),
                fun(_use0@1) ->
                    {Name, Binary@2} = _use0@1,
                    case Binary@2 of
                        <<>> ->
                            {ok, {fe_close, What, Name}};

                        _ ->
                            dec_err(<<"Close message too long"/utf8>>, Binary@2)
                    end
                end
            )
        end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 881).
?DOC(false).
-spec decode_bind(bitstring()) -> {ok, frontend_message()} |
    {error, message_decoding_error()}.
decode_bind(Binary) ->
    gleam@result:'try'(
        decode_string(Binary),
        fun(_use0) ->
            {Portal, Binary@1} = _use0,
            gleam@result:'try'(
                decode_string(Binary@1),
                fun(_use0@1) ->
                    {Statement_name, Binary@2} = _use0@1,
                    gleam@result:'try'(
                        read_parameter_format(Binary@2),
                        fun(_use0@2) ->
                            {Parameter_format, Binary@3} = _use0@2,
                            gleam@result:'try'(
                                read_parameters(Binary@3, Parameter_format),
                                fun(_use0@3) ->
                                    {Parameters, Binary@4} = _use0@3,
                                    gleam@result:'try'(
                                        read_parameter_format(Binary@4),
                                        fun(_use0@4) ->
                                            {Result_format, Binary@5} = _use0@4,
                                            case Binary@5 of
                                                <<>> ->
                                                    {ok,
                                                        {fe_bind,
                                                            Portal,
                                                            Statement_name,
                                                            Parameter_format,
                                                            Parameters,
                                                            Result_format}};

                                                _ ->
                                                    dec_err(
                                                        <<"Bind message too long"/utf8>>,
                                                        Binary@5
                                                    )
                                            end
                                        end
                                    )
                                end
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 748).
?DOC(false).
-spec decode_frontend_message(bitstring()) -> {ok, frontend_message()} |
    {error, message_decoding_error()}.
decode_frontend_message(Binary) ->
    case Binary of
        <<"B"/utf8, Data/binary>> ->
            decode_bind(Data);

        <<"C"/utf8, Data@1/binary>> ->
            decode_close(Data@1);

        <<"d"/utf8, Data@2/binary>> ->
            {ok, {fe_copy_data, Data@2}};

        <<"c"/utf8>> ->
            {ok, fe_copy_done};

        <<"f"/utf8, Data@3/binary>> ->
            decode_copy_fail(Data@3);

        <<"D"/utf8, Data@4/binary>> ->
            decode_describe(Data@4);

        <<"E"/utf8, Data@5/binary>> ->
            decode_execute(Data@5);

        <<"H"/utf8>> ->
            {ok, fe_flush};

        <<"F"/utf8, Data@6/binary>> ->
            decode_function_call(Data@6);

        <<"p"/utf8, Data@7/binary>> ->
            {ok, {fe_ambigous, {fe_gss_response, Data@7}}};

        <<"P"/utf8, Data@8/binary>> ->
            decode_parse(Data@8);

        <<"Q"/utf8, Data@9/binary>> ->
            decode_query(Data@9);

        <<"S"/utf8>> ->
            {ok, fe_sync};

        <<"X"/utf8>> ->
            {ok, fe_terminate};

        _ ->
            {error, {unknown_message, Binary}}
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 721).
?DOC(false).
-spec decode_frontend_packet(bitstring()) -> {ok,
        {frontend_message(), bitstring()}} |
    {error, message_decoding_error()}.
decode_frontend_packet(Packet) ->
    case Packet of
        <<16:32, 1234:16, 5678:16, Process_id:32, Secret_key:32, Next/binary>> ->
            {ok, {{fe_cancel_request, Process_id, Secret_key}, Next}};

        <<8:32, 1234:16, 5679:16, Next@1/binary>> ->
            {ok, {fe_ssl_request, Next@1}};

        <<8:32, 1234:16, 5680:16, Next@2/binary>> ->
            {ok, {fe_gss_enc_request, Next@2}};

        <<Length:32, 3:16, 0:16, Next@3/binary>> ->
            decode_startup_message(Next@3, Length - 8);

        <<Message_type:1/binary, Length@1:32, Tail/binary>> ->
            Len = Length@1 - 4,
            case Tail of
                <<Data:Len/binary, Next@4/binary>> ->
                    _pipe = decode_frontend_message(
                        <<Message_type/bitstring, Data/bitstring>>
                    ),
                    gleam@result:map(_pipe, fun(Msg) -> {Msg, Next@4} end);

                _ ->
                    {error, {message_incomplete, Tail}}
            end;

        <<_:48>> ->
            {error, {message_incomplete, Packet}};

        _ ->
            dec_err(<<"invalid message"/utf8>>, Packet)
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1249).
?DOC(false).
-spec decode_strings(bitstring()) -> {ok, list(binary())} |
    {error, message_decoding_error()}.
decode_strings(Binary) ->
    Length = erlang:byte_size(Binary) - 1,
    case Binary of
        <<>> ->
            {ok, []};

        <<Head:Length/binary, 0>> ->
            _pipe = binary:split(Head, <<0>>, [global]),
            _pipe@1 = gleam@list:map(_pipe, fun gleam@bit_array:to_string/1),
            _pipe@2 = gleam@result:all(_pipe@1),
            gleam@result:replace_error(
                _pipe@2,
                msg_dec_err(<<"invalid strings encoding"/utf8>>, Binary)
            );

        _ ->
            dec_err(<<"string size didn't match"/utf8>>, Binary)
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1075).
?DOC(false).
-spec decode_parameter_status(bitstring()) -> {ok, backend_message()} |
    {error, message_decoding_error()}.
decode_parameter_status(Binary) ->
    gleam@result:'try'(decode_strings(Binary), fun(Strings) -> case Strings of
                [Name, Value] ->
                    {ok, {be_parameter_status, Name, Value}};

                _ ->
                    dec_err(<<"invalid parameter status"/utf8>>, Binary)
            end end).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1083).
?DOC(false).
-spec decode_authentication_sasl(bitstring()) -> {ok, backend_message()} |
    {error, message_decoding_error()}.
decode_authentication_sasl(Binary) ->
    gleam@result:'try'(
        decode_strings(Binary),
        fun(Strings) -> {ok, {be_authentication_s_a_s_l, Strings}} end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1275).
?DOC(false).
-spec read_string(bitstring()) -> {ok, {binary(), bitstring()}} |
    {error, message_decoding_error()}.
read_string(Binary) ->
    case binary:split(Binary, <<0>>, []) of
        [<<>>, <<>>] ->
            {ok, {<<""/utf8>>, <<>>}};

        [Head, Tail] ->
            _pipe = gleam@bit_array:to_string(Head),
            _pipe@1 = gleam@result:replace_error(
                _pipe,
                msg_dec_err(<<"invalid string encoding"/utf8>>, Head)
            ),
            gleam@result:map(_pipe@1, fun(S) -> {S, Tail} end);

        _ ->
            dec_err(<<"invalid string"/utf8>>, Binary)
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1218).
?DOC(false).
-spec read_row_description_field(bitstring()) -> {ok,
        {row_description_field(), bitstring()}} |
    {error, message_decoding_error()}.
read_row_description_field(Binary) ->
    case read_string(Binary) of
        {ok,
            {Name,
                <<Table_oid:32,
                    Attr_number:16,
                    Data_type_oid:32,
                    Data_type_size:16,
                    Type_modifier:32,
                    Format_code:16,
                    Tail/binary>>}} ->
            {ok,
                {{row_description_field,
                        Name,
                        Table_oid,
                        Attr_number,
                        Data_type_oid,
                        Data_type_size,
                        Type_modifier,
                        Format_code},
                    Tail}};

        {ok, {_, Tail@1}} ->
            dec_err(<<"failed to parse row description field"/utf8>>, Tail@1);

        {error, _} ->
            dec_err(
                <<"failed to decode row description field name"/utf8>>,
                Binary
            )
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1205).
?DOC(false).
-spec read_row_descriptions(
    integer(),
    bitstring(),
    list(row_description_field())
) -> {ok, list(row_description_field())} | {error, message_decoding_error()}.
read_row_descriptions(Count, Binary, Result) ->
    case {Count, Binary} of
        {0, <<>>} ->
            {ok, lists:reverse(Result)};

        {_, <<>>} ->
            dec_err(<<"row description count mismatch"/utf8>>, Binary);

        {_, _} ->
            case read_row_description_field(Binary) of
                {ok, {Field, Tail}} ->
                    read_row_descriptions(Count - 1, Tail, [Field | Result]);

                {error, Err} ->
                    {error, Err}
            end
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1070).
?DOC(false).
-spec decode_row_descriptions(integer(), bitstring()) -> {ok, backend_message()} |
    {error, message_decoding_error()}.
decode_row_descriptions(Count, Binary) ->
    gleam@result:'try'(
        read_row_descriptions(Count, Binary, []),
        fun(Fields) -> {ok, {be_row_descriptions, Fields}} end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1263).
?DOC(false).
-spec read_strings(bitstring(), integer(), list(binary())) -> {ok,
        list(binary())} |
    {error, message_decoding_error()}.
read_strings(Binary, Count, Result) ->
    case Count of
        0 ->
            {ok, lists:reverse(Result)};

        _ ->
            case read_string(Binary) of
                {ok, {Value, Rest}} ->
                    read_strings(Rest, Count - 1, [Value | Result]);

                {error, Err} ->
                    {error, Err}
            end
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1053).
?DOC(false).
-spec decode_notification_response(integer(), bitstring()) -> {ok,
        backend_message()} |
    {error, message_decoding_error()}.
decode_notification_response(Process_id, Binary) ->
    gleam@result:'try'(
        read_strings(Binary, 2, []),
        fun(Strings) -> case Strings of
                [Channel, Payload] ->
                    {ok,
                        {be_notification_response, Process_id, Channel, Payload}};

                _ ->
                    dec_err(
                        <<"invalid notification response encoding"/utf8>>,
                        Binary
                    )
            end end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1065).
?DOC(false).
-spec decode_negotiate_protocol_version(integer(), integer(), bitstring()) -> {ok,
        backend_message()} |
    {error, message_decoding_error()}.
decode_negotiate_protocol_version(Version, Count, Binary) ->
    gleam@result:'try'(
        read_strings(Binary, Count, []),
        fun(Options) ->
            {ok, {be_negotiate_protocol_version, Version, Options}}
        end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1353).
?DOC(false).
-spec decode_fields_rec(bitstring(), list({bitstring(), binary()})) -> {ok,
        list({bitstring(), binary()})} |
    {error, message_decoding_error()}.
decode_fields_rec(Binary, Result) ->
    case Binary of
        <<0>> ->
            {ok, Result};

        <<>> ->
            {ok, Result};

        <<Field_type:1/binary, Rest/binary>> ->
            case binary:split(Rest, <<0>>, []) of
                [Head, Tail] ->
                    case gleam@bit_array:to_string(Head) of
                        {ok, Value} ->
                            decode_fields_rec(
                                Tail,
                                [{Field_type, Value} | Result]
                            );

                        {error, nil} ->
                            case squirrel_ffi:recover_string(Head) of
                                {ok, Value@1} ->
                                    decode_fields_rec(
                                        Tail,
                                        [{Field_type, Value@1} | Result]
                                    );

                                {error, nil} ->
                                    dec_err(
                                        <<"invalid field encoding"/utf8>>,
                                        Binary
                                    )
                            end
                    end;

                _ ->
                    dec_err(<<"invalid field separator"/utf8>>, Binary)
            end;

        _ ->
            dec_err(<<"invalid field"/utf8>>, Binary)
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1319).
?DOC(false).
-spec decode_fields(bitstring()) -> {ok, gleam@set:set(error_or_notice_field())} |
    {error, message_decoding_error()}.
decode_fields(Binary) ->
    case decode_fields_rec(Binary, []) of
        {ok, Fields} ->
            _pipe = Fields,
            _pipe@1 = gleam@list:map(
                _pipe,
                fun(Key_value_raw) ->
                    {Key, Value} = Key_value_raw,
                    case Key of
                        <<"S"/utf8>> ->
                            {severity, Value};

                        <<"V"/utf8>> ->
                            {severity_localized, Value};

                        <<"C"/utf8>> ->
                            {code, Value};

                        <<"M"/utf8>> ->
                            {message, Value};

                        <<"D"/utf8>> ->
                            {detail, Value};

                        <<"H"/utf8>> ->
                            {hint, Value};

                        <<"P"/utf8>> ->
                            {position, Value};

                        <<"p"/utf8>> ->
                            {internal_position, Value};

                        <<"q"/utf8>> ->
                            {internal_query, Value};

                        <<"W"/utf8>> ->
                            {where, Value};

                        <<"s"/utf8>> ->
                            {schema, Value};

                        <<"t"/utf8>> ->
                            {table, Value};

                        <<"c"/utf8>> ->
                            {column, Value};

                        <<"d"/utf8>> ->
                            {data_type, Value};

                        <<"n"/utf8>> ->
                            {constraint, Value};

                        <<"F"/utf8>> ->
                            {file, Value};

                        <<"L"/utf8>> ->
                            {line, Value};

                        <<"R"/utf8>> ->
                            {routine, Value};

                        _ ->
                            {unknown, Key, Value}
                    end
                end
            ),
            _pipe@2 = gleam@set:from_list(_pipe@1),
            {ok, _pipe@2};

        {error, Err} ->
            {error, Err}
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1287).
?DOC(false).
-spec decode_notice_response(bitstring()) -> {ok, backend_message()} |
    {error, message_decoding_error()}.
decode_notice_response(Binary) ->
    gleam@result:'try'(
        decode_fields(Binary),
        fun(Fields) -> {ok, {be_notice_response, Fields}} end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 1292).
?DOC(false).
-spec decode_error_response(bitstring()) -> {ok, backend_message()} |
    {error, message_decoding_error()}.
decode_error_response(Binary) ->
    gleam@result:'try'(
        decode_fields(Binary),
        fun(Fields) -> {ok, {be_error_response, Fields}} end
    ).

-file("src/squirrel/internal/database/postgres_protocol.gleam", 669).
?DOC(false).
-spec decode_backend_message(bitstring()) -> {ok, backend_message()} |
    {error, message_decoding_error()}.
decode_backend_message(Binary) ->
    case Binary of
        <<"D"/utf8, Count:16, Data/binary>> ->
            decode_message_data_row(Count, Data);

        <<"E"/utf8, Data@1/binary>> ->
            decode_error_response(Data@1);

        <<"R"/utf8, 0:32>> ->
            {ok, be_authentication_ok};

        <<"R"/utf8, 2:32>> ->
            {ok, be_authentication_kerberos_v5};

        <<"R"/utf8, 3:32>> ->
            {ok, be_authentication_cleartext_password};

        <<"R"/utf8, 5:32, Salt/binary>> ->
            {ok, {be_authentication_m_d5_password, Salt}};

        <<"R"/utf8, 7:32>> ->
            {ok, be_authentication_g_s_s};

        <<"R"/utf8, 8:32, Auth_data/binary>> ->
            {ok, {be_authentication_g_s_s_continue, Auth_data}};

        <<"R"/utf8, 9:32>> ->
            {ok, be_authentication_s_s_p_i};

        <<"R"/utf8, 10:32, Data@2/binary>> ->
            decode_authentication_sasl(Data@2);

        <<"R"/utf8, 11:32, Data@3/binary>> ->
            {ok, {be_authentication_s_a_s_l_continue, Data@3}};

        <<"R"/utf8, 12:32, Data@4/binary>> ->
            {ok, {be_authentication_s_a_s_l_final, Data@4}};

        <<"K"/utf8, Pid:32, Sk:32>> ->
            {ok, {be_backend_key_data, Pid, Sk}};

        <<"2"/utf8>> ->
            {ok, be_bind_complete};

        <<"3"/utf8>> ->
            {ok, be_close_complete};

        <<"C"/utf8, Data@5/binary>> ->
            decode_command_complete(Data@5);

        <<"d"/utf8, Data@6/binary>> ->
            {ok, {be_copy_data, Data@6}};

        <<"c"/utf8>> ->
            {ok, be_copy_done};

        <<"G"/utf8, Format:8, Count@1:16, Data@7/binary>> ->
            decode_copy_response(in, Format, Count@1, Data@7);

        <<"H"/utf8, Format@1:8, Count@2:16, Data@8/binary>> ->
            decode_copy_response(out, Format@1, Count@2, Data@8);

        <<"W"/utf8, Format@2:8, Count@3:16, Data@9/binary>> ->
            decode_copy_response(both, Format@2, Count@3, Data@9);

        <<"S"/utf8, Data@10/binary>> ->
            decode_parameter_status(Data@10);

        <<"v"/utf8, Version:32, Count@4:32, Data@11/binary>> ->
            decode_negotiate_protocol_version(Version, Count@4, Data@11);

        <<"n"/utf8>> ->
            {ok, be_no_data};

        <<"N"/utf8, Data@12/binary>> ->
            decode_notice_response(Data@12);

        <<"A"/utf8, Process_id:32, Data@13/binary>> ->
            decode_notification_response(Process_id, Data@13);

        <<"t"/utf8, Count@5:16, Data@14/binary>> ->
            decode_parameter_description(Count@5, Data@14, []);

        <<"1"/utf8>> ->
            {ok, be_parse_complete};

        <<"s"/utf8>> ->
            {ok, be_portal_suspended};

        <<"T"/utf8, Count@6:16, Data@15/binary>> ->
            decode_row_descriptions(Count@6, Data@15);

        <<"Z"/utf8, "I"/utf8>> ->
            {ok, {be_ready_for_query, transaction_status_idle}};

        <<"Z"/utf8, "T"/utf8>> ->
            {ok, {be_ready_for_query, transaction_status_in_transaction}};

        <<"Z"/utf8, "E"/utf8>> ->
            {ok, {be_ready_for_query, transaction_status_failed}};

        _ ->
            {error, {unknown_message, Binary}}
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 647).
?DOC(false).
-spec decode_backend_packet(bitstring()) -> {ok,
        {backend_message(), bitstring()}} |
    {error, message_decoding_error()}.
decode_backend_packet(Packet) ->
    case Packet of
        <<Message_type:1/binary, Length:32, Tail/binary>> ->
            Len = Length - 4,
            case Tail of
                <<Data:Len/binary, Next/binary>> ->
                    _pipe = decode_backend_message(
                        <<Message_type/bitstring, Data/bitstring>>
                    ),
                    gleam@result:map(_pipe, fun(Msg) -> {Msg, Next} end);

                _ ->
                    {error, {message_incomplete, Tail}}
            end;

        _ ->
            case erlang:byte_size(Packet) < 5 of
                true ->
                    {error, {message_incomplete, Packet}};

                false ->
                    dec_err(<<"packet size too small"/utf8>>, Packet)
            end
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 626).
?DOC(false).
-spec 'receive'(connection()) -> {ok, {connection(), backend_message()}} |
    {error, read_error()}.
'receive'(Conn) ->
    case decode_backend_packet(erlang:element(3, Conn)) of
        {ok, {Message, Rest}} ->
            {ok, {with_buffer(Conn, Rest), Message}};

        {error, {message_incomplete, _}} ->
            case mug:'receive'(erlang:element(2, Conn), erlang:element(4, Conn)) of
                {ok, Packet} ->
                    'receive'(
                        with_buffer(
                            Conn,
                            <<(erlang:element(3, Conn))/bitstring,
                                Packet/bitstring>>
                        )
                    );

                {error, Err} ->
                    {error, {socket_error, Err}}
            end;

        {error, Err@1} ->
            {error, {read_decode_error, Err@1}}
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 95).
?DOC(false).
-spec receive_startup_1(connection(), state()) -> {ok, {connection(), state()}} |
    {error, startup_failed()}.
receive_startup_1(Conn, State) ->
    case 'receive'(Conn) of
        {ok, {Conn@1, {be_parameter_status, Name, Value}}} ->
            receive_startup_1(
                Conn@1,
                {state,
                    erlang:element(2, State),
                    erlang:element(3, State),
                    gleam@dict:insert(erlang:element(4, State), Name, Value),
                    erlang:element(5, State)}
            );

        {ok, {Conn@2, {be_ready_for_query, _}}} ->
            {ok, {Conn@2, State}};

        {ok, {_, Msg}} ->
            {error, {startup_failed_with_unexpected_message, Msg}};

        {error, Err} ->
            {error, {startup_failed_with_error, Err}}
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 72).
?DOC(false).
-spec receive_startup_rec(connection(), state_initial()) -> {ok,
        {connection(), state()}} |
    {error, startup_failed()}.
receive_startup_rec(Conn, State) ->
    case 'receive'(Conn) of
        {ok, {Conn@1, be_authentication_ok}} ->
            receive_startup_rec(Conn@1, State);

        {ok, {Conn@2, {be_parameter_status, Name, Value}}} ->
            receive_startup_rec(
                Conn@2,
                {state_initial,
                    gleam@dict:insert(erlang:element(2, State), Name, Value)}
            );

        {ok, {Conn@3, {be_backend_key_data, Process_id, Secret_key}}} ->
            receive_startup_1(
                Conn@3,
                {state,
                    Process_id,
                    Secret_key,
                    erlang:element(2, State),
                    default_oids()}
            );

        {ok, {_, Msg}} ->
            {error, {startup_failed_with_unexpected_message, Msg}};

        {error, Err} ->
            {error, {startup_failed_with_error, Err}}
    end.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 547).
?DOC(false).
-spec encode_startup_message(list({binary(), binary()})) -> bitstring().
encode_startup_message(Params) ->
    Packet = begin
        _pipe = Params,
        gleam@list:fold(
            _pipe,
            <<<<(<<3:16>>)/bitstring, (<<0:16>>)/bitstring>>/bitstring>>,
            fun(Builder, Element) ->
                {Key, Value} = Element,
                <<Builder/bitstring,
                    (encode_string(Key))/bitstring,
                    (encode_string(Value))/bitstring>>
            end
        )
    end,
    Size = erlang:byte_size(Packet) + 5,
    <<Size:32, Packet/bitstring, 0>>.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 60).
?DOC(false).
-spec start(connection(), list({binary(), binary()})) -> {connection(), state()}.
start(Conn, Params) ->
    Conn@2 = case begin
        _pipe = Conn,
        send(_pipe, encode_startup_message(Params))
    end of
        {ok, Conn@1} -> Conn@1;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"squirrel/internal/database/postgres_protocol"/utf8>>,
                        function => <<"start"/utf8>>,
                        line => 61,
                        value => _assert_fail,
                        start => 1560,
                        'end' => 1634,
                        pattern_start => 1571,
                        pattern_end => 1579})
    end,
    {Conn@4, State@1} = case begin
        _pipe@1 = Conn@2,
        receive_startup_rec(_pipe@1, {state_initial, maps:new()})
    end of
        {ok, {Conn@3, State}} -> {Conn@3, State};
        _assert_fail@1 ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        file => <<?FILEPATH/utf8>>,
                        module => <<"squirrel/internal/database/postgres_protocol"/utf8>>,
                        function => <<"start"/utf8>>,
                        line => 65,
                        value => _assert_fail@1,
                        start => 1638,
                        'end' => 1731,
                        pattern_start => 1649,
                        pattern_end => 1667})
    end,
    {Conn@4, State@1}.

-file("src/squirrel/internal/database/postgres_protocol.gleam", 487).
?DOC(false).
-spec encode_frontend_message(frontend_message()) -> bitstring().
encode_frontend_message(Message) ->
    case Message of
        {fe_bind, A, B, C, D, E} ->
            encode_bind(A, B, C, D, E);

        {fe_cancel_request, Process_id, Secret_key} ->
            <<16:32, 1234:16, 5678:16, Process_id:32, Secret_key:32>>;

        {fe_close, What, Name} ->
            encode(
                <<"C"/utf8>>,
                <<(wire_what(What))/bitstring, (encode_string(Name))/bitstring>>
            );

        {fe_copy_data, Data} ->
            encode(<<"d"/utf8>>, Data);

        fe_copy_done ->
            <<"c"/utf8, 4:32>>;

        {fe_copy_fail, Error} ->
            encode(<<"f"/utf8>>, encode_string(Error));

        {fe_describe, What@1, Name@1} ->
            encode(
                <<"D"/utf8>>,
                <<(wire_what(What@1))/bitstring,
                    (encode_string(Name@1))/bitstring>>
            );

        {fe_execute, Portal, Count} ->
            encode(
                <<"E"/utf8>>,
                <<(encode_string(Portal))/bitstring, Count:32>>
            );

        fe_flush ->
            <<"H"/utf8, 4:32>>;

        {fe_function_call, A@1, B@1, C@1, D@1} ->
            encode_function_call(A@1, B@1, C@1, D@1);

        fe_gss_enc_request ->
            <<8:32, 1234:16, 5680:16>>;

        {fe_ambigous, {fe_gss_response, Data@1}} ->
            encode(<<"p"/utf8>>, Data@1);

        {fe_parse, A@2, B@2, C@2} ->
            encode_parse(A@2, B@2, C@2);

        {fe_ambigous, {fe_password_message, Password}} ->
            encode(<<"p"/utf8>>, encode_string(Password));

        {fe_query, Query} ->
            encode(<<"Q"/utf8>>, encode_string(Query));

        {fe_ambigous, {fe_sasl_initial_response, A@3, B@3}} ->
            encode_sasl_initial_response(A@3, B@3);

        {fe_ambigous, {fe_sasl_response, Data@2}} ->
            encode(<<"p"/utf8>>, Data@2);

        {fe_startup_message, Params} ->
            encode_startup_message(Params);

        fe_ssl_request ->
            <<8:32, 1234:16, 5679:16>>;

        fe_sync ->
            <<"S"/utf8, 4:32>>;

        fe_terminate ->
            <<"X"/utf8, 4:32>>
    end.
