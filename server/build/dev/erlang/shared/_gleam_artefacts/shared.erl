-module(shared).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/shared.gleam").
-export([main/0]).

-file("src/shared.gleam", 3).
-spec main() -> nil.
main() ->
    gleam_stdlib:println(<<"Hello from shared!"/utf8>>).
