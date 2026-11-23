import 'package:flutter_test/flutter_test.dart';
import 'package:bookshelf/main.dart';

void main() {
  testWidgets('Отоюражение демонстрации книги в каталоге',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BookShelfApp());
    expect(find.text('Моя библиотека (2)'), findsOneWidget);
    expect(find.text('Война и мир'), findsOneWidget);
    expect(find.text('Книга, которой нет'), findsOneWidget);
  });
}
