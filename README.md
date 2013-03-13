Welcome. This is a very simple HTTP server written in perl.
The functionality is usable, but does not support preprocessing as well as some other important features.

In case you want to use this...

1. Create a directory called 'http' which is a sibling to the server.pl file.
2. Add files -- html, images, perl files...
3. Run server.pl as root, and test out your brand new HTTP server :)

Initially I was thinking about only letting perl be run with the server, but I thought of a new model of the server to allow modularity and ability to easily add new language support.

Perl processing usage:

All print statements will direct to the response.

In the perl file, you could access the %GET hash for GET params.



TODO:

- Add HTTP header support.
- Scan the requested directory for index\.(htm?l)|(pl)
- Syntax error handling for returning perl files.
- Parse form POST variables.

PARTIALLY DONE:

- Block the usage of '../'.
 - Hacked up some regex.. bad solution, but it works for now.

DONE:

- Multithread sockets.
 - Currently there is only one thread to send the data... This could get clogged easily.
- Add support for preprocessors.
- Parse GET variables.

