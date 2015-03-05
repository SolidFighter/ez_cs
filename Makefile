all:
	test -d deps || rebar get-deps
	rebar compile

clean:
	rebar clean	
