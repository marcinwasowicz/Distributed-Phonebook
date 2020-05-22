%%%-------------------------------------------------------------------
%%% @author marci
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(phonebook_app).

-behaviour(application).

-export([start/2, stop/1, start/0, stop/0]).

-define(QUERY_SERVER, 'query_server@LAPTOP-7TT223E8').


start()->
    application:start(?MODULE).

start(_StartType, _StartArgs) ->
   net_adm:ping(?QUERY_SERVER),
   phonebook_supervisor:start_link().

stop()->
    application:stop(?MODULE).

stop(_State) ->
    ok.
