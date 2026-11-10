import 'dart:async';

Future<String> slowTask(String name, int second) async {
  await Future.delayed(Duration(seconds: second));
  return 'Задача $name завершена';
}

void main() async {
  print('1. Последовательно');
  final sw1 = Stopwatch()..start();
  await slowTask('A', 2);
  await slowTask('B', 2);
  await slowTask('C', 2);
  sw1.stop();
  print('Последовательно: ${sw1.elapsedMilliseconds} мс(Ожидается ~6000)');

  print('2. Параллельно(Future.wait)');
  final sw2 = Stopwatch()..start();
  await Future.wait([slowTask('A', 2), slowTask('B', 2), slowTask('C', 2)]);
  sw2.stop();
  print(
    'Параллельно(Future.wait): ${sw2.elapsedMilliseconds} мс(Ожидается ~2000)',
  );

  print('3. Future.any');
  final fast = await Future.any([
    slowTask('Быстрая', 1),
    slowTask('Медленная', 3),
  ]);
  print('Future.any вернул: $fast');

  print('4. Timeout');
  try {
    await slowTask('Долгая', 5).timeout(Duration(seconds: 2));
  } on TimeoutException {
    print(
      'Есть TimeoutException! Задача не успела выполниться за 2 секунды.',
    );
  }
}
