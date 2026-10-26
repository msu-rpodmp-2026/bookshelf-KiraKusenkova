import 'dart:io';
import 'dart:convert';

void main() {
  //Задание 1. Приветствие
  print('1 задание.');
  print('Проект: BookShelf');
  print('Версия Dart: ${Platform.version}');
  print('ОС: ${Platform.operatingSystem}');

  //Задание 2. Ввод данных 
  print('2 задание.');
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

  stdout.write('Оценка 0..5: ');
  final double parsedRating =
      double.tryParse(stdin.readLineSync() ?? '') ?? 0.0;
  final double rating = parsedRating < 0
      ? 0.0
      : (parsedRating > 5 ? 5.0 : parsedRating);

  stdout.write('Прочитана (да/нет): ');
  final String answer = (stdin.readLineSync(encoding: utf8) ?? '')
      .trim()
      .toLowerCase();
  final bool isRead =
      answer == 'да' || answer == 'yes' || answer == 'y' || answer == '1';
  //  Задание 2.1. Карточка 
  print('');
  print(' «$title»');
  print(' Автор: $author');
  print(' Год: $year');
  print(' Страниц: $pages');
  print(' Оценка: ${rating.toStringAsFixed(1)}');
  print(' Прочитана: ${isRead ? "да" : "нет"}');
  print('--' * 44);

  // Задание 3. Характеристики
  print('3 задание.');
  final String category = pages < 150
      ? 'брошюра'
      : (pages < 400 ? 'книга' : 'том');
  final double hours = pages / 50;
  final int age = DateTime.now().year - year;
  final List<String> words = author.split(' ');
  final String initials = words
      .where((String w) => w.isNotEmpty)
      .map((String w) => '${w[0].toUpperCase()}.')
      .join(' ');

  print('Категория: $category');
  print('Время чтения: ${hours.toStringAsFixed(1)} ч');
  print('Возраст издания: $age лет');
  print('Инициалы автора: $initials');

  // Задание 4. Коллекции
  // List
  print('4 задание.');
  final List<String> shelf = <String>[
    'Война и мир',
    'Преступление и наказание',
    'Мастер и Маргарита',
    'Тихий Дон',
    'Анна Каренина',
  ];
  print('\n--- List ---');
  print('Полка: $shelf');
  print('Длина: ${shelf.length}');
  print('Первая: ${shelf.first}');
  print('Последняя: ${shelf.last}');
  shelf.insert(0, 'Евгений Онегин');
  shelf.add('Отцы и дети');
  shelf.remove('Тихий Дон');
  print('После изменений: $shelf');

  // Set
  stdout.write('\nВведите жанры через запятую: ');
  final String genresInput = stdin.readLineSync() ?? '';
  final Set<String> genres = <String>{};
  for (final String g in genresInput.split(',')) {
    final String trimmed = g.trim();
    if (trimmed.isNotEmpty) {
      genres.add(trimmed);
    }
  }
  print('Жанры (без дубликатов): $genres');

  // Map
  final Map<String, int> pagesByBook = <String, int>{
    'Война и мир': 1274,
    'Преступление и наказание': 671,
    'Мастер и Маргарита': 480,
    'Тихий Дон': 1600,
    'Анна Каренина': 864,
  };
  print('\n--- Map ---');
  pagesByBook.forEach((String k, int v) => print('$k — $v стр.'));

  String maxBook = '';
  int maxPages = 0;
  int total = 0;
  pagesByBook.forEach((String k, int v) {
    total += v;
    if (v > maxPages) {
      maxPages = v;
      maxBook = k;
    }
  });
  print('Самая толстая: $maxBook ($maxPages стр.)');
  print('Суммарно: $total');
  print('Среднее: ${(total / pagesByBook.length).toStringAsFixed(1)}');

  // Список all
  final List<String> all = <String>[
    'жанр: $category',
    ...shelf,
    if (isRead) 'статус: прочитана' else 'статус: в планах',
    for (int i = 1; i <= 3; i++) 'том #$i',
  ];
  print('\nall = $all');

  //  Задание 5. Операторы
  print('\n5 задание');
  print('7 / 2  = ${7 / 2}');
  print('7 ~/ 2 = ${7 ~/ 2}');
  print('7 % 2  = ${7 % 2}');

  // Ленивое вычисление && и || — значения из ввода
  print('\nПроверка ленивого && и ||:');
  stdout.write('Введите true или false: ');
  final String input = (stdin.readLineSync(encoding: utf8) ?? '')
      .trim()
      .toLowerCase();
  final bool flag = input == 'true';

  bool sideEffect() {
    print('  sideEffect вызван');
    return true;
  }

  print('flag && sideEffect() = ${flag && sideEffect()}');
  print('!flag || sideEffect() = ${!flag || sideEffect()}');

  // ?. ?? ??= — с реальными значениями из ввода
  print('\nПроверка ?., ??, ??=');
  stdout.write('Введите строку (Enter — пустая, будет null): ');
  final String? maybeNull = (stdin.readLineSync(encoding: utf8) ?? '').isEmpty
      ? null
      : 'непустая строка';

  print('maybeNull?.length = ${maybeNull?.length}');
  print('maybeNull ?? "дефолт" = ${maybeNull ?? "дефолт"}');

  String? value = maybeNull;
  value ??= 'заполнено';
  print('после ??= : $value');

  // final vs const
  final List<int> finalList = <int>[1, 2, 3];
  finalList.add(4);
  print('\nfinalList = $finalList');
  const List<int> constList = <int>[1, 2, 3];
  print('constList = $constList');

  // Каскадный оператор ..
  final StringBuffer buffer = StringBuffer()
    ..write('Book')
    ..write('Shelf')
    ..write('!');
  print('buffer = $buffer');
}
