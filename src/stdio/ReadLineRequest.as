package stdio {
  internal class ReadLineRequest extends ReadRequest {
    public function ReadLineRequest(
      stream: StreamBuffer, callback: Function
    ) {super(stream, callback)}

    override public function get ready(): Boolean {
      return stream.closed || has_newline
    }

    private function get newline_index(): int {
      return stream.buffer.indexOf("\n")
    }

    private function get has_newline(): Boolean {
      return newline_index !== -1
    }

    private function get line_end_index(): int {
      return has_newline ? newline_index + 1 : stream.buffer.length
    }

    override public function satisfy(): void {
      const result: String = stream.emptied
        ? null
        : stream.buffer.slice(0, line_end_index).replace(/\n$/, "")

      stream.buffer = stream.buffer.slice(line_end_index)

      callback(result)
    }
  }
}
