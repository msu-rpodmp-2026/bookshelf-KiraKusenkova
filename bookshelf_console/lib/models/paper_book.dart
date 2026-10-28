import 'book.dart';
import 'mixins.dart';

class PaperBook extends Book with Rateble, Loggable, Borrowable {
  final String shelf;
  PaperBook({
    required super.title,
    required super.author,
    required this.shelf,
    super.year,
    super.pages,
    super.genres,
    super.status,
    super.rating,
  });

  @override
  String describe() {
    return '"$title" - бумажная книга. Автор: $author. Полка: $shelf.';
  }
}
