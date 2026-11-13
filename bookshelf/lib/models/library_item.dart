import 'package:flutter/widgets.dart';

abstract class LibraryItem {
  String get title;
  String describe();

  void printCard() {
    debugPrint(describe());
  }
}
