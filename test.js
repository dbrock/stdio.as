var assert = require("assert")
var ChildProcess = require("child_process")
var HTTP = require("http")

// ---------------------------------------------------------

ChildProcess.exec(
  "echo 123 | bin/flashplayer-stdio test_sprite.swf foo bar",
  function (error, stdout, stderr) {
    assert.equal(stdout, "stdout:foo,bar:123\n")
    assert.equal(stderr, "stderr:foo,bar:123\n")
    assert.equal(error.code, 123)
    console.log("Sprite OK.")
  }
)

// ---------------------------------------------------------

ChildProcess.exec(
  "bin/flashplayer-stdio test_spark.swf",
  function (error, stdout, stderr) {
    assert.equal(stdout, "foo\n")
    console.log("Application OK.")
  }
)

// ---------------------------------------------------------

var FLASHPLAYER = "/Applications/Flash Player Debugger.app/Contents/MacOS/Flash Player Debugger"

function test_unplugged(swf, port, name) {
  var flashplayer = ChildProcess.spawn(
    FLASHPLAYER, [swf + "?port=" + port]
  )
  
  HTTP.createServer(function () {
    console.log(name + " OK.")
  
    flashplayer.kill()
    clearTimeout(timeout)
    this.close()
  }).listen(port)
  
  var timeout = setTimeout(function () {
    assert.fail("Error: " + name + " timed out")
  }, 5000)
}

test_unplugged(
  "test_sprite_unplugged.swf", 56788, "Unplugged Sprite"
)

test_unplugged(
  "test_spark_unplugged.swf", 56789, "Unplugged Application"
)
