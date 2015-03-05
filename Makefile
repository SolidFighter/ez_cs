all:
	test -d deps || rebar get-deps
	rebar compile
	erl -pa "./ebin"
clean:
	rebar clean	
