package {
  import flash.net.URLLoader
  import flash.net.URLRequest

  function test_web(port: int): void {
    // Very simple test: we just let the test runner know we're alive
    // by making a request to whatever port it asked for.
    new URLLoader().load(
      new URLRequest("http://localhost:" + port)
    )
  }
}
