all: coffee server

coffee:
	coffee -wc *.coffee */*.coffee &

server:
	node server.js &

.PHONY: all coffee server

