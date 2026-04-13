-module(plinth@browser@eventsource).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/plinth/browser/eventsource.gleam").
-export_type([event_source/0]).

-type event_source() :: any().


