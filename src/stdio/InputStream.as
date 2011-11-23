package stdio {
  public interface InputStream {
    // Whether any data is available.
    function get ready(): Boolean

    // Wait for data to become available.
    function read(callback: Function): void

    // Wait for one line of data to become available.
    function gets(callback: Function): void
  }
}
