-module(plinth@browser@indexeddb@database).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/plinth/browser/indexeddb/database.gleam").
-export_type([database/0, mode/0, durability/0]).

-type database() :: any().

-type mode() :: read_only | read_write | read_write_flush.

-type durability() :: strict | relaxed | default.

-file("src/plinth/browser/indexeddb/database.gleam", 73).
-spec mode_to_string(mode()) -> binary().
mode_to_string(Mode) ->
    case Mode of
        read_only ->
            <<"readonly"/utf8>>;

        read_write ->
            <<"readwrite"/utf8>>;

        read_write_flush ->
            <<"readwriteflush"/utf8>>
    end.

-file("src/plinth/browser/indexeddb/database.gleam", 87).
-spec durability_to_string(durability()) -> binary().
durability_to_string(Durability) ->
    case Durability of
        strict ->
            <<"strict"/utf8>>;

        relaxed ->
            <<"relaxed"/utf8>>;

        default ->
            <<"default"/utf8>>
    end.
