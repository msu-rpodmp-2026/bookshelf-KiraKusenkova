import 'dart:convert';
import 'dart:io';
import 'package:bookshelf_console/models/reading_status.dart';
import 'package:bookshelf_console/models/book.dart';
import 'package:bookshelf_console/models/paper_book.dart';
import 'package:bookshelf_console/models/ebook.dart';
import 'package:bookshelf_console/models/library.dart';
import 'package:bookshelf_console/models/library_storage.dart';

class LibraryFormatException implements Exception {
  final String message;
  final int line;
  LibraryFormatException(this.message, this.line);

  @override
  String toString() => 'Ошибка в строке $line: $message';
}

void main() async {
  const storage = LibraryStorage('data');
  final Library<Book> myLibrary = Library<Book>();

  print('Загрузка каталога...');

  try {
    final loadedBooks = await storage.load();
    if (loadedBooks.isEmpty) {
      print('Файл не найден или пуст. Создаем тестовые данные.');
      myLibrary.add(
        PaperBook(
          title: 'Война и мир',
          author: 'Л. Толстой',
          shelf: 'A-1',
          year: 1869,
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
          genres: {'Учебник'},
        ),
      );
      await storage.save(myLibrary.items.toList());
    } else {
      for (var b in loadedBooks) {
        myLibrary.add(b);
      }
      print('Успешно загружено книг: ${myLibrary.count}');
    }
  } catch (e) {
    print('Ошибка при загрузке: $e');
  }

  bool running = true;

  while (running) {
    print('\nBookshelf:каталог(ЛР №4)');
    print('1. Показать весь каталог');
    print('2. Поиск по названию/автору');
    print('3. Статистика по жанрам');
    print('4. Сделать резервную копию(backup)');
    print('0. Выход');
    stdout.write('>  ');

    final String command = (stdin.readLineSync(encoding: utf8) ?? '').trim();

    switch (command) {
      case '1':
        for (final book in myLibrary.items) {
          book.printCard();
        }
      case '2':
        stdout.write('Введите запрос: ');
        final q = (stdin.readLineSync(encoding: utf8) ?? '').trim();
        final results = myLibrary.search(q);
        if (results.isEmpty) print('Ничего не найдено');
        for (final book in results) {
          book.printCard();
        }
      case '3':
        final stats = myLibrary.countByGenre();
        stats.forEach((genre, count) => print('$genre: $count'));
      case '4':
        final success = await storage.backup();
        print(success ? 'Резервная копия создана!' : 'Нечего копировать.');
      case '0':
        running = false;
      default:
        print('Неизвестная команда.');
    }
    if (running) {
      await storage.save(myLibrary.items.toList());
    }
  }
  print('Работа завершена. Сохранено книг: ${myLibrary.count}');
}
