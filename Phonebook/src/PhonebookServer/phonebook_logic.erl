%%%-------------------------------------------------------------------
%%% @author marci
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. maj 2020 16:29
%%%-------------------------------------------------------------------
-module(phonebook_logic).
-author("marci").
-include_lib("stdlib/include/qlc.hrl").

%% API
-export([create_database/0, drop_database/0, add_record/4, add_record_safe_mode/4, delete_record/1]).
-export([delete_record_safe_mode/1,get_one_person/1, init_database/0, close/0]).
-export([match_maps/3, query_database/2, query_database/1]).

-record(person, {phone, name, address, additional_data}).

match_maps(Pattern, Map, StartAcc)->
    Predicate = fun(K, V, Acc) ->
        case Map of
            #{K := V} -> Acc;
            _ -> not StartAcc
        end
     end,
     maps:fold(Predicate, StartAcc, Pattern).

init_database()->
    mnesia:start(),
    try
        mnesia:table_info(type, person)
    catch
        exit: _  ->
            create_database()
    end.

create_database()->
    mnesia:create_table(person, [{attributes, record_info(fields, person)}, {type, set},
        {disc_copies, [node()]},{local_content, true}]).

add_record(Phone, Name, Address,Additional_data)->
    mnesia:transaction(
        fun()->
            mnesia:write(#person{phone = Phone, name = Name, address = Address, additional_data = Additional_data})
        end).

add_record_safe_mode(Phone, Name, Address, Additional_data)->
    mnesia:transaction(
        fun()->
            case mnesia:read({person, Phone}) of
                [_X] -> {error,"owerriting existing data not available in safe mode"};
                _ -> mnesia:write(#person{phone = Phone, name = Name, address = Address, additional_data = Additional_data})
            end
        end).

delete_record(PhoneKey)->
    mnesia:transaction(
        fun()->
            mnesia:delete({person, PhoneKey})
        end).

delete_record_safe_mode(PhoneKey)->
    mnesia:transaction(
        fun()->
            case mnesia:read({person, PhoneKey}) of
                [_X] -> mnesia:delete({person, PhoneKey});
                _ -> {error, "deleting non-existing key forbidden"}
            end
        end).

get_one_person(Phone)->
    {_, List} = mnesia:transaction(
        fun()->
            mnesia:read({person, Phone})
        end),
    List.

query_database([NameQuery, AddressQuery, AdditionalQuery])->
    RunQuery =
        fun()->
            Query = qlc:q([Person || Person <- mnesia:table(person),
                match_maps(NameQuery, Person#person.name, true),
                match_maps(AddressQuery, Person#person.address, true),
                match_maps(AdditionalQuery, Person#person.additional_data, true)]),
            qlc:e(Query)
        end,
    {_, List} = mnesia:transaction(RunQuery),
    List.

query_database([NameQueryPositive, AddressQueryPositive, AdditionalQueryPositive],
    [NameQueryNegative, AddressQueryNegative, AdditionalQueryNegative])->
    RunQuery =
        fun()->
            Query = qlc:q([Person || Person <- mnesia:table(person),
                match_maps(NameQueryPositive, Person#person.name, true),
                match_maps(AddressQueryPositive, Person#person.address, true),
                match_maps(AdditionalQueryPositive, Person#person.additional_data, true),
                match_maps(NameQueryNegative, Person#person.name, false),
                match_maps(AddressQueryNegative, Person#person.address, false),
                match_maps(AdditionalQueryNegative, Person#person.additional_data, false)]),
            qlc:e(Query)
        end,
    {_, List} = mnesia:transaction(RunQuery),
    List.

drop_database()->
    mnesia:delete_table(person).

close()->
    mnesia:stop().