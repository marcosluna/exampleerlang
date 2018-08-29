%% Sample REST Webservice Endpoint with JSON content
%% @author Marcos Luna <marcos.luna@consultant.com>
%% @since 2018-08-28
%% @version 0.0.0.1

-module(websrvhttp).
-export([start/0]).

%%This sample script shows how a simple REST webservice can be exposed on a given port


%% @TODO The msg function should be modified to have a more dynamic value asignment.
msg() -> "{\"message\": {\"text\":\"Some data will appear\",\"Desc\":\"And it should have some meaning\"}}".



start() ->
    spawn(fun () -> {ok, Sock} = gen_tcp:listen(8888, [{active, false}]), 
                    loop(Sock) end).

loop(Sock) ->
    {ok, Conn} = gen_tcp:accept(Sock),
    Handler = spawn(fun () -> handle(Conn) end),
    gen_tcp:controlling_process(Conn, Handler),
    loop(Sock).


handle(Conn) ->
    gen_tcp:send(Conn, response(msg())),
    gen_tcp:close(Conn).

%% @TODO the status code should be dynamic 
statusR() -> "200 Custom OK".

response(String) ->
    B = iolist_to_binary(String),
    iolist_to_binary(
      io_lib:fwrite(
         "HTTP/1.0 "++statusR()++"\nContent-Type: application/json\nContent-Length: ~p\n\n~s",
         [size(B), B])). 