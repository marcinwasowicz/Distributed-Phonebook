Descriptions of modules:
1. Module phonebook_logic implements functions to manipulate and retrieve data from local mnesia table kept on node.
   Tables of the database store erlang records of type:
   record(person, {phone, name, address, additional_info}). All of name, address, additional_info are erlang maps and phone is a number
   (and a key in mnesia table, tables are of type set). For example records stored in mnesia tables might look like this:
   #person{123456789, #{"name" => "ala", "surname" => "makota"}, #{"country"=> "poland", "city"=>"kraków"}, #{"job"=>"doctor"}}
   Now we can use function query_database from module phonebook_logic to retrieve all records from database that live in poland:
   phonebook_logic:query_database([#{}, #{"country"=>"poland"}, #{}]), query_database function uses qlc and maps pattern matching.
2. Module phonebook_server can accept queries to database, and send back results.
3. Other modules are server supervisor and application. Once phonebook_app is started connection to query server node is made.
   
