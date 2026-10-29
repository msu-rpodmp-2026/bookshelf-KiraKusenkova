import 'dart:convert';
import 'dart:io';
import 'package:bookshelf_console/models/reading_status.dart';
import 'package:bookshelf_console/models/book.dart';
import 'package:bookshelf_console/models/paper_book.dart';
import 'package:bookshelf_console/models/ebook.dart';
import 'package:bookshelf_console/models/audio_book.dart';
import 'package:bookshelf_console/models/library.dart';

void main() {
  final Library<Book> myLibrary = Library<Book>();

  myLibrary.add(
    PaperBook(
      title: 'Война и мир',
      author: 'Л. Толстой',
      shelf: 'A-1',
      year: 1896,
      pages: 1274,
      genres: {'Классика'},
      status: ReadingStatus.finished,
    ),
  );
  myLibrary.add(
    EBook(
      title: 'Основы Dart',
      author: 'С. Чернышев',
      format: 'PDF',
      sizeMb: 15.5,
      year: 2024,
      pages: 521,
      genres: {'Учебник', 'Программирование'},
    ),
  );
  myLibrary.add(
    AudioBook(
      title: 'Гарри Поттер',
      author: 'Дж. Роулинг',
      duration: Duration(hours: 10, minutes: 30),
      narrator: 'А. Клюквин',
      year: 1997,
      genres: {'Фантазия'},
      status: ReadingStatus.reading,
    ),
  );
  bool running = true;

  while (running) {
    print('\n');
    print('Bookshelf: каталог (ЛР №3)');
    print('1. Показать весь каталог');
    print('2. Поиск по названию/автору');
    print('3. Поиск по жанру');
    print('4. Сортировка по названию');
    print('5. Статистика по жанрам');
    print('6. Демонстрация == и hashCode');
    print('7. Демонтрация миксинов(PaperBook)');
    print('8. Добавить новую книгу');
    print('9. Удалить книгу по названию');
    print('0. Выход');
    print('\n');
    stdout.write('>  ');

    final String command = (stdin.readLineSync(encoding: utf8) ?? '').trim();

    switch (command) {
      case '1':
        print('Каталог');
        if (myLibrary.count == 0) print('Пусто');
        for (final book in myLibrary.items) {
          book.printCard();
        }
      case '2':
        stdout.write('Введите запрос: ');
        final String q = (stdin.readLineSync(encoding: utf8) ?? '').trim();
        final results = myLibrary.search(q);
        print('Результаты поиска: ');
        if (results.isEmpty) print('Ничего не найдено');
        for (final book in results) {
          book.printCard();
        }
      case '3':
        print('Доступные жанры: ${myLibrary.countByGenre().keys.join(', ')}');
        stdout.write('Введите жанры: ');
        final String g = (stdin.readLineSync(encoding: utf8) ?? '')
            .trim()
            .toLowerCase();
        final byGenre = myLibrary.where(
          (b) => b.genres.any((genre) => genre.toLowerCase() == g),
        );
        for (final book in byGenre) {
          book.printCard();
        }
      case '4':
        final sorted = List<Book>.from(myLibrary.items)..sort();
        print('Отсортированно по названию');
        for (final book in sorted) {
          print(book);
        }
      case '5':
        print('Статистика по жанрам');
        final stats = myLibrary.countByGenre();
        stats.forEach((genre, count) => print('$genre: $count'));
      case '6':
        print('Проверка == и hashCode');
        final book1 = Book(title: '1984', author: 'Дж. Оруэлл', year: 1949);
        final book2 = Book(title: '1984', author: 'Дж. Оруэлл', year: 1949);
        print('book1 == book2: ${book1 == book2}');
        final Set<Book> set = {book1, book2};
        print('Размер Set(должен быть 1): ${set.length}');
      case '7':
        print('Миксины(выдача книг)');
        final paperBooks = myLibrary.where((b) => b is PaperBook);
        if (paperBooks.isNotEmpty) {
          final pb = paperBooks.first as PaperBook;
          pb.log('Попытка выдать книгу "${pb.title}"');
          pb.borrow(14);
          pb.vote(5.0);
          pb.vote(4.0);
          print('Средний рейтинг: ${pb.averageRating}');
          pb.giveBack();
        } else {
          print('Нет бумажные книг.');
        }
        case '8':
      stdout.write('Введите название: ');
      final String newTitle = (stdin.readLineSync(encoding: utf8) ?? '').trim();
      stdout.write('Введите автора: ');
      final String newAuthor = (stdin.readLineSync(encoding: utf8) ?? '').trim();
      myLibrary.add(Book(title: newTitle, author: newAuthor));
      case '9': 
      stdout.write('Введите название для удаления: ');
      final String delTitle = (stdin.readLineSync(encoding: utf8) ?? '').trim();
      final toRemove = myLibrary.findByTitle(delTitle);
      if(toRemove != null){
        myLibrary.remove(toRemove);
        print('Книга "${toRemove.title}" удалена.');
      }
      else{
        print('Книга не найдена.');
      }
      case '0':
        running = false;
      default:
        print('Невозможная команда.');
    }
  }
  print('Работа завершина.');
}
