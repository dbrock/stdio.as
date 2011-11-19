package {
  import stdio.Process

  public class test extends Process {
    override public function main(): void {
      gets(function (line: String): void {
        puts("stdout:" + line)
        warn("stderr:" + line)
        exit(parseInt(line))
      })
    }
  }
}
