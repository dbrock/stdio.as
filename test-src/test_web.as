package {
  import flash.net.URLLoader
  import flash.net.URLRequest

  function test_web(): void {
    new URLLoader().load(new URLRequest(
      "http://localhost:" + process.env.port + process.env.path
    ))
  }
}
