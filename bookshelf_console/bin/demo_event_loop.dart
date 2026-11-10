// Ожидаемый порядок вывода: A, F, D, E, B, C
// Пояснение: сначала выполняется синхронный код (A, F)
// Затем — очередь микрозадач: колбэк D планируется сразу (так как Future.value(0) уже завершен),
// а колбэк E ставится в очередь вторым. Микрозадачи выполняются в порядке поступления (D, затем E)
// В конце — очередь событий (макрозадачи): B и C

import 'dart:async';

void main() {
  print('A');
  Future(() => print('B'));
  Future.delayed(Duration.zero, () => print('C'));
  Future.value(0).then((_) => print('D'));
  scheduleMicrotask(() => print('E'));
  print('F');
}
