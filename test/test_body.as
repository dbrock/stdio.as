package {
  import flash.net.*

  public function test_body(): void {
    if (process.available) {
      process.warn(process.env.foo)
      process.gets(function (line: String): void {
        process.puts(line)
        process.exit(Number(process.argv[0]))
      })
    } else {
      new URLLoader().load(new URLRequest(
        "http://localhost:" + process.env.foo
      ))
    }
  }
}
