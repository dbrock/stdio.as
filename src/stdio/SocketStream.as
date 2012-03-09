package stdio {
  import flash.events.*
  import flash.net.Socket

  internal class SocketStream extends Socket implements OutputStream {
    public var onopen: Function = noop
    public var ondata: Function = noop
    public var onclose: Function = noop

    public function SocketStream() {
      addEventListener(Event.CONNECT, function (event: Event): void {
        onopen()
      })

      addEventListener(
        ProgressEvent.SOCKET_DATA,
        function (event: ProgressEvent): void {
          ondata(readUTFBytes(bytesAvailable))
        }
      )

      addEventListener(Event.CLOSE, function (event: Event): void {
        onclose()
      })

      addEventListener(IOErrorEvent.IO_ERROR, handle_error)
      addEventListener(SecurityErrorEvent.SECURITY_ERROR, handle_error)
    }

    private function handle_error(event: ErrorEvent): void {
      throw new Error(event.text)
    }

    public function puts(value: Object): void {
      write(value + "\n")
    }

    public function write(value: Object): void {
      writeUTFBytes(value.toString())
    }

    // close() already implemented by Socket.
  }
}
