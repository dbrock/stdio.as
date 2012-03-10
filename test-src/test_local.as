package {
  // echo x | foo=y run-swf test_local_flash.swf 123; echo $?
  internal function test_local(): void {
    process.warn(process.env.foo)
    process.gets(function (line: String): void {
      process.puts(line)
      process.exit(parseInt(process.argv[0]))
    })
  }
}
