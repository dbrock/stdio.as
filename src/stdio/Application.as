package stdio {
  import flash.events.Event
  import spark.components.Application

  [Event(name="main")]
  public class Application extends spark.components.Application {
    public function Application() {
      addEventListener(
        "applicationComplete", function (event: Event): void {
          dispatchEvent(new Event("main"))
        }
      )
    }

    override public function initialize(): void {
      // See `spark.components.Application.initialize()`.
      setup(systemManager.loaderInfo, this is REPL, $initialize)
    }

    private function $initialize(): void {
      super.initialize()
    }
  }
}
