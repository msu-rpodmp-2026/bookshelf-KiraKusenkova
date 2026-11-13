import 'book.dart';

class EBook extends Book {
  final String format;
  final double sizeMb;
  EBook({
    required super.title,
    required super.author,
    required this.format,
    required this.sizeMb,
    super.year,
    super.pages,
    super.genres,
    super.status,
    super.rating,
  });

  @override
  String describe() {
    return '"$title" - электронная книга ($format). Размер: ${sizeMb.toStringAsFixed(1)} МБ.';
  }
}
