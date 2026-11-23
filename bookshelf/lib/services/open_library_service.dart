import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../models/reading_status.dart';

class OpenLibraryService {
  final http.Client _client;
  OpenLibraryService([http.Client? client]) : _client = client ?? http.Client();

  Future<List<Book>> search(String query, {int limit = 20}) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'limit': '$limit',
      'fields':
          'title,author_name,first_publish_year,number_of_pages_median,cover_i,subject',
    });
    final response =
        await _client.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw HttpException('Open Library вернул ${response.statusCode}');
    }

    final json =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final docs = (json['docs'] as List?) ?? const [];

    return docs
        .cast<Map<String, dynamic>>()
        .map(_mapBook)
        .where((b) => b.title.isNotEmpty)
        .toList();
  }

  Book _mapBook(Map<String, dynamic> d) {
    final authors = d['author_name'] as List?;
    final subjects = d['subject'] as List?;
    final coverId = d['cover_i'];

    String? coverUrl;
    if (coverId != null) {
      coverUrl = 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
    }
    return Book(
      title: d['title'] as String? ?? '',
      author: authors != null && authors.isNotEmpty
          ? authors.first as String
          : 'Неизвестен',
      year: (d['first_publish_year'] as num?)?.toInt() ?? 0,
      pages: (d['number_of_pages_median'] as num?)?.toInt() ?? 0,
      genres: subjects != null
          ? subjects.take(3).cast<String>().toSet()
          : <String>{},
      status: ReadingStatus.planned,
      coverUrl: coverUrl,
    );
  }

  void dispose() => _client.close();
}
