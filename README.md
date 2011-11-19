flashplayer-stdio
=================

This package lets you run an ActionScript 3 program as if it were a
normal Unix process.  Specifically, it provides the ability to

* access command-line arguments,
* read from standard input,
* write to standard output,
* write to standard error,
* exit with an arbitrary status code.


Example
-------

The basic program boilerplate looks like this:

    package {
      import stdio.Process
    
      public class hello extends Process {
        override public function main(): void {
          puts("Hello, " + (argv[0] || "World") + "!")
        }
      }
    }

To run your SWF, use the `flashplayer-stdio` wrapper:

    $ flashplayer-stdio hello.swf
    Hello, World!
    $ flashplayer-stdio hello.swf Galaxy
    Hello, Galaxy!


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


Basic API
---------

The following methods are defined on processes:

    // Retreive the command-line arguments of the process.
    function get argv(): Array

    // Read one line from standard input.
    function gets(callback: Function): void

    // Write something to standard output followed by a newline.
    function puts(value: Object): void

    // Write something to standard error followed by a newline.
    function warn(value: Object): void

    // Exit the process with the given status code.
    function exit(code: int = 0): void

For convenience, `gets`, `puts`, and `warn` are also available
directly as global functions from anywhere in the program:

    package foo {
      import stdio.warn

      public function debug(message: String): void {
        warn("debug: " + message)
      }
    }

The process object itself is available globally as `Process.instance`.


Low-level API
-------------

If you need more fine-grained control than what is provided by the
regular line-based API, you may access the stream objects directly:

    // Retreive the underlying IO streams.
    function get stdin(): InputStream
    function get stdout(): OutputStream
    function get stderr(): OutputStream

    interface InputStream {
      // Wait for any amount of data to become available.
      function read(callback: Function): void

      // Wait for one line of data to become available.
      function read_line(callback: Function): void

      // Just read whatever is available right now.
      function read_sync(): String
    }

    interface OutputStream {
      function write(value: Object): void
      function write_line(value: Object): void
      function close(): void
    }


How It Works
------------

The `flashplayer-stdio` wrapper works by first setting up some servers
listening to random available TCP ports on localhost:

* one web server, for serving the SWF and accepting commands (like
  "exit the process");
* three raw TCP servers, for piping stdin, stdout and stderr through.

It then starts Flash Player, passing the port numbers as query string
parameters to the SWF.  When the SWF loads, the Process constructor
connects to all the servers, and then invokes the `main` method.
