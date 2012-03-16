package {
  import stdio.*

  [SWF(width=0, height=0)]
  public class interactive_test extends Sprite implements Interactive {
    public function main(): void {
      process.puts("What’s your name?")
      process.prompt = process.style("bold", "name> ")
      process.gets(function (name: String): void {
        if (name === null) {
          process.puts("Fine, be that way.")
        } else {
          process.puts("Hello, " + name + "!")
          process.puts("What’s your favorite color?")
          process.prompt = process.style("bold", "color> ")
          process.gets(function (color: String): void {
            process.puts(
              "Cool, I like " + process.style(
                "bold " + color.toLowerCase(), color
              ) + " too! :-)"
            )

            process.exit()
          })
        }
      })
    }
  }
}
