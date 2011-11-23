var assert = require("assert")

require("child_process").exec(
  "echo 123 | bin/flashplayer-stdio test_sprite.swf foo bar",
  function (error, stdout, stderr) {
    assert.equal(stdout, "stdout:foo,bar:123\n")
    assert.equal(stderr, "stderr:foo,bar:123\n")
    assert.equal(error.code, 123)
    console.log("Sprite OK.")
  }
)

require("child_process").exec(
  "bin/flashplayer-stdio test_spark.swf",
  function (error, stdout, stderr) {
    assert.equal(stdout, "foo\n")
    console.log("Application OK.")
  }
)
