package stdio {
  import flash.utils.setTimeout

  internal class NullProcess implements IProcess {
    public function get stdio(): Boolean {return false}
    public function get env(): Object {return {}}
    public function get argv(): Array {return []}
    public function gets(callback: Function): void {throw new Error}
    public function get stdin(): InputStream {return null}
    public function puts(value: Object): void {}
    public function get stdout(): OutputStream {return null}
    public function warn(value: Object): void {}
    public function get stderr(): OutputStream {return null}
    public function exit(status: int = 0): void {}
    public function get whiny(): Boolean {return false}
    public function set whiny(value: Boolean): void {throw new Error}
    public function get immortal(): Boolean {return true}
    public function set immortal(value: Boolean): void {throw new Error}
  }
}
