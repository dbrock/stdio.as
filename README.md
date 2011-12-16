flashplayer-stdio
=================

See the [run-swf(1)][] man page for a quick overview.

This package lets you run an ActionScript 3 program as if it were a
normal Unix process.  Specifically, it provides the ability to

* access environment variables,
* accept command-line arguments,
* read from standard input,
* write to standard output,
* write to standard error,
* exit with an arbitrary status code.

It also by default mutes the standard runtime error dialogs, instead
reformatting stack traces of uncaught errors to GCC-like error message
syntax and sending them to stderr.

Implementations are available for Flex 4 apps and pure Flash apps.
The main entry points from ActionScript are `stdio.process`,
`stdio.ProcessSprite` and `stdio.ProcessSparkApplication`.

[run-swf(1)]: http://dbrock.github.com/flashplayer-stdio/run-swf.1


Example
-------

Your basic bare-metal (pure Flash) process looks like this:

    package {
      import stdio.flash.Sprite
      import stdio.process
    
      public class hello_process extends Sprite {
        override public function main(): void {
          process.puts("Hello, " + (process.argv[0] || "World") + "!")
        }
      }
    }

Here is the equivalent as a Spark application:

    <stdio:Application
        xmlns:fx="http://ns.adobe.com/mxml/2009"
        xmlns:stdio="stdio.spark.*">
      <stdio:processReady>
        import stdio.process
    
        process.puts("Hello, " + (process.argv[0] || "World") + "!")
      </stdio:processReady>
    </stdio:Application>

Remembering to include `stdio.swc`, you can simply compile these
applications as usual:

    $ fcshc stdio.swc hello_process.as
    $ fcshc stdio.swc hello_process_flex.mxml

(See http://github.com/dbrock/fcshd for information about `fcshc`.)

To run an stdio-enabled SWF, use the `run-swf` wrapper:

    $ run-swf hello_process.swf
    Hello, World!
    $ run-swf hello_process_flex.swf Galaxy
    Hello, Galaxy!

(Unfortunately, I know of no way to suppress the Flash Player window,
regardless of whether your program actually displays any graphics.)


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
      // Whether or not this is actually a local process.
      // Most stdio facilities are only available for local
      // processes, but the environment is always available.
      function get local(): Boolean
  
      // The environment of the process. This is equivalent
      // to the query string parameters of the SWF.
      function get env(): Object

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

The `run-swf` wrapper works by first setting up some servers listening
to random available TCP ports on localhost:

* one web server, for serving the SWF and accepting commands;
* three raw TCP servers, for piping stdin, stdout and stderr.

Then the wrapper starts Flash Player, passing (as special SWF
parameters) the URL of the web server, the port numbers of the TCP
servers, and the command-line arguments.  Environment variables are
passed along verbatim as normal SWF parameters.

At initialization time, the runtime library parses the special SWF
parameters and connects to the stdio sockets, and finally either
invokes your `main()` method (for Flash applications) or dispatches a
`processReady` event (for Flex applications).
