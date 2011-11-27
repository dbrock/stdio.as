package {
  import stdio.ProcessSprite

  public class test_web_flash extends ProcessSprite {
    override public function main(): void {
      test_web(parseInt(loaderInfo.parameters.port))
    }
  }
}
