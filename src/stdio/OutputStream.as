package stdio {
  public interface OutputStream {
    function puts(value: Object): void
    function write(value: Object): void
    function close(): void
  }
}
