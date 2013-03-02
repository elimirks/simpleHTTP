Welcome. This is a very simple HTTP server written in perl.
The functionality is usable, but does not support preprocessing as well as some other important features.

In case you want to use this...

1. Create a directory called 'http' which is a sibling to the server.pl file.
2. Add files -- html, images, perl files...
3. Run server.pl as root, and test out your brand new HTTP server :)

Only perl will be allowed to run with this server.
This will help the execution be super fast.

Perl processing usage:

All print statements will direct to the response.

Example:

-- index.pl --
$somevar = "value";
print "<html><head></head><body>$somevar</body></html>";
-- EOF --

TODO:

- Add HTTP header support.
- Scan the requested directory for index\.(htm?l)|(pl)
- Syntax error handling for returning perl files.

PARTIALLY DONE:

- Block the usage of '../'.
 - Hacked up some regex.. bad solution, but it works for now.

DONE:

- Multithread sockets.
 - Currently there is only one thread to send the data... This could get clogged easily.
- Add support for preprocessors.

