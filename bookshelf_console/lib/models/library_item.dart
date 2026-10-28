abstract class LibraryItem {
  String get title;
  String describe();

  void printCard() {
    print(describe());
  }
}
