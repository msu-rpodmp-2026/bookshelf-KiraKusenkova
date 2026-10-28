abstract interface class Searcheable {
  bool matches(String query);
}

abstract interface class Exportable {
  Map<String, dynamic> toJson();
}
