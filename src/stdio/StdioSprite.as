package stdio {
  import flash.display.*
  import flash.events.*
  import flash.net.*

  public class StdioSprite extends Sprite {
    public function StdioSprite() {
      setup(loaderInfo.parameters, start)

      if (process is LocalProcess) {
        loaderInfo.uncaughtErrorEvents.addEventListener(
          UncaughtErrorEvent.UNCAUGHT_ERROR,
          LocalProcess(process).handle_uncaught_error
        )
      }
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
