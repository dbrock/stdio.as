package stdio {
  internal function setup(parameters: Object, callback: Function): void {
    const unix_process: UnixProcess = new UnixProcess(parameters)

    if (unix_process.stdio) {
      process = unix_process
      unix_process.connect(callback)
    } else {
      process = new NullProcess
      callback()
    }
  }
}
