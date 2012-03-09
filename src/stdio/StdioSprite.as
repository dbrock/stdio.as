package stdio {
  import flash.display.Sprite

  public class StdioSprite extends Sprite {
    public function StdioSprite() {
      setup(loaderInfo, interactive, start)
    }

    protected function get interactive(): Boolean {
      return false
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
      process.warn("stdio.flash.Sprite: " + message)
    }
  }
}
