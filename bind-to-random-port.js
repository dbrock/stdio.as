module.exports = function (server, callback) {
  var port

  server.addListener("error", error_handler)
  try_random_port()

  function try_random_port() {
    port = get_random_port()

    server.listen(port, function () {
      server.removeListener("error", error_handler)
      callback(port)
    })

    function get_random_port() {
      // Standard IANA dynamic port range.
      return get_random_integer(0xc000, 0x10000)

      function get_random_integer(min, max) {
        return min + Math.floor(Math.random() * (max - min))
      }
    }
  }

  function error_handler(error) {
    if (error.code == "EADDRINUSE") {
      try_random_port()
    } else {
      throw error
    }
  }
}
