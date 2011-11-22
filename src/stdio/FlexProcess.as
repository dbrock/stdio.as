package stdio {
  import flash.events.EventDispatcher

  internal class FlexProcess extends Process {
    private var application: Object
    private var callback: Function

    public function FlexProcess(
      application: Object,
      callback: Function
    ) {
      this.application = application
      this.callback = callback

      super()
    }

    override protected function get parameters(): Object {
      return application.parameters
    }

    override protected function get url(): String {
      return application.url
    }

    override protected function get uncaughtErrorEvents(): EventDispatcher {
      return EventDispatcher(application)
    }

    override public function main(): void {
      if (callback !== null) {
        callback()
      }
    }
  }
}
