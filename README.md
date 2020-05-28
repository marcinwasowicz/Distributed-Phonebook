This repository contains simple distributed database based on Erlang and Mnesia. As the title suggests database is designed to store 
data similar to those stored in ordinary phonebook - phone number, addres, country, company etc. Project consists of three parts:
1. Database server - an OTP server that is able to retrieve data from mnesia table kept on the node the server is running on.
2. Query server - an OTP server that accepts requests from clients to retrieve data from database, collects responses from servers on all 
   nodes that form database, and sends data back to client. 
3.  Client side - module with functions to send requests to query server.
All modules above should be run on nodes with flag -connect_all false - to avoid forming redundant connections.
