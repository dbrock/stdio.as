package stdio {
  import flash.events.*
  import flash.net.Socket

  public class SocketStream extends Socket implements OutputStream {
    public var onopen: Function = null
    public var ondata: Function = null
    public var onclose: Function = null

    public function SocketStream() {
      addEventListener(Event.CONNECT, handle_connect)
      addEventListener(ProgressEvent.SOCKET_DATA, handle_readable)
      addEventListener(Event.CLOSE, handle_close)
      addEventListener(IOErrorEvent.IO_ERROR, handle_error)
      addEventListener(SecurityErrorEvent.SECURITY_ERROR, handle_error)
    }

    public function write(value: Object): void {
      writeUTFBytes(value.toString())
    }

    public function write_line(value: Object): void {
      write(value + "\n")
    }

    private function handle_connect(event: Event): void {
      if (onopen !== null) {
        onopen()
      }
    }

    private function handle_readable(event: ProgressEvent): void {
      if (ondata !== null) {
        ondata(readUTFBytes(bytesAvailable))
      }
    }

    private function handle_close(event: Event): void {
      if (onclose !== null) {
        onclose()
      }
    }

    private function handle_error(event: Event): void {
      throw new Error(event.toString())
    }
  }
}
