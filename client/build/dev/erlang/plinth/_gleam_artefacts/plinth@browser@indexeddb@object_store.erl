-module(plinth@browser@indexeddb@object_store).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/plinth/browser/indexeddb/object_store.gleam").
-export_type([object_store/0, db_request/0]).

-type object_store() :: any().

-type db_request() :: any().


