Welcome. This is a very simple HTTP server written in perl... it is barely usable right now, but I will update it soon...

In case you want to use this...

1. Create a directory called 'http' which is a sibling to the server.pl file.
2. Add text files to the http directory (no header support at the moment, so no binaries).
3. Run server.pl as root, and test out your brand new HTTP server :)



TODO:

- Add HTTP header support.
- Add support for preprocessors.
- Add configuration file support (base http directory, preprocessor matching..)
- Multithread sockets.
 - Currently there is only one thread to send the data... This could get clogged easily.

