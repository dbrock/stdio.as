package stdio {
  public interface IProcess {
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

    // The prompt to use for interactive `gets` (default "> ").
    function set prompt(value: String): void

    // Write something followed by a newline to standard output.
    function puts(value: Object): void
    function get stdout(): OutputStream

    // Like puts, but for standard error.
    function warn(value: Object): void
    function get stderr(): OutputStream

    // Exit the process with the given status code.
    function exit(status: int = 0): void
  }
}
