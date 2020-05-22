%%%-------------------------------------------------------------------
%%% @author marci
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(phonebook_app).

-behaviour(application).

-export([start/2, stop/1, start/0, stop/0]).

start()->
    application:start(phonebook_app).

start(_StartType, _StartArgs) ->
   phonebook_supervisor:start_link().

stop()->
    application:stop(phonebook_app).

stop(_State) ->
    mnesia:stop(),
    ok.
