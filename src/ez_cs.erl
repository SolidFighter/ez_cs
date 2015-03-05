-module(ez_cs).
%% gen_server_mini_template
-behaviour(gen_server).
-export([start/0]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
  terminate/2, code_change/3]).

%% client method
-export([register/1, unregister/1, get/0]).
-define(SERVER, ?MODULE).

start() -> 
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []),
  ez_cs_net:start().

init([]) -> 
  %% Note we must set trap_exit = true if we 
  %% want terminate/2 to be called when the application
  %% is stopped
  process_flag(trap_exit, true),
  Servers = get_servers(),
  {ok, Servers}.

handle_call({register, Server}, _From, Servers) -> 
  NewServers = add_server(Servers, Server),
  {reply, ok, NewServers};
handle_call({unregister, Server}, _From, Servers) -> 
  NewServers = del_server(Servers, Server),
  {reply, ok, NewServers};
handle_call({get}, _From, Servers) -> 
  {reply, {ok, config, Servers}, Servers}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.

get_servers() ->
  [{0, [{"127.0.0.1", 2345}]}, {1, [{"192.168.1.109", 2346}]}, {2, [{"192.168.1.109", 2347}]}].
add_server(Servers, Server) ->
  Servers.
del_server(Servers, Server) ->
  Servers.

%%client method
register(Server) -> gen_server:call(?MODULE, {register, Server}).
get() -> gen_server:call(?MODULE, {get}).
unregister(Server) -> gen_server:call(?MODULE, {unregister, Server}).