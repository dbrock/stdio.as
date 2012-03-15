package {
  import stdio.Sprite

  [SWF(width=100, height=100)]
  public class flash_test extends Sprite {
    public function flash_test(): void {
      graphics.beginFill(0xff0000)
      graphics.drawRect(10, 10, 80, 80)
      graphics.endFill()
    }

    public function main(): void {
      graphics.beginFill(0x0000ff)
      graphics.drawRect(30, 30, 40, 40)
      graphics.endFill()

      test_body()
    }
  }
}
