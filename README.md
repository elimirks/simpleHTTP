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

FUNFAX:

I just found out that this server is insusceptible to slowloris attacks :)
This is because the only HTTP header that the server cares about is the first (URL, GET params, etc)
It will terminate after getting this header, so slowloris does not cause DOS.

TODO:

- Add HTTP header support.
 - It should return a few headers such as file type, size, etc.
- Parse form POST variables.
- Allow large streams from perl files.
 - Assume we have a perl file that will act as an image loader.

PARTIALLY DONE:

- Block the usage of '../'.
 - Hacked up some regex.. bad solution, but it works for now.
- Scan the requested directory for index\.(htm?l)|(pl)
 - There is a default directory file for now. It might stay this way.

DONE:

- Syntax error handling for returning perl files.
- Multithread sockets.
 - Currently there is only one thread to send the data... This could get clogged easily.
- Add support for preprocessors.
- Parse GET variables.
- Allow sending large files, such as executables.
 - Stream the output instead of loading it all at once.

