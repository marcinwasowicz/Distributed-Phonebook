%%%-------------------------------------------------------------------
%%% @author marci
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. maj 2020 00:06
%%%-------------------------------------------------------------------
{application, phonebook_app, [
    {description, ""},
    {vsn, "1"},
    {registered, [phonebook_server, phonebook_supervisor]},
    {applications, [
        kernel,
        stdlib
    ]},
    {mod, {phonebook_app, []}},
    {env, []},
    {modules, [phonebook_app, phonebook_supervisor, phonebook_server, phonebook_logic]}
]}.