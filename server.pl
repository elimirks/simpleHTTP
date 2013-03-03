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

# TODO for the different types of preprocessing, have a bunch of stubs in external files that could be loaded depending on the config!

my %config = (
	"HTTP_PATH"=>"http"
);

# Main http method thread.
sub http_thread {
	$consock = @_[0];
	
	# Parse the request -- Just the path for now.
	$request = <$consock>;
	$request =~ s/\w+\s([\w\.\/]*)\s.*/\1/;
	
	# Strip out '../' -- Bad solution, it should be checking if the path is in the http directory instead... that would be good.
	$request =~ s/\.\.\///g;

	# Cut out the newline in the request. # In the future, this should be done in the regex.
	$request = substr($request, 0, -1);
	
	$filepath = $config{"HTTP_PATH"} . $request;
	
	# If a directory is requested, give back index.html in that directory.
	$request =~ /\/$/ and $filepath .= "index.html";
	
	print "Requesting " . $filepath . "\n";
	
	# Execute perl files and output the result.
	if ($filepath =~ /\.pl$/) {
		# Only try to execute the file if it could be opened.
		if (open(FILE, $filepath) and close(FILE)) {
			# Capture all print statements.
			my $capture; {
				open my $capture_handle, ">", \$capture or die $!;
				my $saved_handle = select $capture_handle;
				# Execute everything in the file -- all print statements will be captured and sent as the response.
				require $filepath;
				select $saved_handle;
			}
			print $consock $capture . "\n";
		# else # return a 404
		}
	# If it is not a perl file, just return the file data.
	} else {
		local $/;
		open(FILE, $filepath) or print "Failed to open " . $filepath . "\n";
		$filedata = <FILE>;
		
		# The newline is to terminate files (some don't have a termination character, such as image files.)
		print $consock $filedata . "\n";
		close(FILE);
	}
	close($consock);
}

# Keep openning sockets for clients.
while (1) {
	threads->create(\&http_thread, $sock->accept())->detach();
}

# This should be moved somewhere... it will never be reached :)
close($sock);

