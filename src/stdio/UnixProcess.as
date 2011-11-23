package stdio {
  import flash.display.*
  import flash.events.*
  import flash.net.*

  internal class UnixProcess implements IProcess {
    private var parameters: Object

    public function UnixProcess(parameters: Object) {
      this.parameters = parameters
    }

    public function get stdio(): Boolean {
      return parameters.stdio_url
    }

    // -----------------------------------------------------

    internal function connect(callback: Function): void {
      stdin_socket.onopen = onopen
      stdout_socket.onopen = onopen
      stderr_socket.onopen = onopen

      var n: int = 0

      function onopen(): void {
        if (++n === 3) {
          callback()
        }
      }

      stdin_socket.ondata = stdin_buffer.write
      stdin_socket.onclose = stdin_buffer.close

      stdin_socket.connect("localhost", get_int("stdin_port"))
      stdout_socket.connect("localhost", get_int("stdout_port"))
      stderr_socket.connect("localhost", get_int("stderr_port"))

      function get_int(name: String): int {
        return parseInt(parameters[name])
      }
    }

    private const stdin_buffer: StreamBuffer = new StreamBuffer
    private const stdin_socket: SocketStream = new SocketStream

    private const stdout_socket: SocketStream = new SocketStream
    private const stderr_socket: SocketStream = new SocketStream

    // -----------------------------------------------------

    public function get argv(): Array {
      return parameters.argv.split(" ").map(
        function (argument: String, ...rest: Array): String {
          return decodeURIComponent(argument)
        }
      )
    }

    // -----------------------------------------------------

    public function gets(callback: Function): void {
      stdin.gets(callback)
    }

    public function get stdin(): InputStream {
      return stdin_buffer
    }

    // -----------------------------------------------------

    public function puts(value: Object): void {
      stdout.puts(value)
    }

    public function get stdout(): OutputStream {
      return stdout_socket
    }

    // -----------------------------------------------------

    public function warn(value: Object): void {
      stderr.puts(value)
    }

    public function get stderr(): OutputStream {
      return stderr_socket
    }

    // -----------------------------------------------------

    public function exit(status: int = 0): void {
      http_post("/exit", status.toString())
    }

    // See below for http_post().

    // -----------------------------------------------------

    private var _whiny: Boolean = true

    public function get whiny(): Boolean {return _whiny}
    public function set whiny(value: Boolean): void {_whiny = value}

    // -----------------------------------------------------

    private var _immortal: Boolean = true

    public function get immortal(): Boolean {return _immortal}
    public function set immortal(value: Boolean): void {_immortal = value}

    // -----------------------------------------------------

    internal function handle_uncaught_error_event(
      event: UncaughtErrorEvent
    ): void {
      event.preventDefault()

      if (whiny) {
        log_error(event.error, callback)
      } else {
        callback()
      }

      function callback(): void {
        if (!immortal) {
          exit(1)
        }
      }
    }

    private function log_error(error: Object, callback: Function): void {
      const message: String = error is Error
        // Important: avoid the "Error(event.error)" syntax.
        ? (error as Error).getStackTrace()
        : "" + error

      http_post("/error", message, callback)
    }

    private function http_post(
      path: String,
      content: String,
      callback: Function = null
    ): void {
      const request: URLRequest = new URLRequest(get_url(path))

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

    private function get_url(path: String): String {
      return parameters.stdio_url + path
    }
  }
}
