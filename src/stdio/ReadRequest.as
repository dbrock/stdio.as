package stdio {
  internal class ReadRequest {
    protected var stream: StreamBuffer
    protected var callback: Function
  
    public function ReadRequest(
      stream: StreamBuffer, callback: Function
    ) {this.stream = stream, this.callback = callback}
  
    public function get ready(): Boolean {throw new Error}
    public function satisfy(): void {throw new Error}
  }
}
