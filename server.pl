#!/usr/bin/perl

use threads;
use IO::Socket;

my $sock = new IO::Socket::INET (
	LocalPort => "80",
	Proto     => "tcp",
	Listen    => 1,
	Reuse     => 1,
);
die "Could not establish socket: $!\n" unless $sock;

# Main http method thread.
sub http_thread {
	$consock = @_[0];
	
	# Parse the request
	$request = <$consock>;
	$request =~ s/\w+\s([\w\.\/]*)\s.*/\1/g;
	
	# Strip out '../' -- Bad solution, it should be checking if the path is in the http directory instead... that would be good.
	$request =~ s/\.\.\///g;
	
	# Cut out the newline from the request.
	$request = substr($request, 0, length($request) - 1);
	$filepath = "http";
	
	if ($request eq "/") {
		$filepath .= "/index.html";
	} else {
		$filepath .= $request;
	}
	
	print "Requesting " . $filepath . "\n";
	
	local $/;
	open(FILE, $filepath) or print "Failed to open " . $filepath . "\n";
	$filedata = <FILE>;
	
	# The newline is to terminate the print statement -- this is needed for binary data
	print $consock $filedata . "\n";
	close($consock);
	close(FILE);
}

# Keep openning sockets for clients.
while (1) {
	threads->create('http_thread', $sock->accept());
}

# This should be moved somewhere... it will never be reached :)
close($sock);

