import 'dart:async';
import 'package:bookshelf_console/models/book.dart';

class LibraryEvents {
  final _controller = StreamController<String>.broadcast();
  Stream<String> get stream => _controller.stream;

  void notify(String message) => _controller.add(message);
  void dispose() => _controller.close();
}

Stream<Book> bookStream(List<Book> books) async* {
  for (final book in books) {
    await Future.delayed(const Duration(milliseconds: 300));
    yield book;
  }
}

void main() async {
  print('Задание 3: Потоки stream.');

  final books = [
    Book(title: 'Книга 1', author: 'Автор 1', genres: {'Фантастика'}),
    Book(title: 'Книга 2', author: 'Автор 2', genres: {'Детектив'}),
    Book(title: 'Книга 3', author: 'Автор 3', genres: {'Фантастика'}),
    Book(title: 'Книга 4', author: 'Автор 4', genres: {'Роман'}),
  ];

  print('Способ 1: await for');
  await for (final book in bookStream(books)) {
    print('Получена книга: ${book.title}');
  }

  print('Способ 2: listen + where/map/take(Только фантастика)');
  final subscription = bookStream(books)
      .where((b) => b.genres.contains('Фантастика'))
      .map((b) => b.title)
      .take(2)
      .listen(
        (title) => print('Найдена фантастика: $title'),
        onError: (e) => print('Ошибка: $e'),
        onDone: () => print('Поток завершен.'),
      );

  await Future.delayed(const Duration(seconds: 2));
  await subscription.cancel();

  print('Способ 3: LibraryEvents');
  final events = LibraryEvents();
  final sub = events.stream.listen((msg) => print('Событие: $msg'));

  events.notify('Добавлена книга "Новая книга"');
  events.notify('Удалена книга "Старая книга"');

  await Future.delayed(const Duration(milliseconds: 100));

  sub.cancel();
  events.dispose();

  print('\nВсе потоки закрыты.');
}
