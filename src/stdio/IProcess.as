package stdio {
  public interface IProcess {
    // Whether or not we are running as a Unix process.
    // If not, most other methods will throw exeptions.
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
}
