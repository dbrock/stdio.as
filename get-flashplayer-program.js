var inspect = require("util").inspect
var path = require("path")

module.exports = function (callback) {
  try_in_order([
    function (callback) {
      if (process.env.RUN_SWF_VERBOSE) {
        console.warn("run-swf: looking for $FLASHPLAYER...")
      }

      if (process.env.FLASHPLAYER) {
        get_program(process.env.FLASHPLAYER, callback)
      } else {
        callback(null)
      }
    },
    function (callback) {
      get_osx_app_program("Flash Player Debugger", callback)
    },
    function (callback) {
      get_osx_app_program("Flash Player", callback)
    }
  ], callback)

  function get_osx_app_program(name, callback) {
    get_program(
      "/Applicationsa/" + name + ".app/Contents/MacOS/" + name,
      callback
    )
  }

  function get_program(filename, callback) {
    if (process.env.RUN_SWF_VERBOSE) {
      console.warn("run-swf: looking for %s...", inspect(filename))
    }

    path.exists(filename, function (exists) {
      callback(exists ? filename : null)
    })
  }
}

function try_in_order(functions, callback) {
  functions = [].slice.call(functions)
  ;(function loop () {
    if (functions.length === 0) {
      callback(null)
    } else {
      functions.shift()(function (program) {
        if (program) {
          callback(program)
        } else {
          loop()
        }
      })
    }
  })()
}
