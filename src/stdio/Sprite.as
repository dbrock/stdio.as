package stdio {
  import flash.display.Sprite
  import flash.events.UncaughtErrorEvent
  import flash.utils.getQualifiedClassName

  public class Sprite extends flash.display.Sprite {
    public function Sprite() {
      if (process === null) {
        const env: Object = loaderInfo.parameters

        env["stdio.interactive"] = String(this is Interactive)

        process = new StandardProcess(env)
        process.initialize(function (): void {
          add_error_handler()
          start()
        })
      } else {
        start()
      }
    }

    private function add_error_handler(): void {
      loaderInfo.uncaughtErrorEvents.addEventListener(
        UncaughtErrorEvent.UNCAUGHT_ERROR, process.handle
      )
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
