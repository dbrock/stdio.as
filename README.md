stdio.as
========

This is an ActionScript 3 library and a command-line utility that
provides traditional Unix process I/O facilities to Flash programs:

* Read from the standard input stream (stdin).
* Write to the standard output/error streams (stdout/stderr).
* Look at environment variables.
* Prompt the tty interactively using readline.
* Accept command-line arguments.
* Exit with an arbitrary status code.

We also kill those annoying runtime error dialogs; instead, uncaught
errors are printed to stderr in a GCC-like syntax.  This makes them
easy to read, both for programmers, and for our tools (e.g., Emacs).

Implementations are available for both Flex 4 and pure Flash.

**Please see the [run-swf(1)][] man page for more information.**

[run-swf(1)]: http://dbrock.github.com/stdio.as/run-swf.1


Installation
------------

To use this package, you need two things:

* Node.js,
* a standalone Flash Player.

If you are on OS X, you can install Node.js using Homebrew:

    $ brew install node

The Flex SDK comes equipped with a standalone Flash Player, located in
the `runtimes/player` directory.  If you are on OS X, simply unzip the
application and move it to `/Applications`.
