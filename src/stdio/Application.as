package stdio {
  import flash.events.Event
  import flash.events.UncaughtErrorEvent
  import spark.components.Application

  [Event(name="main")]
  public class Application extends spark.components.Application {
    override public function initialize(): void {
      if (process === null) {
        const env: Object = systemManager.loaderInfo.parameters

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
      systemManager.loaderInfo.uncaughtErrorEvents.addEventListener(
        UncaughtErrorEvent.UNCAUGHT_ERROR, process.handle
      )
    }

    private function start(): void {
      addEventListener(
        "applicationComplete", function (event: Event): void {
          dispatchEvent(new Event("main"))
        }
      )

      super.initialize()
    }
  }
}
