package stdio {
  public interface Process {
    function get env(): Object
    function get argv(): Array

    function initialize(callback: Function): void
    function get available(): Boolean

    function puts(value: *): void
    function warn(value: *): void

    function gets(callback: Function): void
    function set prompt(value: String): void

    function format(pattern: String): String

    function get stdin(): InputStream
    function get stdout(): OutputStream
    function get stderr(): OutputStream

    function shell(command: *, callback: Function): void

    function exit(status: int = 0): void

    function handle(error: *): void
  }
}
