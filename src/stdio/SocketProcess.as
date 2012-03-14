package stdio {
  import flash.display.*
  import flash.events.*
  import flash.utils.*
  import flash.net.*

  internal class SocketProcess implements Process {
    private const buffered_stdin: BufferedStream = new BufferedStream
    private const stdin_socket: SocketStream = new SocketStream
    private const readline_socket: SocketStream = new SocketStream

    private const stdout_socket: SocketStream = new SocketStream
    private const stderr_socket: SocketStream = new SocketStream

    private var _env: Object
    private var _prompt: String = "> "

    public function SocketProcess(env: Object) {
      _env = env
    }

    public function initialize(callback: Function): void {
      if (available) {
        connect(callback)
      } else {
        callback()
      }
    }

    public function get available(): Boolean {
      return !!service_url
    }

    private function get service_url(): String {
      return env["stdio.service"]
    }

    private function connect(callback: Function): void {
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

      stdin_socket.ondata = buffered_stdin.write
      stdin_socket.onclose = buffered_stdin.close
      readline_socket.ondata = buffered_stdin.write
      readline_socket.onclose = buffered_stdin.close

      const stdin_port: int = get_int("stdio.in")
      const readline_port: int = get_int("stdio.readline")

      if (interactive) {
        readline_socket.connect("localhost", readline_port)
      } else {
        stdin_socket.connect("localhost", stdin_port)
      }

      const stdout_port: int = get_int("stdio.out")
      const stderr_port: int = get_int("stdio.err")

      stdout_socket.connect("localhost", stdout_port)
      stderr_socket.connect("localhost", stderr_port)

      function get_int(name: String): int {
        return parseInt(env[name])
      }
    }

    private function get interactive(): Boolean {
      return env["stdio.interactive"] === "true"
    }

    //----------------------------------------------------------------

    public function get env(): Object {
      return _env
    }

    public function get argv(): Array {
      return env["stdio.argv"].split(" ").map(
        function (argument: String, ...rest: Array): String {
          return decodeURIComponent(argument)
        }
      )
    }

    public function puts(value: *): void {
      if (available) {
        if (interactive) {
          readline_socket.puts("!" + value)
        } else {
          stdout.puts(value)
        }
      }
    }

    public function warn(value: *): void {
      if (available) {
        stderr.puts(value)
      }
    }

    public function style(styles: String, string: String): String {
      const codes: Object = {
        none: 0, bold: 1, italic: 3, underline: 4, inverse: 7,
        black: 30, red: 31, green: 32, yellow: 33, blue: 34,
        magenta: 35, cyan: 36, white: 37, gray: 90, grey: 90
      }

      if (styles === "") {
        return string
      } else {
        return styles.split(/\s+/).map(
          function (style: String, ...rest: Array): String {
            if (style in codes) {
              return escape_sequence(codes[style])
            } else {
              throw new Error("style not supported: " + style)
            }
          }
        ).join("") + string + escape_sequence(0)
      }

      function escape_sequence(code: int): String {
        return "\x1b[" + code + "m"
      }
    }

    public function gets(callback: Function): void {
      if (available) {
        if (interactive) {
          readline_socket.puts("?" + _prompt)
        }

        stdin.gets(callback)
      } else {
        callback(null)
      }
    }

    public function set prompt(value: String): void {
      _prompt = value
    }

    public function get stdin(): InputStream {
      return buffered_stdin
    }

    public function get stdout(): OutputStream {
      return stdout_socket
    }

    public function get stderr(): OutputStream {
      return stderr_socket
    }

    public function handle(error: *): void {
      if (error is UncaughtErrorEvent) {
        UncaughtErrorEvent(error).preventDefault()
        handle(UncaughtErrorEvent(error).error)
      } else if (error is Error) {
        // Important: Avoid the `Error(x)` casting syntax.
        http_post("/error", (error as Error).getStackTrace())
      } else if (error is ErrorEvent) {
        http_post("/async-error", (error as ErrorEvent).toString())
      } else {
        http_post("/error", String(error))
      }
    }

    private function shell_quote(word: String): String {
      if (/^[-=.,\w]+$/.test(word)) {
        return word
      } else {
        return "'" + word.replace(/'/g, "'\\''") + "'"
      }
    }

    public function shell(
      command: *,
      callback: Function,
      errback: Function = null
    ): void {
      if (available) {
        if (command is Array) {
          command = command.map(
            function (word: String, ...rest: Array): String {
              return shell_quote(word)
            }
          ).join(" ")
        }

        http_post("/shell", command, function (data: String): void {
          const result: XML = new XML(data)
          const status: int = result.@status
          const stdout: String = result.stdout.text()
          const stderr: String = result.stderr.text()

          if (status === 0) {
            if (callback.length === 1) {
              callback(stdout)
            } else {
              callback(stdout, stderr)
            }
          } else if (errback === null) {
            warn(stderr)
          } else if (errback.length === 1) {
            errback(status)
          } else if (errback.length === 2) {
            errback(status, stderr)
          } else {
            errback(status, stderr, stdout)
          }
        })
      } else {
        throw new Error("cannot execute command: process not available")
      }
    }

    public function exit(status: int = 0): void {
      if (available) {
        when_ready(function (): void {
          http_post("/exit", String(status))
        })
      } else {
        throw new Error("cannot exit: process not available")
      }
    }

    //----------------------------------------------------------------

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

    private function http_post(
      path: String, content: String, callback: Function = null
    ): void {
      const request: URLRequest = new URLRequest(service_url + path)

      request.method = "POST"
      request.data = content

      const loader: URLLoader = new URLLoader

      ++n_pending_requests

      loader.addEventListener(
        Event.COMPLETE,
        function (event: Event): void {
          if (callback !== null) {
            callback(loader.data)
          }

          if (--n_pending_requests === 0) {
            handle_ready()
          }
        }
      )

      loader.load(request)
    }
  }
}
