package stdio {
  public interface IProcess {
    function get env(): Object
    function get argv(): Array

    function puts(value: Object): void
    function warn(value: Object): void

    function gets(callback: Function): void
    function set prompt(value: String): void

    function get stdin(): InputStream
    function get stdout(): OutputStream
    function get stderr(): OutputStream

    function exit(status: int = 0): void
  }
}
