#!/usr/bin/perl

use strict;
use threads;
use IO::Socket;

my $sock = new IO::Socket::INET(
	LocalPort => "80",
	Proto     => "tcp",
	Listen    => 1,
	Reuse     => 1,
) or die "Could not establish socket: $!\n";

my %config = (
	"HTTP_PATH"      =>"http/",
	"ERROR_REDIRECTS"=>{
		"404"=>"404.html"
	},
	"DEFAULT_DIR_FILE"=>"index.html"
);

# Returns file data, or executes if the file is a perl file. Assumes that the file is readable.
sub stream_filedata {
	my ($filepath, $consock) = @_;
	
	# Execute the file
	if ($filepath =~ /\.pl$/) {
		# Capture all print statements from the perl file.
		my $capture; {
			open my $capture_handle, ">", \$capture or die $!;
			my $saved_handle = select $capture_handle;
			
			# Execute the file. Error messages will be sent instead, if applicable.
			do $filepath or print "Fatal error:\n$@\n";
			select $saved_handle;
		}
		print $consock $capture . "\n" and return;
	# Plain file type
	} else {
		open(FILE, $filepath) or die "Failed to open $filepath\n";
		print $consock $_ while <FILE>; # Stream output
		close(FILE);
		# The newline is to terminate files (some don't have a termination character, such as image files.)
		print $consock "\n" and return;
	}
}

# Main http method thread.
sub http_thread {
	my $consock = $_[0];
	my $request = <$consock> or die "Could not read headers from: " . $consock->peerhost;
	
	# Parse the request -- Just the path for now.
	my ($reqtype, $path, $paramstr, $httptype) = $request =~ /(\w+)\s([\w\.\/]+)(\s|\?[\w\=\&]+)(.*)/;
	
	# Strip out '../' -- Bad solution, it should be checking if the path is in the http directory instead...
	$path =~ s/\.\.\///g;
	
	my $filepath = $config{"HTTP_PATH"} . $path;
	
	# If a directory is requested, give back default directory index for that directory.
	$path =~ /\/$/ and $filepath .= $config{"DEFAULT_DIR_FILE"};
	
	print "Requesting: $filepath\n";
		
	if (-r $filepath) {
		# Create a hash to store the get params -- this passes on to the perl files.
		our %GET;
		$GET{$1} = $2 while $paramstr =~ /[\?\&]([^=]+)=([^&]+)/g;
		
		# Get information.
		stream_filedata($filepath, $consock);
	# Return 404
	} else {
		stream_filedata($config{"HTTP_PATH"} . $config{"ERROR_REDIRECTS"}{"404"}, $consock);
	}
	close($consock);
}

# Keep openning sockets for clients.
threads->create(\&http_thread, $sock->accept())->detach() while 1;

# This should be moved somewhere... it will never be reached :)
close($sock);

