package stdio {
  import flash.display.Sprite
  import flash.events.*
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
        listen_for_uncaught_errors()
        main()
      })
    }

    public function main(): void {
      warn("override public function main(): void {}")
    }

    public function exit(status: int = 0): void {
      post("exit", status.toString())
    }

    private function get base_url(): String {
      // XXX: Not very robust.
      return loaderInfo.loaderURL.replace(/\?.*/, "") + "/"
    }

    private function post(
      path: String,
      content: String,
      callback: Function = null
    ): void {
      const request: URLRequest = new URLRequest(base_url + path)

      request.method = "POST"
      request.data = content

      const loader: URLLoader = new URLLoader

      if (callback !== null) {
        loader.addEventListener(
          Event.COMPLETE,
          function (event: Event): void {
            callback(loader.data)
          }
        )
      }

      loader.load(request)
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

    private function listen_for_uncaught_errors(): void {
      loaderInfo.uncaughtErrorEvents.addEventListener(
        UncaughtErrorEvent.UNCAUGHT_ERROR,
        handle_uncaught_error_event
      )
    }

    protected function handle_uncaught_error_event(
      event: UncaughtErrorEvent
    ): void {
      event.preventDefault()

      post(
        "error", 
        event.error is Error
          ? (event.error as Error).getStackTrace()
          : event.error,
        function (response: String): void {
          exit(1)
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
