%%%-------------------------------------------------------------------
%%% @author marci
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. maj 2020 00:01
%%%-------------------------------------------------------------------
{application, query_app, [
    {description, ""},
    {vsn, "1"},
    {registered, [query_server, query_supervisor]},
    {applications, [
        kernel,
        stdlib
    ]},
    {mod, {query_app, []}},
    {env, []},
    {modules, [query_app, query_supervisor, query_server]}
]}.