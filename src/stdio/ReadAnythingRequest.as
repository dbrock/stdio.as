package stdio {
  internal class ReadAnythingRequest extends ReadRequest {
    public function ReadAnythingRequest(
      stream: StreamBuffer, callback: Function
    ) {super(stream, callback)}
  
    override public function get ready(): Boolean {
      return stream.closed || stream.buffer.length > 0
    }
  
    override public function satisfy(): void {
      try {
        callback(stream.buffer)
      } finally {
        stream.buffer = ""
      }
  
      throw new Error
    }
  }
}
