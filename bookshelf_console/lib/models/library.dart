import 'library_item.dart';
import 'book.dart';

class Library<T extends LibraryItem> {
  final List<T> _items = [];

  List<T> get items => List.unmodifiable(_items);
  int get count => _items.length;
  void add(T item) {
    if (!_items.contains(item)) {
      _items.add(item);
    } else {
      print('Такая книга уже была в библиотеке!');
    }
  }

  bool remove(T item) {
    return _items.remove(item);
  }

  T? findByTitle(String title) {
    for (final item in _items) {
      if (item.title.toLowerCase() == title.toLowerCase()) {
        return item;
      }
    }
    return null;
  }

  Iterable<T> search(String query) {
    return _items.where((item) {
      if (item is Book) {
        return item.matches(query);
      }
      return item.title.toLowerCase().contains(query.toLowerCase());
    });
  }

  Iterable<T> where(bool Function(T) test) {
    return _items.where(test);
  }

  Map<String, int> countByGenre() {
    final Map<String, int> counts = {};
    for (final item in _items) {
      if (item is Book) {
        for (final genre in item.genres) {
          counts[genre] = (counts[genre] ?? 0) + 1;
        }
      }
    }
    return counts;
  }
}
