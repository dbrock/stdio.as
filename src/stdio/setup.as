package stdio {
  internal function setup(parameters: Object, callback: Function): void {
    const local_process: LocalProcess = new LocalProcess(parameters)

    if (local_process.available) {
      process = local_process
      local_process.connect(callback)
    } else {
      process = new WebProcess(parameters)
      callback()
    }
  }
}
