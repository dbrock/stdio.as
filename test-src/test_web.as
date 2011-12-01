package {
  import flash.net.URLLoader
  import flash.net.URLRequest

  function test_web(port: int): void {
    new URLLoader().load(
      new URLRequest("http://localhost:" + port)
    )
  }
}
