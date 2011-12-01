var assert = require("assert")

console.log("1..4")

function test_local(swf) {
  var stdin_line = "hello"
  var exit_code = 123

  var timeout = setTimeout(function () {
    test(swf, function () {
      assert.fail("timeout")
    })
  }, 5000)

  require("child_process").exec([
    "echo", stdin_line, "|",
    "bin/flashplayer-stdio", swf, exit_code
  ].join(" "), function (error, stdout, stderr) {
    clearTimeout(timeout)
    test(swf, function () {
      assert.equal(stdout, stdin_line + "\n")
      assert.equal(stderr, stdin_line.toUpperCase() + "\n")
      assert.equal(error.code, exit_code)
    })
  })
}

function test_web(swf, port) {
  var flashplayer, timeout

  require("http").createServer(function () {
    test_passed(swf)
    flashplayer.kill()
    clearTimeout(timeout)
    this.close()
  }).listen(port, function () {
    flashplayer = start_flashplayer(swf, { port: port })    
    timeout = setTimeout(function () {
      test(swf, function () {
        assert.fail("timeout")
      })
    }, 5000)
  })
}

function start_flashplayer(swf, parameters) {
  var executable = "/Applications/Flash Player Debugger.app/" +
    "Contents/MacOS/Flash Player Debugger"

  return require("child_process").spawn(executable, [
    swf + "?" + stringify_query_parameters(parameters || {})
  ])
}

function stringify_query_parameters(parameters) {
  return Object.keys(parameters || {}).map(function (name) {
    return name + "=" + parameters[name]
  }).join("&")
}

//----------------------------------------------------------

function test(name, callback) {
  try {
    callback()
    test_passed(name)
  } catch (error) {
    test_failed(name)
    throw error
  }
}

function test_passed(name) {
  console.log("ok - " + name)
}

function test_failed(name) {
  console.log("not ok - " + name)
}

//----------------------------------------------------------

test_web("test_web_flash.swf", 56788)
test_web("test_web_flex.swf", 56789)

test_local("test_local_flash.swf")
test_local("test_local_flex.swf")
