package {
  import stdio.flash.Sprite

  public class test_web_flash extends Sprite {
    override public function main(): void {
      test_web(parseInt(loaderInfo.parameters.port))
    }
  }
}
