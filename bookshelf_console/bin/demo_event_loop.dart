
// Ожидаемый порядок вывода: A, F, E, D, B, C
// (Сначала синхронный код A и F, затем микрозадачи E и D, затем макрозадачи B и C)

import 'dart:async';

void main() {
  print('A');
  Future(() => print('B'));
  Future.delayed(Duration.zero, () => print('C'));
  Future.value(0).then((_) => print('D'));
  scheduleMicrotask(() => print('E'));
  print('F');
}
