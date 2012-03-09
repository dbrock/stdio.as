package stdio {
  internal class StreamBuffer implements InputStream, OutputStream {
    public var buffer: String = ""
    public var closed: Boolean = false

    public function puts(value: Object): void {
      write(value + "\n")
    }

    public function write(value: Object): void {
      buffer += value.toString()
      satisfy_read_requests()
    }

    public function close(): void {
      closed = true
      satisfy_read_requests()
    }

    // -----------------------------------------------------

    private const requests: Array = []

    private function satisfy_read_requests(): void {
      while (has_requests && next_request.ready) {
        next_request.satisfy()
        requests.shift()
      }
    }

    private function get has_requests(): Boolean {
      return requests.length > 0
    }

    private function get next_request(): ReadRequest {
      return requests[0]
    }

    // -----------------------------------------------------

    public function gets(callback: Function): void {
      add_read_request(new ReadLineRequest(this, callback))
    }

    public function read(callback: Function): void {
      add_read_request(new ReadChunkRequest(this, callback))
    }

    private function add_read_request(request: ReadRequest): void {
      requests.push(request)
      satisfy_read_requests()
    }

    public function get emptied(): Boolean {
      return closed && !buffer.length
    }

    public function get ready(): Boolean {
      return new ReadChunkRequest(this, null).ready
    }
  }
}
