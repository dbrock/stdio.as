var assert = require("assert")

require("child_process").exec(
  "echo 123 | bin/flashplayer-stdio test.swf",
  function (error, stdout, stderr) {
    assert.equal(stdout, "stdout:123\n")
    assert.equal(stderr, "stderr:123\n")
    assert.equal(error.code, 123)
    console.log("OK.")
  }
)
