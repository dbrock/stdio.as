package {
  import stdio.*

  [SWF(width=0, height=0)]
  public class test_readline_flash extends Sprite implements Interactive {
    public function main(): void {
      process.prompt = "What’s your name? "
      process.gets(function (name: String): void {
        process.puts("Hello, " + name + "!")
        process.prompt = "What’s your favorite color? "
        process.gets(function (color: String): void {
          process.puts(
            "I like " + process.format(
              "%{bold}%{" + color.toLowerCase() + "}" + color + "%{none}"
            ) + " too!"
          )
          process.exit()
        })
      })
    }
  }
}
