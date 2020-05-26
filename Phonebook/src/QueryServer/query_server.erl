%%%-------------------------------------------------------------------
%%% @author marci
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(query_server).

-behaviour(gen_server).

-export([start_link/0,init/1, handle_call/3, handle_cast/2,terminate/2]).
-export([get_one_person/1, query_database/3, stop/0, filter_result/1]).

-define(SERVER, ?MODULE).

-record(query_server_state, {}).
-record(person, {phone, name, address, additional_data}).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
    io:format("========= Query Server Correctly Initialized ==========\n"),
    {ok, #query_server_state{}}.


handle_call({query_database, NameQuery, AddressQuery, AdditionalQuery}, _From, State = #query_server_state{}) ->
    {QueryResult, _} = rpc:multicall(nodes(), phonebook_server, query_database,
        [NameQuery, AddressQuery, AdditionalQuery]),
    {reply, lists:filter(fun(El) -> filter_result(El) end, QueryResult), State};


handle_call({get_one_person, Phone}, _From, State = #query_server_state{})->
    {QueryResult, _} = rpc:multicall(nodes(), phonebook_server, get_one_person, [Phone]),
    {reply, lists:filter(fun(El) -> filter_result(El) end, QueryResult), State}.


handle_cast(stop, _State = #query_server_state{})->
    {stop, normal, _State}.


terminate(_Reason, _State = #query_server_state{}) ->
    io:format("========= Server Correctly Closed ==========\n"),
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================

filter_result([#person{} | _])->
    true;
filter_result(_Result)->
    false.

get_one_person(Phone)->
    gen_server:call(?SERVER, {get_one_person, Phone}).

query_database(NameQuery, AddressQuery, AdditionalQuery)->
    gen_server:call(?SERVER, {query_database, NameQuery, AddressQuery, AdditionalQuery}).

stop()->
    gen_server:cast(?SERVER, stop).
