package {
  import stdio.*

  public class test_sprite extends ProcessSprite {
    override public function main(): void {
      process.gets(function (line: String): void {
        const message: String = process.argv.join(",") + ":" + line

        process.puts("stdout:" + message)
        process.warn("stderr:" + message)

        process.exit(parseInt(line))
      })
    }
  }
}
