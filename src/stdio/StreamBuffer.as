package stdio {
  internal class StreamBuffer implements InputStream, OutputStream {
    public var buffer: String = ""
    public var closed: Boolean = false

    public function get ready(): Boolean {
      return ready_for({ gets: false })
    }

    public function read(callback: Function): void {
      push({ callback: callback, gets: false })
    }

    public function gets(callback: Function): void {
      push({ callback: callback, gets: true })
    }

    public function puts(value: Object): void {
      write(value + "\n")
    }

    public function write(value: Object): void {
      buffer += String(value); feed()
    }

    public function close(): void {
      closed = true; feed()
    }

    //----------------------------------------------------------------

    private const requests: Array = []

    private function push(request: Object): void {
      requests.push(request); feed()
    }

    private function feed(): void {
      while (requests.length > 0 && ready_for(requests[0])) {
        satisfy(requests.shift())
      }
    }

    private function ready_for(request: Object): Boolean {
      return closed || (
        request.gets ? buffer.indexOf("\n") !== -1 : buffer !== ""
      )
    }

    private function satisfy(request: Object): void {
      if (closed && buffer.length === 0) {
        (request.callback)(null)
      } else if (request.gets) {
        satisfy_gets(request.callback)
      } else {
        satisfy_read(request.callback)
      }
    }

    private function satisfy_gets(callback: Function): void {
      const next: int = buffer.indexOf("\n") === -1
        ? buffer.length : buffer.indexOf("\n") + 1
      const line: String = buffer.slice(0, next)

      buffer = buffer.slice(next)

      callback(line.replace(/\n$/, ""))
    }

    private function satisfy_read(callback: Function): void {
      const result: String = buffer

      buffer = ""

      callback(result)
    }
  }
}
