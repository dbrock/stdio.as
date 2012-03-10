package stdio {
  public interface OutputStream {
    function puts(value: *): void
    function write(value: *): void
    function close(): void
  }
}
