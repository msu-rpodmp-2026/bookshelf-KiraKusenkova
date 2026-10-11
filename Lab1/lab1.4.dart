import 'dart:io';
// 2.5.1 List<String>
void main(){
  print('Задание 4. Коллекции');
  // 1. List<String> shelf
 List<String> shelf = ['Книга 1','Книга 2','Книга 3','Книга 4','Книга 5'];
print('Список: $shelf');
print('Длина списка: ${shelf.length}');
print('Первый элемент: ${shelf.first}');
print('Последний элемент: ${shelf.last}');
shelf.add('Книга 6');
shelf.insert(0, 'Книга 7');
shelf.remove('Книга 3');
print('Измененый список: $shelf');

  // 2. Set<String> genres
stdout.write('Введите жанры через запятую: ');
String? inputGenres = stdin.readLineSync();
if(inputGenres != null && inputGenres.isNotEmpty){
  Set<String> genres = inputGenres.split(',').map((e)=>e.trim()).toSet();
print('Жанры(дубликаты удалены): $genres');
}
Map<String, int> pagesByBook = {
  'Книга 1': 100,
  'Книга 2': 250,
  'Книга 3': 400,
  'Книга 4': 50,
  'Книга 5': 300,
};
print('Все пары: ');
pagesByBook.forEach((key, value)=> print('$key: $value'));

// Книга с макс. страницами
var maxEntry = pagesByBook.entries.reduce((a, b)=> a.value > b.value ? a : b);
print('Книга с макс страницами: ${maxEntry.key}(${maxEntry.key})');

// Суммарное и среднее
int totalPages = pagesByBook.values.reduce((a,b)=> a + b);
double avgPages = totalPages/pagesByBook.length;
print('Суммарно страниц: $totalPages');
print('Среднее количество: ${avgPages.toStringAsFixed(2)}');

// 4. Список all (spread, if, for)
List<int> numbers = [1, 2, 3, 4, 5];
bool includeEven = true;

List<int> all = [
  ...numbers, // spread
if(includeEven) 6, 
for(var i=7; i<=10; i++)i,]; // for
print('Список all: $all');
} 