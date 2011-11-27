package {
  import stdio.process

  function test_local(): void {
    process.gets(function (line: String): void {
      process.puts(line)
      process.warn(line.toUpperCase())
      process.exit(parseInt(process.argv[0]))
    })
  }
}
