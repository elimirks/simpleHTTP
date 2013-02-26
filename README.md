Welcome. This is a very simple HTTP server written in perl... it is barely usable right now, but I will update it soon...

In case you want to use this...

1. Create a directory called 'http' which is a sibling to the server.pl file.
2. Add files (images work now!), html, etc... no preprocessing yet.
3. Run server.pl as root, and test out your brand new HTTP server :)

TODO:

- Add HTTP header support.
- Add support for preprocessors.
- Add configuration file support (base http directory, preprocessor matching..)

PARTIALLY DONE:

- Block the usage of '../'.
 - Hacked up some regex.. bad solution, but it works for now.

DONE:

- Multithread sockets.
 - Currently there is only one thread to send the data... This could get clogged easily.

