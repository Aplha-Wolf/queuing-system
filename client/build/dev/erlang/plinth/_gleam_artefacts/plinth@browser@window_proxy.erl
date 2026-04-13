-module(plinth@browser@window_proxy).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/plinth/browser/window_proxy.gleam").
-export_type([window_proxy/0]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

?MODULEDOC(
    " This is a module for Window like objects\n"
    " \n"
    " Functions such as window.opener return a WindowProxy.\n"
    " This is not part of the inheritance chain of Window.\n"
    " To type the API of window.gleam well proxy needs to be\n"
    " in a separate module, this module.\n"
    " \n"
    " https://developer.mozilla.org/en-US/docs/Glossary/WindowProxy\n"
    " \n"
    " Most implementations call into window_ffi.\n"
).

-type window_proxy() :: any().


