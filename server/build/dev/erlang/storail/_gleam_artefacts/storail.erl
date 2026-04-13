-module(storail).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/storail.gleam").
-export([key/2, namespaced_key/3, list/2, write/2, move/2, read/1, optional_read/1, delete/1, read_namespace/2, exists/1]).
-export_type([config/0, collection/1, key/1, storail_error/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " A super basic on-disc data store that uses JSON files to persist data.\n"
    "\n"
    " It doesn't have transactions, MVCC, or anything like that. It's just\n"
    " writing files to disc.\n"
    "\n"
    " Useful for tiny little projects, and for fun.\n"
).

-type config() :: {config, binary()}.

-type collection(AKWK) :: {collection,
        binary(),
        fun((AKWK) -> gleam@json:json()),
        gleam@dynamic@decode:decoder(AKWK),
        config()}.

-type key(AKWL) :: {key, collection(AKWL), list(binary()), binary()}.

-type storail_error() :: {object_not_found, list(binary()), binary()} |
    {corrupt_json, binary(), gleam@json:decode_error()} |
    {file_system_error, binary(), simplifile:file_error()}.

-file("src/storail.gleam", 82).
-spec key(collection(AKWM), binary()) -> key(AKWM).
key(Collection, Id) ->
    {key, Collection, [], Id}.

-file("src/storail.gleam", 86).
-spec namespaced_key(collection(AKWP), list(binary()), binary()) -> key(AKWP).
namespaced_key(Collection, Namespace, Id) ->
    {key, Collection, Namespace, Id}.

-file("src/storail.gleam", 115).
-spec object_tmp_path(key(any())) -> binary().
object_tmp_path(Key) ->
    Random_component = begin
        _pipe = crypto:strong_rand_bytes(16),
        _pipe@1 = gleam@bit_array:base64_url_encode(_pipe, false),
        gleam@string:slice(_pipe@1, 0, 16)
    end,
    Name = <<<<<<<<<<(erlang:element(2, erlang:element(2, Key)))/binary,
                        "-"/utf8>>/binary,
                    (erlang:element(4, Key))/binary>>/binary,
                "-"/utf8>>/binary,
            Random_component/binary>>/binary,
        ".json"/utf8>>,
    _pipe@2 = erlang:element(2, erlang:element(5, erlang:element(2, Key))),
    _pipe@3 = filepath:join(_pipe@2, <<"temporary"/utf8>>),
    filepath:join(_pipe@3, Name).

-file("src/storail.gleam", 127).
-spec ensure_parent_directory_exists(binary()) -> {ok, nil} |
    {error, storail_error()}.
ensure_parent_directory_exists(Path) ->
    _pipe = Path,
    _pipe@1 = filepath:directory_name(_pipe),
    _pipe@2 = simplifile:create_directory_all(_pipe@1),
    gleam@result:map_error(
        _pipe@2,
        fun(_capture) -> {file_system_error, Path, _capture} end
    ).

-file("src/storail.gleam", 212).
-spec read_file(binary(), list(binary()), binary()) -> {ok, bitstring()} |
    {error, storail_error()}.
read_file(Path, Namespace, Id) ->
    _pipe = simplifile_erl:read_bits(Path),
    gleam@result:map_error(_pipe, fun(Error) -> case Error of
                enoent ->
                    {object_not_found, Namespace, Id};

                _ ->
                    {file_system_error, Path, Error}
            end end).

-file("src/storail.gleam", 226).
-spec parse_json(bitstring(), binary(), gleam@dynamic@decode:decoder(AKXO)) -> {ok,
        AKXO} |
    {error, storail_error()}.
parse_json(Json, Path, Decoder) ->
    case gleam@json:parse_bits(Json, Decoder) of
        {ok, D} ->
            {ok, D};

        {error, E} ->
            {error, {corrupt_json, Path, E}}
    end.

-file("src/storail.gleam", 346).
?DOC(
    " List all objects in a namespace.\n"
    "\n"
    " # Examples\n"
    "\n"
    " ```gleam\n"
    " pub fn run(cats: Collection(Cat)) {\n"
    "   storail.list(cats, [\"owner\", \"hayleigh\"])\n"
    "   // -> Ok([\"Haskell\", \"Agda\"])\n"
    " }\n"
    " ```\n"
).
-spec list(collection(any()), list(binary())) -> {ok, list(binary())} |
    {error, storail_error()}.
list(Collection, Namespace) ->
    Path = namespace_path(Collection, Namespace),
    case simplifile_erl:read_directory(Path) of
        {error, E} ->
            case E of
                enoent ->
                    {ok, []};

                _ ->
                    {error, {file_system_error, Path, E}}
            end;

        {ok, Contents} ->
            _pipe = Contents,
            _pipe@1 = gleam@list:filter(
                _pipe,
                fun(_capture) ->
                    gleam_stdlib:string_ends_with(_capture, <<".json"/utf8>>)
                end
            ),
            _pipe@2 = gleam@list:map(
                _pipe@1,
                fun(_capture@1) -> gleam@string:drop_end(_capture@1, 5) end
            ),
            {ok, _pipe@2}
    end.

-file("src/storail.gleam", 103).
-spec namespace_path(collection(any()), list(binary())) -> binary().
namespace_path(Collection, Namespace) ->
    _pipe = erlang:element(2, erlang:element(5, Collection)),
    _pipe@1 = filepath:join(_pipe, <<"data"/utf8>>),
    _pipe@2 = filepath:join(_pipe@1, erlang:element(2, Collection)),
    gleam@list:fold(Namespace, _pipe@2, fun filepath:join/2).

-file("src/storail.gleam", 110).
-spec object_data_path(key(any())) -> binary().
object_data_path(Key) ->
    _pipe = namespace_path(erlang:element(2, Key), erlang:element(3, Key)),
    filepath:join(_pipe, <<(erlang:element(4, Key))/binary, ".json"/utf8>>).

-file("src/storail.gleam", 152).
?DOC(
    " Write an object to the file system.\n"
    "\n"
    " Writing is done by writing the JSON to the temporary directory and then by\n"
    " moving to the data directory. Moving on the same file system is an atomic\n"
    " operation for most file systems, so this should avoid data corruption from\n"
    " half-written files when writing was interupted by the VM being killed, the\n"
    " computer being unplugged, etc.\n"
    "\n"
    " # Examples\n"
    "\n"
    " ```gleam\n"
    " pub fn run(cats: Collection(Cat)) {\n"
    "   let cat = Cat(name: \"Nubi\", age: 5)\n"
    "   storail.key(cats, \"nubi\") |> storail.write(cat)\n"
    "   // -> Ok(Nil)\n"
    " }\n"
    " ```\n"
).
-spec write(key(AKXC), AKXC) -> {ok, nil} | {error, storail_error()}.
write(Key, Data) ->
    Tmp_path = object_tmp_path(Key),
    Data_path = object_data_path(Key),
    gleam@result:'try'(
        ensure_parent_directory_exists(Tmp_path),
        fun(_) ->
            gleam@result:'try'(
                ensure_parent_directory_exists(Data_path),
                fun(_) ->
                    Json = begin
                        _pipe = Data,
                        _pipe@1 = (erlang:element(3, erlang:element(2, Key)))(
                            _pipe
                        ),
                        gleam@json:to_string(_pipe@1)
                    end,
                    gleam@result:'try'(
                        begin
                            _pipe@2 = simplifile:write(Tmp_path, Json),
                            gleam@result:map_error(
                                _pipe@2,
                                fun(_capture) ->
                                    {file_system_error, Tmp_path, _capture}
                                end
                            )
                        end,
                        fun(_) ->
                            gleam@result:'try'(
                                begin
                                    _pipe@3 = simplifile_erl:rename_file(
                                        Tmp_path,
                                        Data_path
                                    ),
                                    gleam@result:map_error(
                                        _pipe@3,
                                        fun(_capture@1) ->
                                            {file_system_error,
                                                Data_path,
                                                _capture@1}
                                        end
                                    )
                                end,
                                fun(_) -> {ok, nil} end
                            )
                        end
                    )
                end
            )
        end
    ).

-file("src/storail.gleam", 195).
?DOC(
    " Move an object from one location to another in the store.\n"
    "\n"
    " Returns an error if there is no object at that location, or if unable to\n"
    " perform the file system operation.\n"
    "\n"
    " # Examples\n"
    "\n"
    " ```gleam\n"
    " pub fn run(cats: Collection(Cat)) {\n"
    "   let old = storail.key(cats, \"baby\")\n"
    "   let new = storail.key(cats, \"grown-up-baby\")\n"
    "   storail.move(from: old, to: new)\n"
    "   // -> Ok(Nil)\n"
    " }\n"
    " ```\n"
).
-spec move(key(AKXG), key(AKXG)) -> {ok, nil} | {error, storail_error()}.
move(Location, Destination) ->
    Old = object_data_path(Location),
    New = object_data_path(Destination),
    gleam@result:'try'(
        ensure_parent_directory_exists(New),
        fun(_) -> _pipe = simplifile_erl:rename_file(Old, New),
            gleam@result:map_error(_pipe, fun(Error) -> case Error of
                        enoent ->
                            {object_not_found,
                                erlang:element(3, Location),
                                erlang:element(4, Location)};

                        _ ->
                            {file_system_error, Old, Error}
                    end end) end
    ).

-file("src/storail.gleam", 248).
?DOC(
    " Read an object from the file system.\n"
    "\n"
    " # Examples\n"
    "\n"
    " ```gleam\n"
    " pub fn run(cats: Collection(Cat)) {\n"
    "   storail.key(cats, \"nubi\") |> storail.read\n"
    "   // -> Ok(Cat(name: \"Nubi\", age: 5))\n"
    " }\n"
    " ```\n"
).
-spec read(key(AKXS)) -> {ok, AKXS} | {error, storail_error()}.
read(Key) ->
    Path = object_data_path(Key),
    gleam@result:'try'(
        read_file(Path, erlang:element(3, Key), erlang:element(4, Key)),
        fun(Json) ->
            parse_json(Json, Path, erlang:element(4, erlang:element(2, Key)))
        end
    ).

-file("src/storail.gleam", 269).
?DOC(
    " Read an object from the file system, returning `None` if there was no\n"
    " object with the given key.\n"
    "\n"
    " # Examples\n"
    "\n"
    " ```gleam\n"
    " pub fn run(cats: Collection(Cat)) {\n"
    "   storail.key(cats, \"nubi\") |> storail.optional_read\n"
    "   // -> Ok(Some(Cat(name: \"Nubi\", age: 5)))\n"
    "\n"
    "   storail.key(cats, \"mills\") |> storail.optional_read\n"
    "   // -> Ok(None)\n"
    " }\n"
    " ```\n"
).
-spec optional_read(key(AKXW)) -> {ok, gleam@option:option(AKXW)} |
    {error, storail_error()}.
optional_read(Key) ->
    Path = object_data_path(Key),
    case read_file(Path, erlang:element(3, Key), erlang:element(4, Key)) of
        {ok, Json} ->
            _pipe = parse_json(
                Json,
                Path,
                erlang:element(4, erlang:element(2, Key))
            ),
            gleam@result:map(_pipe, fun(Field@0) -> {some, Field@0} end);

        {error, {object_not_found, _, _}} ->
            {ok, none};

        {error, E} ->
            {error, E}
    end.

-file("src/storail.gleam", 290).
?DOC(
    " Delete an object from the file system.\n"
    "\n"
    " # Examples\n"
    "\n"
    " ```gleam\n"
    " pub fn run(cats: Collection(Cat)) {\n"
    "   storail.key(cats, \"nubi\") |> storail.delete\n"
    "   // -> Ok(Nil)\n"
    " }\n"
    " ```\n"
).
-spec delete(key(any())) -> {ok, nil} | {error, storail_error()}.
delete(Key) ->
    Path = object_data_path(Key),
    _pipe = simplifile:delete_all([Path]),
    gleam@result:map_error(
        _pipe,
        fun(_capture) -> {file_system_error, Path, _capture} end
    ).

-file("src/storail.gleam", 310).
?DOC(
    " Read all objects from a namespace.\n"
    "\n"
    " # Examples\n"
    "\n"
    " ```gleam\n"
    " pub fn run(cats: Collection(Cat)) {\n"
    "   storail.read_namespace(cats, [\"owner\", \"hayleigh\"])\n"
    "   // -> Ok(dict.from_list([\n"
    "   //   #(\"Haskell\", Cat(name: \"Haskell\", age: 3)),\n"
    "   //   #(\"Agda\", Cat(name: \"Agda\", age: 2)),\n"
    "   // ]))\n"
    " }\n"
    " ```\n"
).
-spec read_namespace(collection(AKYF), list(binary())) -> {ok,
        gleam@dict:dict(binary(), AKYF)} |
    {error, storail_error()}.
read_namespace(Collection, Namespace) ->
    Path = namespace_path(Collection, Namespace),
    case simplifile_erl:read_directory(Path) of
        {error, E} ->
            case E of
                enoent ->
                    {ok, maps:new()};

                _ ->
                    {error, {file_system_error, Path, E}}
            end;

        {ok, Contents} ->
            _pipe = Contents,
            _pipe@1 = gleam@list:filter(
                _pipe,
                fun(_capture) ->
                    gleam_stdlib:string_ends_with(_capture, <<".json"/utf8>>)
                end
            ),
            _pipe@3 = gleam@list:try_map(
                _pipe@1,
                fun(Filename) ->
                    Id = begin
                        _pipe@2 = Filename,
                        gleam@string:drop_end(_pipe@2, 5)
                    end,
                    Path@1 = filepath:join(Path, Filename),
                    gleam@result:'try'(
                        read_file(Path@1, Namespace, Id),
                        fun(Json) ->
                            gleam@result:map(
                                parse_json(
                                    Json,
                                    Path@1,
                                    erlang:element(4, Collection)
                                ),
                                fun(Data) -> {Id, Data} end
                            )
                        end
                    )
                end
            ),
            gleam@result:map(_pipe@3, fun maps:from_list/1)
    end.

-file("src/storail.gleam", 369).
?DOC(
    " Check whether an object exists with the given key.\n"
    "\n"
    " The validity of the object data is not checked, only the existance is.\n"
).
-spec exists(key(any())) -> {ok, boolean()} | {error, storail_error()}.
exists(Key) ->
    Path = object_data_path(Key),
    _pipe = simplifile_erl:is_file(Path),
    gleam@result:map_error(
        _pipe,
        fun(_capture) -> {file_system_error, Path, _capture} end
    ).
