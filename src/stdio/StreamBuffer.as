package stdio {
  public class StreamBuffer implements InputStream, OutputStream {
    private const requests: Array = []

    public var buffer: String = ""
    public var closed: Boolean = false

    public function write(value: Object): void {
      buffer += value.toString()
      dispatch()
    }

    public function write_line(value: Object): void {
      write(value + "\n")
    }

    public function close(): void {
      closed = true
      dispatch()
    }

    private function dispatch(): void {
      while (has_requests && next_request.ready) {
        next_request.satisfy()
        requests.shift()
      }
    }

    private function get has_requests(): Boolean {
      return requests.length > 0
    }

    private function get next_request(): Request {
      return requests[0]
    }

    private function add_request(request: Request): void {
      requests.push(request)
      dispatch()
    }

    public function read(callback: Function): void {
      add_request(new StandardRequest(this, callback))
    }

    public function read_line(callback: Function): void {
      add_request(new LineRequest(this, callback))
    }

    public function read_sync(): String {
      try {
        return buffer
      } finally {
        buffer = ""
      }

      throw new Error
    }
  }
}

import stdio.*

class Request {
  protected var stream: StreamBuffer
  protected var callback: Function

  public function Request(stream: StreamBuffer, callback: Function) {
    this.stream = stream, this.callback = callback
  }

  public function get ready(): Boolean { throw new Error }
  public function satisfy(): void { throw new Error }
}

class StandardRequest extends Request {
  public function StandardRequest(
    stream: StreamBuffer, callback: Function
  ) { super(stream, callback) }

  override public function get ready(): Boolean {
    return stream.closed || stream.buffer.length > 0
  }

  override public function satisfy(): void {
    callback(stream.read_sync())
  }
}

class LineRequest extends Request {
  public function LineRequest(
    stream: StreamBuffer, callback: Function
  ) { super(stream, callback) }

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
    const result: String = stream.buffer.slice(0, line_end_index)

    stream.buffer = stream.buffer.slice(line_end_index)

    callback(result.replace(/\n$/, ""))
  }
}
