import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bookshelf_console/models/reading_status.dart';
import 'package:bookshelf_console/models/book.dart';
import 'package:bookshelf_console/models/paper_book.dart';
import 'package:bookshelf_console/models/ebook.dart';
import 'package:bookshelf_console/models/library.dart';
import 'package:bookshelf_console/models/library_storage.dart';
import 'package:bookshelf_console/services/open_library_service.dart';

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
  final service = OpenLibraryService();

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
    print('5. Поиск в Open Library(интернет)');
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
      case '5':
        stdout.write('Введите запрос для поиска в интернете: ');
        final query = (stdin.readLineSync(encoding: utf8) ?? '').trim();

        if (query.isEmpty) {
          print('Пустой запрос.');
          break;
        }
        print('Идёт поиск, подождите...');
        final timer = Timer.periodic(const Duration(milliseconds: 500), (_) {});

        try {
          final foundBooks = await service.search(query);
          timer.cancel();

          if (foundBooks.isEmpty) {
            print('Ничего не найдено в Open Library.');
            break;
          }

          print('Найденные книги:');
          for (int i = 0; i < foundBooks.length; i++) {
            final b = foundBooks[i];
            print(
              '${i + 1}. ${foundBooks[i].shortTitle} - ${foundBooks[i].author} (${foundBooks[i].year})',
            );
            if (b.coverUrl != null) {
              print('   Обложка: ${b.coverUrl}');
            }
          }

          stdout.write(
            '\nВведите номер книги для добавления в каталог(0 - отмена): ',
          );
          final choiceStr = stdin.readLineSync(encoding: utf8) ?? '0';
          final choice = int.tryParse(choiceStr) ?? 0;

          if (choice > 0 && choice <= foundBooks.length) {
            final selectedBook = foundBooks[choice - 1];
            myLibrary.add(selectedBook);
            await storage.save(myLibrary.items.toList());

            print(
              'Книга "${selectedBook.title}" добавлена в каталог и сохранена!',
            );
          } else {
            print('Добавление отменено');
          }
        } on SocketException {
          print('Нет соединения с сетью. Работаем с локальным каталогом.');
        } on TimeoutException {
          print('Сервис не ответил за 10 секунд. Повторите попытку позже.');
        } on FormatException {
          print('Сервис вернул данные в неожидаемом формате.');
        } on HttpException catch (e) {
          print('Ошибка сервиса: ${e.message}');
        }
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
  service.dispose();
}
