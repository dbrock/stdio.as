package stdio {
  import flash.events.*

  import spark.components.Application

  [Event(name="processReady")]
  public class StdioSparkApplication extends Application {
    override public function initialize(): void {
      super.initialize()

      setup(parameters, function (): void {
        dispatchEvent(new Event("processReady"))
      })

      if (process is LocalProcess) {
        addEventListener(
          UncaughtErrorEvent.UNCAUGHT_ERROR,
          LocalProcess(process).handle_uncaught_error_event
        )
      }
    }
  }
}
