package {
  import flash.net.*

  public function test_body(): void {
    if (process.available) {
      process.warn(process.env.foo)
      process.gets(function (line: String): void {
        process.puts(line)
        process.exit(Number(process.argv[0]))
      })
    } else if (/\d+/.test(process.env.foo)) {
      const url: String = "http://localhost:" + process.env.foo

      new URLLoader().load(new URLRequest(url))
    } else {
      process.warn("foo parameter missing or invalid")
    }
  }
}
