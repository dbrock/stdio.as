package stdio {
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

    // Read one line from the terminal using readline.  To use this
    // method you must set `interactive = true` in your constructor.
    function ask(prompt: String, callback: Function): void

    // Write something followed by a newline to standard output.
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
}
