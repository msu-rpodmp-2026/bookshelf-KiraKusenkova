import 'dart:io';

void main() {
  stdout.write('Название: ');
  final String title = stdin.readLineSync() ?? '';
  if (title.isEmpty) {
    print('Ошибка: название не должно быть пустым.');
    return;
  }

  stdout.write('Автор: ');
  final String author = stdin.readLineSync() ?? 'неизвестен';

  stdout.write('Год издания: ');
  final int year = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

  stdout.write('Количество страниц: ');
  final int pages = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

  stdout.write('Оценка (0..5): ');
  final double rating = double.tryParse(stdin.readLineSync() ?? '') ?? 0.0;

  stdout.write('Прочитана (да/нет): ');
  final String readInput = (stdin.readLineSync() ?? '').toLowerCase();
  final bool isRead = readInput == 'да\n';

  print(' «$title»');
  print(' Автор: $author');
  print(' Год: $year');
  print(' Страниц: $pages');
  print(' Оценка: ${rating.toStringAsFixed(1)}');
  print(' Прочитана: ${isRead ? "да" : "нет"}');
}