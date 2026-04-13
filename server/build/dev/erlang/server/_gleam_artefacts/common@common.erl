-module(common@common).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch, inline]).
-define(FILEPATH, "src/common/common.gleam").
-export([api_status_to_int/1, get_limit_from_query/1, get_offset_from_query/1, get_limit_result_from_query/1, get_offset_result_from_query/1]).
-export_type([api_status/0]).

-type api_status() :: api_stat_ok | api_status_warn | api_status_err.

-file("src/common/common.gleam", 10).
-spec api_status_to_int(api_status()) -> integer().
api_status_to_int(Status) ->
    case Status of
        api_stat_ok ->
            0;

        api_status_warn ->
            1;

        api_status_err ->
            2
    end.

-file("src/common/common.gleam", 18).
-spec get_limit_from_query(list({binary(), binary()})) -> integer().
get_limit_from_query(Query) ->
    Res = begin
        _pipe = maps:from_list(Query),
        _pipe@1 = gleam_stdlib:map_get(_pipe, <<"limit"/utf8>>),
        (fun(X) -> case X of
                {ok, Limit} ->
                    case gleam_stdlib:parse_int(Limit) of
                        {ok, Y} ->
                            Y;

                        {error, _} ->
                            0
                    end;

                {error, _} ->
                    0
            end end)(_pipe@1)
    end,
    Res.

-file("src/common/common.gleam", 35).
-spec get_offset_from_query(list({binary(), binary()})) -> integer().
get_offset_from_query(Query) ->
    Res = begin
        _pipe = maps:from_list(Query),
        _pipe@1 = gleam_stdlib:map_get(_pipe, <<"offset"/utf8>>),
        (fun(X) -> case X of
                {ok, Offset} ->
                    case gleam_stdlib:parse_int(Offset) of
                        {ok, Y} ->
                            Y;

                        {error, _} ->
                            0
                    end;

                {error, _} ->
                    0
            end end)(_pipe@1)
    end,
    Res.

-file("src/common/common.gleam", 52).
-spec get_limit_result_from_query(list({binary(), binary()})) -> {ok, integer()} |
    {error, integer()}.
get_limit_result_from_query(Query) ->
    Res = begin
        _pipe = maps:from_list(Query),
        _pipe@1 = gleam_stdlib:map_get(_pipe, <<"limit"/utf8>>),
        (fun(X) -> case X of
                {ok, Limit} ->
                    case gleam_stdlib:parse_int(Limit) of
                        {ok, Y} ->
                            {ok, Y};

                        {error, _} ->
                            {error, 0}
                    end;

                {error, _} ->
                    {error, 0}
            end end)(_pipe@1)
    end,
    Res.

-file("src/common/common.gleam", 71).
-spec get_offset_result_from_query(list({binary(), binary()})) -> {ok,
        integer()} |
    {error, integer()}.
get_offset_result_from_query(Query) ->
    Res = begin
        _pipe = maps:from_list(Query),
        _pipe@1 = gleam_stdlib:map_get(_pipe, <<"offset"/utf8>>),
        (fun(X) -> case X of
                {ok, Offset} ->
                    case gleam_stdlib:parse_int(Offset) of
                        {ok, Y} ->
                            {ok, Y};

                        {error, _} ->
                            {error, 0}
                    end;

                {error, _} ->
                    {error, 0}
            end end)(_pipe@1)
    end,
    Res.
