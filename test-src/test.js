var assert = require("assert")

console.log("1..4")

function test_local(swf) {
  var stdin_word = "hello"
  var env_foo = "bar"
  var argv_1 = "123"

  with_timeout(
    function (callback) {
      require("child_process").exec([
        "echo", stdin_word, "|",
        "foo=" + env_foo,
        "bin/run-swf", swf,
        argv_1
      ].join(" "), callback)
    }, function (error, stdout, stderr) {
      test(swf, function () {
        assert.equal(stdout, stdin_word + "\n")
        assert.equal(stderr, env_foo + "\n")
        assert.equal(error.code, parseInt(argv_1))
      })
    }, function () {
      test(swf, function () {
        assert.fail("timeout")
      })
    }
  )
}

function test_web(swf, port) {
  var flashplayer
  var expected_path = "/123"

  with_timeout(
    function (callback) {
      require("http").createServer(function (request, response) {
        if (request.url === "/crossdomain.xml") {
          response.writeHead(200, { "content-type": "text/xml" })
          response.end('\
<cross-domain-policy>\n\
  <site-control permitted-cross-domain-policies="master-only"/>\n\
  <allow-access-from domain="*" to-ports="*"/>\n\
</cross-domain-policy>\n\
')
         } else {
           flashplayer.kill()
           this.close()
           callback(request.url)
         }
      }).listen(port, function () {
        flashplayer = start_flashplayer(swf, {
          port: port,
          path: expected_path
        })
      })
    }, function (actual_path) {
      test(swf, function () {
        assert.equal(actual_path, expected_path)
      })
    }, function () {
      test(swf, function () {
        assert.fail("timeout")
      })
    }
  )
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
    return encodeURIComponent(name) + "=" +
      encodeURIComponent(parameters[name])
  }).join("&")
}

function with_timeout(body, callback, errback) {
  var timeout = setTimeout(function () {
    errback()
    callback = null
  }, 5000)

  body(function () {
    clearTimeout(timeout)

    if (callback) {
      callback.apply(null, arguments)
    }
  })
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
