%%%-------------------------------------------------------------------
%%% @author marci
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(phonebook_supervisor).

-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, phonebook_supervisor}, ?MODULE, []).

init([]) ->
    AChild = #{id => 'phonebook_server',
        start => {phonebook_server, start_link, []},
        restart => permanent,
        shutdown => 2000,
        type => worker,
        modules => [phonebook_server]},

    {ok, {#{strategy => one_for_one,
        intensity => 5,
        period => 30},
        [AChild]}
    }.
