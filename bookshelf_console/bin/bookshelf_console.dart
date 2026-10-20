import 'dart:async';
import 'dart:convert';
import 'dart:io';

//1 Задание. Структура данных

typedef Book = Map<String, Object?>;
typedef BookPredicate = bool Function(Book book);

final List<Book> library = <Book>[
  {
    'title': 'Основы Dart',
    'author': 'С. А. Чернышев',
    'year': 2024,
    'pages': 521,
    'genre':'Ученик',
    'read': true,
  },
  {
    'title':'Flutter на практике',
    'author': 'Ф. заметти',
    'year': 2020,
    'pages': 328,
    'genre': 'учебник',
    'read': false,
  },
  {
    'title': 'Чистый код',
    'author': 'Р. Мартин',
    'year': 2008,
    'pages':464,
    'genre':'программирование',
    'read': true,
  },
  {
    'title':'Гарри Потткр и филосовский камень',
    'author':'Дж. Роулинг',
    'year': 1997,
    'pages': 332,
    'genre': 'фэнтази',
    'read':true,
  },
  {
    'title': 'война и Мир',
    'author': 'Л. Толстой',
    'year': 1869,
    'pages': 1274,
    'read': false,       
  },
  {
    'title':'Мастер и Маргарита',
    'author': 'М. Булгаков',
    'year': 1965,
    'pages':688,
    'genre':'фантастика',
    'read':true,
  },
  {
    'title':'1984',
    'author':'Дж. Оруэлл',
    'year': 1949,
    'pages':320,
    'genre': 'Фантастика',
    'read': true,
  },
];

//Задание 2. Меню

void printMenu(){
  print('bookshelf: каталог');
  print('1. Показать весь каталог');
  print('2. Поиск по автору');
  print('3. Поиск по названию');
  print('4. Фильтр по жанру');
  print('5. Фильтр по признаку "Прочитана"');
  print('6. Сортировка');
  print('7. Статистика каталога');
  print('8. Добавить книгу');
  print('9. Удалить книгу по номеру');
  print(' 0. Выход');
}

//задание 3. Вывод и поиск

void printAll(List<Book> books,{String emptyMassage = 'Ничего не найдено'}){
  if(books.isEmpty){
    print(emptyMassage);
    return;
  }
  for(int i = 0; i<books.length; i++){
    final Book b = books[i];
    final String mark = (b['read'] as bool? ?? false) ? '✓' : ' ';
    final String num = (i+1).toString().padLeft(2);
    print('$num. [$mark]"${b['title']}" - ${b['author']},'
    '${b['year']},${b['pages']} стр., жанр: ${b['genre']}');
  }
}


List<Book> searchByField(List<Book> books, String field, String query){
  final String q=query.trim().toLowerCase();
  if(q.isEmpty){
    return <Book>[];
  }
  return books
  .where((Book b) =>
  (b[field]?.toString().toLowerCase()?? '').contains(q))
.toList();
}
List<Book> filteredByRead(List<Book> books, bool isRead){
  return books
  .where((Book b)=> (b['read'] as bool? ?? false) == isRead)
  .toList();
}
List<Book> sortBy(List<Book>books, String field,{bool descending = false}){
  final List<Book> copy = <Book> [...books];
  copy.sort((Book a, Book b){
    final Object? va = a[field];
    final Object? vb = b[field];
    int cmp;
    if(va is num && vb is num){
      cmp = va.compareTo(vb);
    }
      else{
        cmp = (va?.toString() ?? '').compareTo(vb?.toString() ?? '');
      }
      return descending ? -cmp : cmp;
  });
  return copy;
}

//4 Задание. Статистика

void printStatistics(List<Book> books){
  if(books.isEmpty){
    print('Каталог пуст.');
    return;
  }
  final int total = books.length;
  final int readCount = books.where((Book b)=> b['read'] == true).length;

  final int totalPages = books.fold<int>(0, (int sum, Book b)=> sum + ((b['pages'] as int ?) ?? 0));
  final double avgPages = totalPages / total;

  final Book oldest = books.reduce((Book a, Book b)=>
 ((a['year'] as int?)?? 0) <= ((b['year'] as int?) ?? 0)? a:b );
 final Book newest = books.reduce((Book a, Book b,)=>
 ((a['year'] as int?) ?? 0 )>= ((b['year'] as int?)?? 0)? a : b);
 final Book thickest = books.reduce((Book a, Book b)=>
 ((a['pages'] as int?)?? 0) >= ((b['pages'] as int?)?? 0)? a:b);

 final Set<String> genres = books
 .map((Book b)=> b['genre']?.toString()??'без жанра')
 .toSet();

 final Map<String, int> byGenre = <String, int>{};
 books.forEach((Book b){
  final String g = b['genre']?.toString() ?? 'Без жанра';
  byGenre[g] = (byGenre[g] ??0)+1;
 });

 final double readPercent = readCount * 100 / total;

 final bool anyLong=books.any((Book b)=> ((b['pages']as int? )?? 0)>1000);
 final bool allClassic = books
 .where((Book b)=> b['genre'] == 'Классика')
 .every((Book b)=> ((b['year']as int?)?? 0)< 2000);
  print('Статистика');
  print('Всего книг: $total');
  print('Прочитано: $readCount (${readPercent.toStringAsFixed(1)}%)');
  print('Суммарно страниц: $totalPages');
  print('Стреднее страниц: ${avgPages.toStringAsFixed(1)}');
  print('Самая старая: "${oldest['title']}"(${oldest['year']})');
  print('Самая новая: "${newest['title']}"(${newest['year']})');
  print('Самая объёмная: "${thickest['title']}"(${thickest['pages']} стр.)');
  print('Уникальные жанры: ${genres.join(', ')}');
  print('Книги по жанрам:');
  byGenre.forEach((String g, int c)=>print(' $g:$c'));
  print('Есть книга > 1000 стр.: $anyLong');
  print('Все классические книги до 2000 года: $allClassic');
}

//5 Задание. Добавление и удаление

int askInt(String prompt, {int min = 0, int? max}){
  int? value;
  do{
    stdout.write('$prompt: ');
    value = int.tryParse(stdin.readLineSync(encoding: utf8) ?? '');
    if(value == null || value < min || (max!=null && value > max)){
      print('Некорректное значение. Ожидается целое число'
      '${max == null ?' не меньше $min':' от $min до $max'}.');
      value == null;
    }
  } while(value == null);
  return value;
}

bool askYesNo(String prompt) {
  stdout.write('$prompt(да/нет)');
  final String answer = 
  (stdin.readLineSync(encoding: utf8) ?? '').trim().toLowerCase();
  return answer == 'да' || answer == 'yes' || answer == 'y' || answer == '1';
   }
   void addBook(List<Book> books){
    stdout.write('Название: ');
    final String title = (stdin.readLineSync(encoding: utf8)?? '').trim();
    if(title.isEmpty){
      print('Отмена: пустое название.');
    return;
    }
    stdout.write('Автор: ');
    final String author = (stdin.readLineSync(encoding: utf8) ?? '').trim();

    final int year = askInt('Год издания', min:1000,max:DateTime.now().year);
    final int pages = askInt('Колличество страниц', min:1);

    stdout.write('Жанр: ');
    final String genre =(stdin.readLineSync(encoding: utf8)?? '').trim();

    final bool read = askYesNo('Прочитана');

    books.add(<String, Object?>{
      'title': title,
      'author':author,
      'year':year,
      'pages': pages,
      'genre':genre,
      'read': read,
    });
    print('Книга добавлена');
   }
   void removeBook(List<Book> books){
    if(books.isEmpty){
      print('Каталог пуст.');
      return;
    }
    printAll(books);
    final int idx = 
    askInt('Номер для удаления', min:1, max: books.length)-1;
    final String t='${books[idx]['title']}';
    if(askYesNo('Удалить "$t"')){
      books.remove(idx);
      print('Удалено');
    }
    else{
      print('Отмена');
    }
   }
   
   //6 Задание. Функция высшего порядка