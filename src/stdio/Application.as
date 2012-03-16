package stdio {
  import flash.events.Event
  import flash.events.UncaughtErrorEvent
  import spark.components.Application

  [Event(name="main")]
  public class Application extends spark.components.Application {
    override public function initialize(): void {
      setup(systemManager.loaderInfo, this, $initialize)
    }

    private function $initialize(): void {
      addEventListener(
        "applicationComplete", function (event: Event): void {
          dispatchEvent(new Event("main"))
        }
      )

      super.initialize()
    }
  }
}
