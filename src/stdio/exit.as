package stdio {
  public function exit(status: int = 0): void {
    Process.instance.exit(status)
  }
}
