package stdio {
  internal class NullProcess implements IProcess {
    public function get stdio(): Boolean {
      return false
    }

    public function get whiny(): Boolean {
      return false
    }

    public function get immortal(): Boolean {
      return true
    }
  
    public function get argv(): Array {throw new Error}
    public function gets(callback: Function): void {throw new Error}
    public function get stdin(): InputStream {throw new Error}
    public function puts(value: Object): void {throw new Error}
    public function get stdout(): OutputStream {throw new Error}
    public function warn(value: Object): void {throw new Error}
    public function get stderr(): OutputStream {throw new Error}
    public function exit(status: int = 0): void {throw new Error}
    public function set whiny(value: Boolean): void {throw new Error}
    public function set immortal(value: Boolean): void {throw new Error}
  }
}
