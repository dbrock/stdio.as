package stdio {
  public interface InputStream {
    function read(callback: Function): void
    function read_line(callback: Function): void
    function read_sync(): String
  }
}
