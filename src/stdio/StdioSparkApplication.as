package stdio {
  import flash.events.*

  import spark.components.Application

  [Event(name="main")]
  public class StdioSparkApplication extends Application {
    override public function initialize(): void {
      super.initialize()

      var application_complete: Boolean = false
      var stdio_setup_done: Boolean = false

      addEventListener("applicationComplete", function (event: Event): void {
        application_complete = true
        maybe_start()
      })

      setup(parameters, function (): void {
        stdio_setup_done = true
        maybe_start()
      })

      function maybe_start(): void {
        if (application_complete && stdio_setup_done) {
          dispatchEvent(new Event("main"))
        }
      }

      if (process is LocalProcess) {
        addEventListener(
          UncaughtErrorEvent.UNCAUGHT_ERROR,
          LocalProcess(process).handle_uncaught_error_event
        )
      }
    }
  }
}
