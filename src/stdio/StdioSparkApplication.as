package stdio {
  import flash.events.*

  import spark.components.Application

  [Event(name="main")]
  public class StdioSparkApplication extends Application {
    override public function initialize(): void {
      // See `spark.components.Application.initialize()`.
      setup(systemManager.loaderInfo.parameters, $initialize)
    }

    private function $initialize(): void {
      if (process is LocalProcess) {
        systemManager.loaderInfo.uncaughtErrorEvents.addEventListener(
          UncaughtErrorEvent.UNCAUGHT_ERROR,
          LocalProcess(process).handle_uncaught_error
        )
      }

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
