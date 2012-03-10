package stdio {
  public interface InputStream {
    function get ready(): Boolean
    function read(callback: Function): void
    function gets(callback: Function): void
  }
}
