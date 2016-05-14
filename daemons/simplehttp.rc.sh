#!/bin/sh

# Plop this fellow in /etc/rc.d/ to access simpleHTTP as a daemon
# Tested on FreeBSD

. /etc/rc.subr

name="simpleHTTP"
#rcvar=simplehttp_enable

start_cmd="${name}_start"
stop_cmd="${name}_stop"

SIMPLEHTTP_DIR="/var/http/simpleHTTP"
PATH="$PATH:/usr/local/bin"

simpleHTTP_start() {
	if [ -f /var/run/simpleHTTP.pid ]
	then
		echo "It appears simpleHTTP is already running!"
		echo "If it _really_ isn't running, delete /var/run/simpleHTTP.pid"
	else
		echo -n "Summoning simpleHTTP"
		cd $SIMPLEHTTP_DIR
		$SIMPLEHTTP_DIR/server.pl &
		echo $! > /var/run/simpleHTTP.pid
		echo "."
	fi
}

simpleHTTP_stop() {
	if [ -f /var/run/simpleHTTP.pid ]
	then
		echo -n "Killing simpleHTTP..."
		kill `cat /var/run/simpleHTTP.pid`
		rm /var/run/simpleHTTP.pid
		echo " poor thing never stood a chance!"
	else
		echo "The HTTP server isn't running, you goof!"
	fi
}

