import 'reading_status.dart';
import 'library_item.dart';
import 'interfaces.dart';
class Book extends LibraryItem
    implements Searcheable, Exportable, Comparable<Book> {
  @override
  final String title;
  final String author;
  final int year;
  final int pages;
  final Set<String> genres;
  final ReadingStatus status;

  double? _rating;
  Book({
    required this.title,
    required this.author,
    this.year = 2024,
    this.pages = 100,
    Set<String>? genres,
    this.status = ReadingStatus.planned,
    double? rating,
  }) : genres = genres ?? <String>{},
       _rating = rating {
    if (rating != null && (rating < 0 || rating > 5)) {
      throw ArgumentError('Оценка должна быть от 0 до 5');
    }
  }
  String get shortTitle =>
      title.length > 25 ? '${title.substring(0, 22)}...' : title;
  double get readingHours => pages / 50.0;
  int get age => DateTime.now().year - year;
  bool get isRated => _rating != null;
  double? get rating => _rating;

  set rating(double? value) {
    if (value != null && (value < 0 || value > 5)) {
      throw ArgumentError('Оценка должна быть от 0 до 5');
    }
    _rating = value;
  }

  @override
  bool matches(String query) {
    final q = query.toLowerCase();
    final inGenres = genres.any((g) => g.toLowerCase().contains(q));
    return title.toLowerCase().contains(q) ||
        author.toLowerCase().contains(q) ||
        inGenres;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'Book',
      'title': title,
      'author': author,
      'year': year,
      'pages': pages,
      'genres': genres,
      'status': status.name,
      'rating': _rating,
    };
  }

  @override
  String toString() => '"$shortTitle" - $author ($year), $pages стр.';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book &&
        other.title == title &&
        other.author == author &&
        other.year == year;
  }

  @override
  int get hashCode => Object.hash(title, author, year);

  @override
  int compareTo(Book other) => title.compareTo(other.title);

  Book copyWith({
    String? title,
    String? author,
    int? year,
    int? pages,
    Set<String>? genres,
    ReadingStatus? status,
    double? rating,
  }) {
    return Book(
      title: title ?? this.title,
      author: author ?? this.author,
      year: year ?? this.year,
      pages: pages ?? this.pages,
      genres: genres ?? this.genres,
      status: status ?? this.status,
      rating: rating ?? _rating,
    );
  }

  @override
  String describe() {
    return '"$title" - $author ($year). Статус: ${status.label}';
  }
}
