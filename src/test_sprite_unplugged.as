package {
  import stdio.ProcessSprite

  import flash.net.URLLoader
  import flash.net.URLRequest

  public class test_sprite_unplugged extends ProcessSprite {
    override public function main(): void {
      new URLLoader().load(
        new URLRequest("http://localhost:" + loaderInfo.parameters.port)
      )
    }
  }
}
