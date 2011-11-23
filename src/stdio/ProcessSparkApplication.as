package stdio {
  import flash.events.*

  import spark.components.Application

  [Event(name="processReady")]
  public class ProcessSparkApplication extends Application {
    override public function initialize(): void {
      super.initialize()

      setup(parameters, function (): void {
        dispatchEvent(new Event("processReady"))
      })

      if (process is UnixProcess) {
        addEventListener(
          UncaughtErrorEvent.UNCAUGHT_ERROR,
          UnixProcess(process).handle_uncaught_error_event
        )
      }
    }
  }
}
