package {
  import stdio.Sprite

  [SWF(width=0, height=0)]
  public class test extends Sprite {
    public function main(): void {
      if (process.available) {
        process.warn(process.env.foo)
        process.gets(function (line: String): void {
          process.puts(line)
          process.exit(Number(process.argv[0]))
        })
      } else {
        import flash.net.*
        new URLLoader().load(new URLRequest(
          "http://localhost:" + process.env.port
        ))
      }
    }
  }
}
