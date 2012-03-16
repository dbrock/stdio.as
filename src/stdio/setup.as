package stdio {
  import flash.display.DisplayObjectContainer
  import flash.display.LoaderInfo
  import flash.events.UncaughtErrorEvent

  function setup(
    loaderInfo: LoaderInfo,
    root: DisplayObjectContainer,
    callback: Function
  ): void {
    if (process) {
      callback()
    } else {
      for (var name: String in loaderInfo.parameters) {
        ENV[name] = loaderInfo.parameters[name]
      }

      if (ENV.DEBUG_STDIO) {
        debug.root = root
      }

      process = new StandardProcess(ENV)
      process.initialize(function (): void {
        if (process.available) {
          loaderInfo.uncaughtErrorEvents.addEventListener(
            UncaughtErrorEvent.UNCAUGHT_ERROR, process.handle
          )
        }

        callback()
      })
    }
  }
}
