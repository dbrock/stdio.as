flashplayer-stdio
=================

This package lets you run an ActionScript 3 program as if it were a
normal Unix process.  Specifically, it provides the ability to

* access command-line arguments,
* read from standard input,
* write to standard output,
* write to standard error,
* exit with an arbitrary status code.

It also by default mutes the standard runtime error dialogs, instead
reformatting stack traces of uncaught errors to GCC-like error message
syntax and sending them to stderr.  By flipping a switch, you can make
your process kill itself when an uncaught error occurs.

Implementations are available for Flex 4 apps and pure Flash apps.


Example
-------

Your basic bare-metal (pure Flash) process looks like this:

    package {
      import stdio.ProcessSprite
      import stdio.process
    
      public class hello_process extends ProcessSprite {
        override public function main(): void {
          process.puts("Hello, " + (process.argv[0] || "World") + "!")
        }
      }
    }

Here is the equivalent as a Spark application:

    <stdio:ProcessSparkApplication
        xmlns:fx="http://ns.adobe.com/mxml/2009"
        xmlns:stdio="stdio.*"
        processReady="main()">
      <fx:Script>
        import stdio.process
    
        private function main(): void {
          process.puts("Hello, " + (process.argv[0] || "World") + "!")
        }
      </fx:Script>
    </stdio:ProcessSparkApplication>

Remembering to first add `flashplayer-stdio/src` to the source path,
you can simply compile these applications as usual:

    $ fcshc hello_process.as ../flashplayer-stdio/src
    $ fcshc hello_process_flex.mxml ../flashplayer-stdio/src

(See http://github.com/dbrock/fcshd for more information.)

To run an stdio-enabled SWF, use the `flashplayer-stdio` wrapper:

    $ flashplayer-stdio hello_process.swf
    Hello, World!
    $ flashplayer-stdio hello_process_flex.swf Galaxy
    Hello, Galaxy!

Unfortunately, I know of no way to suppress the Flash Player window,
regardless of whether your program actually displays any graphics.


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


Process API
-----------

The global variable `stdio.process` contains an object implementing
the following interface:

    public interface IProcess {
      // Whether or not stdio facilities are available.
      function get stdio(): Boolean
  
      // The command-line arguments to the process (not
      // including the name of the SWF).
      function get argv(): Array
  
      // Read one line from standard input and pass it to
      // the callback (after chopping off the newline).
      function gets(callback: Function): void
      function get stdin(): InputStream
  
      // Write something + newline to standard output.
      function puts(value: Object): void
      function get stdout(): OutputStream
  
      // Like puts, but for standard error.
      function warn(value: Object): void
      function get stderr(): OutputStream
  
      // Exit the process with the given status code.
      function exit(status: int = 0): void
  
      // Whether uncaught errors are dumped to stderr.
      function get whiny(): Boolean
      function set whiny(value: Boolean): void
  
      // Whether an uncaught error kills the process.
      function get immortal(): Boolean
      function set immortal(value: Boolean): void
    }



Low-level Stream API
--------------------

If you need more fine-grained control than what is provided by the
regular line-based API, you can access the stream objects directly:

    public interface InputStream {
      // Whether any data is available.
      function get ready(): Boolean
  
      // Wait for data to become available.
      function read(callback: Function): void
  
      // Wait for one line of data to become available.
      function gets(callback: Function): void
    }

    public interface OutputStream {
      function puts(value: Object): void
      function write(value: Object): void
      function close(): void
    }


How It Works
------------

The `flashplayer-stdio` wrapper works by first setting up some servers
listening to random available TCP ports on localhost:

* one web server, for serving the SWF and accepting commands;
* three raw TCP servers, for piping stdin, stdout and stderr.

It then starts Flash Player, passing the URL and port numbers as query
parameters to the SWF.  At initialization time, the runtime library
parses the parameters and connects to the sockets, and finally either
invokes your `main()` method (for Flash applications) or dispatches a
`processReady` event (for Flex applications).
