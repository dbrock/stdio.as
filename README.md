stdio.as
========

**The moving parts you have to keep track of:**

* `stdio.swc`: the library used by your ActionScript code.
* **[run-stdio-swf(1)][]**: the executable used to run your SWFs.

**The wondrous capabilities of a good old Unix process which are
henceforth available to your locally-running Flash applications:**

* Access environment variables.
* Accept command-line arguments.
* Read from standard input.
* Write to standard output.
* Write to standard error.
* Exit with an arbitrary status code.

We also kill those annoying runtime error dialogs; instead, uncaught
errors are printed to stderr in a GCC-like syntax.  This makes them
easy to read, both for programmers, and for our tools (e.g., Emacs).

Implementations are available for both Flex 4 and pure Flash.

**Please see the [run-stdio-swf(1)][] man page for more information.**

[run-stdio-swf(1)]: http://dbrock.github.com/stdio.as/run-stdio-swf.1


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
      <stdio:main>
        import stdio.process
    
        process.puts("Hello, " + (process.argv[0] || "World") + "!")
      </stdio:main>
    </stdio:Application>

Remember to include `stdio.swc` when you compile these applications.
If you're using [fcshd][], putting `stdio.swc` in your `~/.fcshd-lib`
and using the `-l` option is the most convenient:

    $ fcshc hello_process.as -l stdio
    $ fcshc hello_process_flex.mxml -l stdio

[fcshd]: http://github.com/dbrock/fcshd

To run an stdio-enabled SWF, use the `run-stdio-swf` wrapper:

    $ run-stdio-swf hello_process.swf
    Hello, World!
    $ run-stdio-swf hello_process_flex.swf Galaxy
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
