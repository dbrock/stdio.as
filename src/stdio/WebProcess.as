package stdio {
  internal class WebProcess implements IProcess {
    private var parameters: Object

    public function WebProcess(parameters: Object) {
      this.parameters = parameters
    }

    public function get local(): Boolean {return false}
    public function get env(): Object {return parameters}
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
