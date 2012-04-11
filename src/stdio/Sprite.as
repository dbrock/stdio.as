package stdio {
  import flash.display.*
  import flash.utils.getQualifiedClassName
  import flash.utils.setTimeout

  public class Sprite extends flash.display.Sprite {
    public function Sprite() {
      if (stage) {
        stage.scaleMode = StageScaleMode.NO_SCALE
        stage.align = StageAlign.TOP_LEFT

        // Let the subclass constructor run first.
        setTimeout(initialize, 0)
      }
    }

    private function initialize(): void {
      setup(loaderInfo, this, start)
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
      process.warn(getQualifiedClassName(this) + ": " + message)
    }
  }
}
