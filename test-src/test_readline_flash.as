package {
  import stdio.flash.Sprite
  import stdio.process

  [SWF(width=0, height=0)]
  public class test_readline_flash extends Sprite {
    override protected function get interactive(): Boolean {
      return true
    }

    public function main(): void {
      process.prompt = "What’s your name? "
      process.gets(function (name: String): void {
        process.puts("Hello, " + name + "!")
        process.prompt = "Favorite color? "
        process.gets(function (color: String): void {
          process.puts("I like " + color + " too!")
          process.exit()
        })
      })
    }
  }
}
