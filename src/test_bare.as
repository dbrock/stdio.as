package {
  import stdio.Process

  public class test_bare extends Process {
    override public function main(): void {
      gets(function (line: String): void {
        const message: String = argv.join(",") + ":" + line

        puts("stdout:" + message)
        warn("stderr:" + message)

        exit(parseInt(line))
      })
    }
  }
}
