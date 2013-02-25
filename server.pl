#!/usr/bin/perl

use IO::Socket;
my $sock = new IO::Socket::INET (
	LocalHost => "208.68.36.163",
	LocalPort => "80",
	Proto => "tcp",
	Listen => 1,
	Reuse => 1,
);
die "Could not establish socket: $!\n" unless $sock;

my $consock;

print "Welcome to the server.\n";

while (1) {
	$consock = $sock->accept();
	
	# Parse the request
	$request = <$consock>;
	$request =~ s/\w+\s([\w\.\/]*)\s.*/\1/g;
	
	# Cut out the newline from the request.
	$request = substr($request, 0, length($request) - 1);
	$filepath = "http";
	
	if ($request eq "/") {
		$filepath .= "/index.html";
	} else {
		$filepath .= $request;
	}
	
	print "Requesting " . $filepath . "\n";
	
	# TODO get this to work with binary data>
	# TODO this needs to send response headers!
	
	local $/;
	open(FILE, $filepath) or print "Failed to open " . $filepath;
	$filedata = <FILE>;
	
	print $consock <FILE>;
	close($consock);
	close(FILE);
}

close($sock);

