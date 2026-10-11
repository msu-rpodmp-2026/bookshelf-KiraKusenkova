void main() {
    // 1. Различие / и ~/
print('7 / 2 = ${7 / 2}');
print('7 ~/ 2 = ${7 ~/ 2}');
print('7 % 2 = ${7 % 2}');

 // 2. Ленивое вычисление && и ||
bool func1(){
  print('Вызвана func1'); return false;
}
bool func2(){
  print('Вызвана func2'); return true;
}

print('Ленивое И:');
if(func1() && func2()) {} // func2 не вызовется


print('Ленивое ИЛИ:');
if(func2() || func1()){} // func1 не вызовется

  // 3. Операторы ?., ??, ??=
String? nullableString;
print('Длина строки через ?.: ${nullableString?.length}');  // null
print('Значение через ??: ${nullableString ?? 'Значение по умолчанию'}');

String? name;
name ??= 'Новое имя';
print('После ??=: $name');

// 4. Различие final и const
final DateTime now = DateTime.now();
// final - известен во время выполнения
//const DateTime constNow = DateTime.now(); 
// Ошибка: const требует compile-time constant
const double pi = 3.14;  // const - известен во время компиляции
print('Final: $now, Const: $pi');

  // 5. Каскадный оператор .. с StringBuffer
StringBuffer sb = StringBuffer();
sb..write('Привет')..write(' ')..write('Мир!');
print('Результат каскада: $sb');
}