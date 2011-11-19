package stdio {
  public interface OutputStream {
    function write(value: Object): void
    function write_line(value: Object): void
    function close(): void
  }
}
