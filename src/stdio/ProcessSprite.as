package stdio {
  import flash.display.*
  import flash.events.*
  import flash.net.*

  public class ProcessSprite extends Sprite {
    public function ProcessSprite() {
      setup(loaderInfo.parameters, main)

      loaderInfo.uncaughtErrorEvents.addEventListener(
        UncaughtErrorEvent.UNCAUGHT_ERROR,
        UnixProcess(process).handle_uncaught_error_event
      )
    }

    public function main(): void {
      process.warn("override public function main(): void {}")
    }
  }
}
