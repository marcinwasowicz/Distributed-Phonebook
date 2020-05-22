%%%-------------------------------------------------------------------
%%% @author marci
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(query_app).

-behaviour(application).

-export([start/2, stop/1, start/0, stop/0]).

start(_StartType, _StartArgs) ->
    query_supervisor:start_link().

start()->
    application:start(?MODULE).

stop(_State) ->
    ok.

stop()->
    application:stop(?MODULE).
