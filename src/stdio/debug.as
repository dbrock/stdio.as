package stdio {
  import flash.display.*
  import flash.text.*
  import flash.utils.setTimeout

  internal class debug {
    public static var root: DisplayObjectContainer

    public static function show(text: String): void {
      if (root) {
        const field: TextField = new TextField
        const format: TextFormat = new TextFormat

        // Cause it to use the default font.
        format.font = "foo"

        field.defaultTextFormat = format
        field.autoSize = TextFieldAutoSize.LEFT

        field.text = text

        field.x = 4
        field.y = 4 + field.height * i++

        root.addChild(field)
      }
    }

    private static var i: int = 0
  }
}
