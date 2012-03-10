package stdio {
  import flash.display.Sprite
  import flash.events.UncaughtErrorEvent

  public class Sprite extends flash.display.Sprite {
    public function Sprite() {
      const env: Object = loaderInfo.parameters

      env["stdio.interactive"] = String(this is REPL)

      process = new ProcessImpl(env)
      ProcessImpl(process).initialize(start)
    }

    private function start(): void {
      loaderInfo.uncaughtErrorEvents.addEventListener(
        UncaughtErrorEvent.UNCAUGHT_ERROR,
        ProcessImpl(process).handle_uncaught_error
      )

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
