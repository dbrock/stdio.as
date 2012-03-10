package stdio {
  import flash.events.*
  import flash.net.Socket

  internal class SocketStream extends Socket implements OutputStream {
    public var onopen: Function = noop
    public var ondata: Function = noop
    public var onclose: Function = noop

    public function SocketStream() {
      addEventListener(Event.CONNECT, function (event: *): * { onopen() })
      addEventListener(Event.CLOSE, function (event: *): * { onclose() })

      addEventListener(ProgressEvent.SOCKET_DATA, function (event: *): * {
        ondata(readUTFBytes(bytesAvailable))
      })

      addEventListener(IOErrorEvent.IO_ERROR, handle_error)
      addEventListener(SecurityErrorEvent.SECURITY_ERROR, handle_error)
    }

    private function handle_error(event: ErrorEvent): void {
      throw new Error(event.text)
    }

    public function puts(value: *): void {
      write(value + "\n")
    }

    public function write(value: *): void {
      writeUTFBytes(value)
    }
  }
}

function noop(...rest: Array): void {}
