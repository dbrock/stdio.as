package stdio {
  import flash.display.Sprite

  public class Sprite extends flash.display.Sprite {
    public function Sprite() {
      setup(loaderInfo, this is REPL, start)
    }

    private function start(): void {
      if ("main" in this && this["main"].length === 0) {
        this["main"]()
      } else {
        warn("Please write your main method like this:")
        warn("public function main(): void {}")
        process.exit(1)
      }
    }

    private function warn(message: String): void {
      process.warn("stdio.Sprite: " + message)
    }
  }
}
