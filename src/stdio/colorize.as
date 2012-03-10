package stdio {
  public function colorize(string: String): String {
    return string.replace(
      /%(?:%|\{([a-z]+)\})/g,
      function (match: String, name: String, ...rest: Array): String {
        if (match === "%%") {
          return "%"
        } else if (name in codes) {
          return "\x1b[" + codes[name] + "m"
        } else {
          throw new Error("color code not supported: " + match)
        }
      }
    )
  }
}

const codes: Object = {
  none: 0, bold: 1, italic: 3, underline: 4, inverse: 7,
  black: 30, red: 31, green: 32, yellow: 33, blue: 34,
  magenta: 35, cyan: 36, white: 37, gray: 90, grey: 90
}
