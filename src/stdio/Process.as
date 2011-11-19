package stdio {
  import flash.display.Sprite
  import flash.events.UncaughtErrorEvent
  import flash.net.*

  public class Process extends Sprite {
    public static var instance: Process = null

    private const stdin_buffer: StreamBuffer = new StreamBuffer
    private const stdin_socket: SocketStream = new SocketStream
    private const stdout_socket: SocketStream = new SocketStream
    private const stderr_socket: SocketStream = new SocketStream

    public function Process() {
      instance = this
      connect(function (): void {
        handle_uncaught_errors()
        main()
      })
    }

    public function main(): void {
      warn("override public function main(): void {}")
    }

    public function exit(status: int = 0): void {
      const request: URLRequest = new URLRequest(loaderInfo.loaderURL)

      request.method = "POST"
      request.data = status.toString()

      new URLLoader().load(request)      
    }

    public function get argv(): Array {
      return get_parameter("argv").split(" ").map(
        function (argument: String, ...rest: Array): String {
          return decodeURIComponent(argument)
        }
      )
    }

    private function get_parameter(name: String): String {
      return loaderInfo.parameters[name]
    }

    private function get_int_parameter(name: String): int {
      return parseInt(get_parameter(name))
    }

    public function gets(callback: Function): void {
      stdin.read_line(callback)
    }

    public function puts(value: Object): void {
      stdout.write_line(value)
    }

    public function warn(value: Object): void {
      stderr.write_line(value)
    }

    public function get stdin(): InputStream { return stdin_buffer }
    public function get stdout(): OutputStream { return stdout_socket }
    public function get stderr(): OutputStream { return stderr_socket }

    private function handle_uncaught_errors(): void {
      loaderInfo.uncaughtErrorEvents.addEventListener(
        UncaughtErrorEvent.UNCAUGHT_ERROR,
        function (event: UncaughtErrorEvent): void {
          warn(event.error.stack)
        }
      )
    }

    private function connect(callback: Function): void {
      stdin_socket.onopen = onopen
      stdout_socket.onopen = onopen
      stderr_socket.onopen = onopen

      stdin_socket.ondata = stdin_buffer.write
      stdin_socket.onclose = stdin_buffer.close

      stdin_socket.connect("localhost", get_int_parameter("stdin"))
      stdout_socket.connect("localhost", get_int_parameter("stdout"))
      stderr_socket.connect("localhost", get_int_parameter("stderr"))

      var n: int = 0

      function onopen(): void {
        if (++n === 3) {
          callback()
        }
      }
    }
  }
}
