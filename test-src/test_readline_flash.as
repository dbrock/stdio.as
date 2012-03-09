package {
  import stdio.flash.Sprite
  import stdio.process

  [SWF(width=0, height=0)]
  public class test_readline_flash extends Sprite {
    override protected function get interactive(): Boolean {
      return true
    }

    public function main(): void {
      process.ask("What’s your name? ", function (name: String): void {
        process.puts("Hello, " + name + "!")
        process.ask("Favorite color? ", function (color: String): void {
          process.puts("I like " + color + " too!")
          process.exit()
        })
      })
    }
  }
}
