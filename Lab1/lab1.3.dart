void main(){
  print('Задание 3.Вычисляемые характеристики');

    // Исходные данные для примера (можно заменить на ввод пользователя)
  String title = "Сергей Александрович Чернышов";
  int pages = 350;
  int year = 2015;

  //Категория книги

  String category = (pages <= 150)? 'Брошюра':(pages <= 399)?'Книга':'Том';
print('Категория: $category');

//Время чтения (скорость 50 страниц в час)
double readingTime = pages / 50;
print ('Время чтения: ${readingTime.toStringAsFixed(1)}ч.');

//Возраст издания
int currentYear = DateTime.now().year;
int age = currentYear - year;
print('Возраст издания: $age лет');

//Инициалы автора
List<String> nameParts = title.split(' ');
String initials = nameParts.map((part)=> part[0].toUpperCase()+ '.').join(' ');
print('Инициалы: $initials');
}