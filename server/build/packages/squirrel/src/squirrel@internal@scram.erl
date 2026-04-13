-module(squirrel@internal@scram).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/squirrel/internal/scram.gleam").
-export([encode_client_first/1, parse_server_first/2, nonce/0, encode_client_last/1, parse_server_final/1]).
-export_type([client_first/0, client_last/0, server_first/0, server_last/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(false).

-type client_first() :: {client_first, binary(), binary()}.

-type client_last() :: {client_last, client_first(), server_first(), binary()}.

-type server_first() :: {server_first,
        binary(),
        bitstring(),
        integer(),
        bitstring()}.

-type server_last() :: {successful, bitstring()} | {failed, bitstring()}.

-file("src/squirrel/internal/scram.gleam", 57).
?DOC(false).
-spec client_first_without_header(client_first()) -> bitstring().
client_first_without_header(Msg) ->
    <<"n="/utf8,
        (erlang:element(2, Msg))/binary,
        ",r="/utf8,
        (erlang:element(3, Msg))/binary>>.

-file("src/squirrel/internal/scram.gleam", 53).
?DOC(false).
-spec encode_client_first(client_first()) -> bitstring().
encode_client_first(Msg) ->
    <<"n,,"/utf8, (client_first_without_header(Msg))/bitstring>>.

-file("src/squirrel/internal/scram.gleam", 124).
?DOC(false).
-spec parse_server_first(bitstring(), binary()) -> {ok, server_first()} |
    {error, nil}.
parse_server_first(Msg, Client_nonce) ->
    gleam@result:'try'(
        gleam@bit_array:to_string(Msg),
        fun(String_msg) ->
            Parts = gleam@string:split(String_msg, <<","/utf8>>),
            case Parts of
                [<<"r="/utf8, Nonce/binary>>,
                    <<"s="/utf8, Salt/binary>>,
                    <<"i="/utf8, Iterations/binary>>] ->
                    gleam@result:'try'(
                        gleam_stdlib:parse_int(Iterations),
                        fun(Iterations@1) ->
                            gleam@result:'try'(
                                gleam@bit_array:base64_decode(Salt),
                                fun(Salt@1) ->
                                    case gleam_stdlib:string_starts_with(
                                        Nonce,
                                        Client_nonce
                                    ) of
                                        true ->
                                            {ok,
                                                {server_first,
                                                    Nonce,
                                                    Salt@1,
                                                    Iterations@1,
                                                    Msg}};

                                        false ->
                                            {error, nil}
                                    end
                                end
                            )
                        end
                    );

                [<<"r="/utf8, Nonce/binary>>,
                    <<"i="/utf8, Iterations/binary>>,
                    <<"s="/utf8, Salt/binary>>] ->
                    gleam@result:'try'(
                        gleam_stdlib:parse_int(Iterations),
                        fun(Iterations@1) ->
                            gleam@result:'try'(
                                gleam@bit_array:base64_decode(Salt),
                                fun(Salt@1) ->
                                    case gleam_stdlib:string_starts_with(
                                        Nonce,
                                        Client_nonce
                                    ) of
                                        true ->
                                            {ok,
                                                {server_first,
                                                    Nonce,
                                                    Salt@1,
                                                    Iterations@1,
                                                    Msg}};

                                        false ->
                                            {error, nil}
                                    end
                                end
                            )
                        end
                    );

                [<<"i="/utf8, Iterations/binary>>,
                    <<"s="/utf8, Salt/binary>>,
                    <<"r="/utf8, Nonce/binary>>] ->
                    gleam@result:'try'(
                        gleam_stdlib:parse_int(Iterations),
                        fun(Iterations@1) ->
                            gleam@result:'try'(
                                gleam@bit_array:base64_decode(Salt),
                                fun(Salt@1) ->
                                    case gleam_stdlib:string_starts_with(
                                        Nonce,
                                        Client_nonce
                                    ) of
                                        true ->
                                            {ok,
                                                {server_first,
                                                    Nonce,
                                                    Salt@1,
                                                    Iterations@1,
                                                    Msg}};

                                        false ->
                                            {error, nil}
                                    end
                                end
                            )
                        end
                    );

                [<<"i="/utf8, Iterations/binary>>,
                    <<"r="/utf8, Nonce/binary>>,
                    <<"s="/utf8, Salt/binary>>] ->
                    gleam@result:'try'(
                        gleam_stdlib:parse_int(Iterations),
                        fun(Iterations@1) ->
                            gleam@result:'try'(
                                gleam@bit_array:base64_decode(Salt),
                                fun(Salt@1) ->
                                    case gleam_stdlib:string_starts_with(
                                        Nonce,
                                        Client_nonce
                                    ) of
                                        true ->
                                            {ok,
                                                {server_first,
                                                    Nonce,
                                                    Salt@1,
                                                    Iterations@1,
                                                    Msg}};

                                        false ->
                                            {error, nil}
                                    end
                                end
                            )
                        end
                    );

                [<<"s="/utf8, Salt/binary>>,
                    <<"r="/utf8, Nonce/binary>>,
                    <<"i="/utf8, Iterations/binary>>] ->
                    gleam@result:'try'(
                        gleam_stdlib:parse_int(Iterations),
                        fun(Iterations@1) ->
                            gleam@result:'try'(
                                gleam@bit_array:base64_decode(Salt),
                                fun(Salt@1) ->
                                    case gleam_stdlib:string_starts_with(
                                        Nonce,
                                        Client_nonce
                                    ) of
                                        true ->
                                            {ok,
                                                {server_first,
                                                    Nonce,
                                                    Salt@1,
                                                    Iterations@1,
                                                    Msg}};

                                        false ->
                                            {error, nil}
                                    end
                                end
                            )
                        end
                    );

                [<<"s="/utf8, Salt/binary>>,
                    <<"i="/utf8, Iterations/binary>>,
                    <<"r="/utf8, Nonce/binary>>] ->
                    gleam@result:'try'(
                        gleam_stdlib:parse_int(Iterations),
                        fun(Iterations@1) ->
                            gleam@result:'try'(
                                gleam@bit_array:base64_decode(Salt),
                                fun(Salt@1) ->
                                    case gleam_stdlib:string_starts_with(
                                        Nonce,
                                        Client_nonce
                                    ) of
                                        true ->
                                            {ok,
                                                {server_first,
                                                    Nonce,
                                                    Salt@1,
                                                    Iterations@1,
                                                    Msg}};

                                        false ->
                                            {error, nil}
                                    end
                                end
                            )
                        end
                    );

                _ ->
                    {error, nil}
            end
        end
    ).

-file("src/squirrel/internal/scram.gleam", 45).
?DOC(false).
-spec nonce() -> binary().
nonce() ->
    Random_bytes = 16,
    Bytes = crypto:strong_rand_bytes(Random_bytes),
    Unique = binary:encode_unsigned(squirrel_ffi:unique()),
    Nonce = <<Random_bytes,
        Bytes:(lists:max([(Random_bytes), 0]))/bitstring,
        Unique/bitstring>>,
    gleam_stdlib:bit_array_base64_encode(Nonce, true).

-file("src/squirrel/internal/scram.gleam", 110).
?DOC(false).
-spec do_hi(
    bitstring(),
    gleam@crypto:hash_algorithm(),
    bitstring(),
    bitstring(),
    integer()
) -> bitstring().
do_hi(String, Algorithm, U, Hi, Iterations) ->
    case Iterations =< 0 of
        true ->
            Hi;

        false ->
            U@1 = gleam_crypto_ffi:hmac(U, Algorithm, String),
            Hi@1 = crypto:exor(Hi, U@1),
            do_hi(String, Algorithm, U@1, Hi@1, Iterations - 1)
    end.

-file("src/squirrel/internal/scram.gleam", 104).
?DOC(false).
-spec hi(binary(), gleam@crypto:hash_algorithm(), bitstring(), integer()) -> bitstring().
hi(String, Algorithm, Salt, Iterations) ->
    Acc = gleam_crypto_ffi:hmac(
        <<Salt/bitstring, 1:32/integer-big>>,
        Algorithm,
        <<String/binary>>
    ),
    do_hi(<<String/binary>>, Algorithm, Acc, Acc, Iterations - 1).

-file("src/squirrel/internal/scram.gleam", 61).
?DOC(false).
-spec encode_client_last(client_last()) -> {bitstring(), bitstring()}.
encode_client_last(Client_last) ->
    {client_last, Client_first, Server_first, Password} = Client_last,
    Alg = sha256,
    Client_final_without_proof = <<"c=biws,"/utf8,
        "r="/utf8,
        (erlang:element(2, Server_first))/binary>>,
    Auth = <<(client_first_without_header(Client_first))/bitstring,
        ","/utf8,
        (erlang:element(5, Server_first))/bitstring,
        ","/utf8,
        Client_final_without_proof/bitstring>>,
    Salted_password = hi(
        Password,
        Alg,
        erlang:element(3, Server_first),
        erlang:element(4, Server_first)
    ),
    Client_key = gleam_crypto_ffi:hmac(
        <<"Client Key"/utf8>>,
        Alg,
        Salted_password
    ),
    Stored_key = gleam@crypto:hash(Alg, Client_key),
    Client_signature = gleam_crypto_ffi:hmac(Auth, Alg, Stored_key),
    Client_proof = begin
        _pipe = crypto:exor(Client_key, Client_signature),
        gleam_stdlib:bit_array_base64_encode(_pipe, true)
    end,
    Server_key = gleam_crypto_ffi:hmac(
        <<"Server Key"/utf8>>,
        Alg,
        Salted_password
    ),
    Server_signature = gleam_crypto_ffi:hmac(Auth, Alg, Server_key),
    Client_last@1 = <<Client_final_without_proof/bitstring,
        ",p="/utf8,
        Client_proof/binary>>,
    {Client_last@1, Server_signature}.

-file("src/squirrel/internal/scram.gleam", 151).
?DOC(false).
-spec parse_server_final(bitstring()) -> {ok, server_last()} | {error, nil}.
parse_server_final(Msg) ->
    case Msg of
        <<"v="/utf8, Rest/bitstring>> ->
            case binary:split(Rest, <<","/utf8>>) of
                [Proof | _] ->
                    gleam@result:'try'(
                        gleam@bit_array:to_string(Proof),
                        fun(Proof@1) ->
                            gleam@result:'try'(
                                gleam@bit_array:base64_decode(Proof@1),
                                fun(Proof@2) -> {ok, {successful, Proof@2}} end
                            )
                        end
                    );

                _ ->
                    {error, nil}
            end;

        <<"e="/utf8, Rest@1/bitstring>> ->
            {ok, {failed, Rest@1}};

        _ ->
            {error, nil}
    end.
