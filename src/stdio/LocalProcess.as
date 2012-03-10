package stdio {
  import flash.display.*
  import flash.events.*
  import flash.utils.*
  import flash.net.*

  internal class LocalProcess implements IProcess {
    private var parameters: Object
    private var interactive: Boolean

    private var _prompt: String = "> "

    public function LocalProcess(parameters: Object, interactive: Boolean) {
      this.parameters = parameters
      this.interactive = interactive
    }

    internal function get available(): Boolean {
      return !!service_url
    }

    private function get service_url(): String {
      return parameters["stdio.service"]
    }

    // -----------------------------------------------------

    internal function connect(callback: Function): void {
      stdin_socket.onopen = onopen
      readline_socket.onopen = onopen
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
      readline_socket.ondata = stdin_buffer.write
      readline_socket.onclose = stdin_buffer.close

      const in_port: int = get_int("stdio.in")
      const readline_port: int = get_int("stdio.readline")

      if (interactive) {
        readline_socket.connect("localhost", readline_port)
      } else {
        stdin_socket.connect("localhost", in_port)
      }

      const out_port: int = get_int("stdio.out")
      const err_port: int = get_int("stdio.err")

      stdout_socket.connect("localhost", out_port)
      stderr_socket.connect("localhost", err_port)

      function get_int(name: String): int {
        return parseInt(parameters[name])
      }
    }

    private const stdin_buffer: StreamBuffer = new StreamBuffer
    private const stdin_socket: SocketStream = new SocketStream
    private const readline_socket: SocketStream = new SocketStream

    private const stdout_socket: SocketStream = new SocketStream
    private const stderr_socket: SocketStream = new SocketStream

    // -----------------------------------------------------

    public function get env(): Object {
      return parameters
    }

    public function get argv(): Array {
      return parameters["stdio.argv"].split(" ").map(
        function (argument: String, ...rest: Array): String {
          return decodeURIComponent(argument)
        }
      )
    }

    // -----------------------------------------------------

    public function puts(value: Object): void {
      if (interactive) {
        readline_socket.puts("!" + String(value))
      } else {
        stdout.puts(value)
      }
    }

    public function warn(value: Object): void {
      stderr.puts(value)
    }

    // -----------------------------------------------------

    public function gets(callback: Function): void {
      if (interactive) {
        readline_socket.puts("?" + _prompt)
      }

      stdin.gets(callback)
    }

    public function set prompt(value: String): void {
      _prompt = value
    }

    // -----------------------------------------------------

    public function get stdin(): InputStream {
      return stdin_buffer
    }

    public function get stdout(): OutputStream {
      return stdout_socket
    }

    public function get stderr(): OutputStream {
      return stderr_socket
    }

    // -----------------------------------------------------

    public function exit(status: int = 0): void {
      when_ready(function (): void {
        http_post("/exit", status.toString())
      })
    }

    // -----------------------------------------------------

    private var n_pending_requests: int = 0
    private var ready_callbacks: Array = []

    private function when_ready(callback: Function): void {
      if (n_pending_requests === 0) {
        callback()
      } else {
        ready_callbacks.push(callback)
      }
    }

    private function handle_ready(): void {
      for each (var callback: Function in ready_callbacks) {
        callback()
      }

      ready_callbacks = []
    }

    internal function handle_uncaught_error(error: *): void {
      if (error is UncaughtErrorEvent) {
        UncaughtErrorEvent(error).preventDefault()
        handle_uncaught_error(UncaughtErrorEvent(error).error)
      } else if (error is Error) {
        // Important: Avoid the `Error(x)` casting syntax.
        http_post("/error", (error as Error).getStackTrace())
      } else if (error is ErrorEvent) {
        http_post("/async-error", (error as ErrorEvent).toString())
      } else {
        // XXX: Anybody care about this case?
      }
    }

    private function http_post(path: String, content: String): void {
      const request: URLRequest = new URLRequest(service_url + path)

      request.method = "POST"
      request.data = content

      const loader: URLLoader = new URLLoader

      ++n_pending_requests

      loader.addEventListener(
        Event.COMPLETE,
        function (event: Event): void {
          if (--n_pending_requests === 0) {
            handle_ready()
          }
        }
      )

      loader.load(request)
    }
  }
}
