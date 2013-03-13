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

# TODO Load this from a config file.
my %config = (
	"HTTP_PATH"      =>"http/",
	"ERROR_REDIRECTS"=> {
		"404"=>"404.html"
	}
);

# Returns file data, or executes if the file is a perl file. Assumes that the file is readable.
sub get_filedata {
	$filepath = @_[0];
	
	# Execute the file
	if ($filepath =~ /\.pl$/) {
		# Capture all print statements from the perl file.
		my $capture; {
			open my $capture_handle, ">", \$capture or die $!;
			my $saved_handle = select $capture_handle;
			
			# Execute everything in the file -- all print statements will be captured and sent as the response.
			require $filepath;
			select $saved_handle;
		}
		return $capture . "\n";
	# Plain file type
	} else {
		local $/;
		open(FILE, $filepath) or print "Failed to open " . $filepath . "\n";
		$filedata = <FILE> and close(FILE);
		
		# The newline is to terminate files (some don't have a termination character, such as image files.)
		return $filedata . "\n";
	}
}

# Main http method thread.
sub http_thread {
	$consock = @_[0];
	$request = <$consock>;
	
	# Parse the request -- Just the path for now.
	($reqtype, $path, $paramstr, $httptype) = $request =~ /(\w+)\s([\w\.\/]+)(\s|\?[\w\=\&]+)(.*)/;
	
	# Strip out '../' -- Bad solution, it should be checking if the path is in the http directory instead... that would be good.
	$path =~ s/\.\.\///g;
	
	$filepath = $config{"HTTP_PATH"} . $path;
	
	# If a directory is requested, give back index.html in that directory.
	$path =~ /\/$/ and $filepath .= "index.html";
	
	if (-r $filepath) {
		print "Requesting: $filepath \n";
		
		# Create a hash to store the get params -- this passes on to the perl files.
		our %GET;
		$GET{$1} = $2 while $paramstr =~ /[\?\&]([^=]+)=([^&]+)/g;
		
		print $consock get_filedata($filepath);
	# Return 404
	} else {
		print $consock get_filedata($config{"HTTP_PATH"} . $config{"ERROR_REDIRECTS"}{"404"});
	}
	close($consock);
}

# Keep openning sockets for clients.
threads->create(\&http_thread, $sock->accept())->detach() while 1;

# This should be moved somewhere... it will never be reached :)
close($sock);

