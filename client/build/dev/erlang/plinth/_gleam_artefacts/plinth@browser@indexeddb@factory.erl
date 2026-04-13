-module(plinth@browser@indexeddb@factory).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/plinth/browser/indexeddb/factory.gleam").
-export_type([factory/0, open_db_request/0]).

-type factory() :: any().

-type open_db_request() :: any().


