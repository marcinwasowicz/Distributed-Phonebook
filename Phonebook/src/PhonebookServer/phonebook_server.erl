%%%-------------------------------------------------------------------
%%% @author marci
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(phonebook_server).

-behaviour(gen_server).

-export([start_link/0, init/1, handle_call/3, handle_cast/2,terminate/2]).
-export([add_record/4, add_record_safe_mode/4, delete_record/1, delete_record_safe_mode/1]).
-export([get_one_person/1, query_database/1, query_database/2, stop/0]).

-record(phonebook_server_state, {}).

-define(SERVER, ?MODULE).
-define(QUERY_SERVER, 'query_server@LAPTOP-7TT223E8').

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link() ->
    phonebook_logic:init_database(),
    io:format("========== Phonebook Server Correctly Initialized ==========\n"),
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
    {ok, #phonebook_server_state{}}.


handle_call({get_one_person, Phone}, _From, State = #phonebook_server_state{}) ->
    {reply, phonebook_logic:get_one_person(Phone), State};

handle_call({query_database, Queries}, _From, State = #phonebook_server_state{}) ->
    {reply, phonebook_logic:query_database(Queries), State};

handle_call({query_database, PositiveQueries, NegativeQueries}, _From, State = #phonebook_server_state{}) ->
    {reply, phonebook_logic:query_database(PositiveQueries, NegativeQueries), State};

handle_call({add_record_safe_mode, Phone, Name, Address, AdditionalData},_From, State = #phonebook_server_state{}) ->
    {reply, phonebook_logic:add_record_safe_mode(Phone, Name, Address, AdditionalData), State};

handle_call({delete_record_safe_mode, Phone}, _From, State = #phonebook_server_state{}) ->
    {reply, phonebook_logic:delete_record_safe_mode(Phone), State};

handle_call({add_record, Phone, Name, Address, AdditionalData},_From, State = #phonebook_server_state{}) ->
    {reply, phonebook_logic:add_record(Phone, Name, Address, AdditionalData), State};

handle_call({delete_record, Phone},_From, State = #phonebook_server_state{}) ->
    {reply, phonebook_logic:delete_record(Phone), State}.


handle_cast(stop, State = #phonebook_server_state{})->
    {stop, normal, State}.


terminate(_Reason, _State = #phonebook_server_state{}) ->
    phonebook_logic:close(),
    erlang:disconnect_node(?QUERY_SERVER),
    io:format("===== Server Closed =====\n"),
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================

get_one_person(Phone)->
    gen_server:call(?SERVER, {get_one_person, Phone}).

query_database(Queries)->
    gen_server:call(?SERVER, {query_database, Queries}).

query_database(PositiveQueries, NegativeQueries)->
    gen_server:call(?SERVER, {query_database, PositiveQueries, NegativeQueries}).

add_record(Phone, Name, Address, AdditionalData)->
    gen_server:call(?SERVER, {add_record, Phone, Name, Address, AdditionalData}).

add_record_safe_mode(Phone, Name, Address, AdditionalData)->
    gen_server:call(?SERVER, {add_record_safe_mode, Phone, Name, Address, AdditionalData}).

delete_record(Phone)->
    gen_server:call(?SERVER, {delete_record, Phone}).

delete_record_safe_mode(Phone)->
    gen_server:call(?SERVER, {delete_record_safe_mode, Phone}).


stop()->
    gen_server:cast(?SERVER, stop).