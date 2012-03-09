package stdio {
  import flash.display.LoaderInfo
  import flash.events.UncaughtErrorEvent

  internal function setup(
    loaderInfo: LoaderInfo, interactive: Boolean, callback: Function
  ): void {
    const local_process: LocalProcess
      = new LocalProcess(loaderInfo.parameters, interactive)

    if (local_process.available) {
      process = local_process
      local_process.connect(callback)
      loaderInfo.uncaughtErrorEvents.addEventListener(
        UncaughtErrorEvent.UNCAUGHT_ERROR,
        local_process.handle_uncaught_error
      )
    } else {
      process = new WebProcess(loaderInfo.parameters)
      callback()
    }
  }
}
