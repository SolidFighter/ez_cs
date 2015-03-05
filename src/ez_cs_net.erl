-module(ez_cs_net).
-export([start/0, loop/1, listen/1]).

start() ->
  {ok, Listen} = gen_tcp:listen(4345, [binary, {packet, 4},  
    {reuseaddr, true},
    {active, once}]),
  spawn(ez_cs_net, listen, [Listen]).

listen(Listen) ->
  {ok, Socket} = gen_tcp:accept(Listen),
  io:format("Server Socket = ~p.~n",[Socket]),
  spawn(ez_cs_net, listen, [Listen]),
  loop(Socket).

loop(Socket) ->
  receive
    {tcp, Socket, Bin} ->
      inet:setopts(Socket, [{active, once}]),
      Reply = case binary_to_term(Bin) of 
        {getconfig} ->
          ez_cs:get();
        Other ->
          no_operation
      end,
      gen_tcp:send(Socket, term_to_binary(Reply)),  
      loop(Socket);
    {tcp_closed, Socket} ->
      io:format("Server socket closed~n")
  end.
