Descriptions of modules:
1. query_server module implements an OTP server that accpets requests identical to those accepted by phonebook server, sends same requests
to all phonebook server on nodes forming database, collects results into one list, and sends it back to client. 
2. Other modules are server supervisor and application.
