package stdio {
  import flash.events.Event
  import spark.components.Application

  [Event(name="main")]
  public class StdioSparkApplication extends Application {
    override public function initialize(): void {
      // See `spark.components.Application.initialize()`.
      setup(systemManager.loaderInfo, false, $initialize)
    }

    private function $initialize(): void {
      // XXX: This is redundant now.  Keep?
      addEventListener(
        "applicationComplete", function (event: Event): void {
          dispatchEvent(new Event("main"))
        }
      )

      super.initialize()
    }
  }
}
