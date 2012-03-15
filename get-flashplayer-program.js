module.exports = function (callback) {
  try_in_order([
    function (callback) {
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
    },
    function (callback) {
      die("no flashplayer executable found")
    }
  ], callback)

  function get_osx_app_program(name, callback) {
    get_program(
      "/Applications/" + name + ".app/Contents/MacOS/" + name,
      callback
    )
  }

  function get_program(filename, callback) {
    require("path").exists(filename, function (exists) {
      callback(exists ? filename : null)
    })
  }
}

function try_in_order(functions, callback) {
  functions = [].slice.call(functions)
  loop(function (loop) {
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
  })
}

function loop(loop) {
  loop(loop)
}
