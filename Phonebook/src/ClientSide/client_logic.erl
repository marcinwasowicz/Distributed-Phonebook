%%%-------------------------------------------------------------------
%%% @author marci
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. maj 2020 11:49
%%%-------------------------------------------------------------------
-module(client_logic).
-author("marci").

%% API
-export([start_session/0, end_session/0,get_one_person/1, query_database/3]).

-define(QUERY_SERVER, 'query_server@LAPTOP-7TT223E8').

start_session()->
    net_adm:ping(?QUERY_SERVER).

end_session()->
    erlang:disconnect_node(?QUERY_SERVER).

get_one_person(Phone)->
    rpc:call(?QUERY_SERVER, query_server, get_one_person, [Phone]).

query_database(Name, Address, Additional)->
    rpc:call(?QUERY_SERVER, query_server, query_database, [Name, Address, Additional]).


