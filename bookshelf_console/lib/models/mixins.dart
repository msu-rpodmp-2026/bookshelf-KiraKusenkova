import 'book.dart';

mixin Rateble {
  double _ratingSum = 0.0;
  int _votesCount = 0;

  double get averageRating => _votesCount == 0 ? 0.0 : _ratingSum / _votesCount;
  void vote(double rating) {
    if (rating < 0 || rating > 5) {
      throw ArgumentError('Оценка должна быть от 0 до 5');
    }
    _ratingSum += rating;
    _votesCount++;
  }
}
mixin Loggable {
  void log(String message) {
    final now = DateTime.now();
    print('[${now.hour}: ${now.minute}: ${now.second}]$message');
  }
}
mixin Borrowable on Book {
  DateTime? _dueDate;

  bool get isBorrowed => _dueDate != null;
  void borrow(int days) {
    _dueDate = DateTime.now().add(Duration(days: days));
    print(
      'Книга "$title" выдана на $days дней. Вернуть до: ${_dueDate.toString().split(' ')[0]}',
    );
  }

  void giveBack() {
    _dueDate = null;
    print('Книга "$title" возвращена.');
  }
}
