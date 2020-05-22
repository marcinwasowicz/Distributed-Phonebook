%%%-------------------------------------------------------------------
%%% @author marci
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(query_supervisor).

-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    AChild = #{id => 'query_server',
        start => {'query_server', start_link, []},
        restart => permanent,
        shutdown => 2000,
        type => worker,
        modules => ['query_server']},

    {ok, {#{strategy => one_for_one,
        intensity => 5,
        period => 30},
        [AChild]}
    }.
