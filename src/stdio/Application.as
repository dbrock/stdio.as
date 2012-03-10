package stdio {
  import flash.events.Event
  import spark.components.Application

  public class Application extends spark.components.Application {
    override public function initialize(): void {
      // See `spark.components.Application.initialize()`.
      setup(systemManager.loaderInfo, this is REPL, $initialize)
    }

    private function $initialize(): void {
      super.initialize()
    }
  }
}
