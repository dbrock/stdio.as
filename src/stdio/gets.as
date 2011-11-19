package stdio {
  public function gets(callback: Function): void {
    Process.instance.gets(callback)
  }
}
