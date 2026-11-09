import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'book.dart';

class LibraryStorage {
  final String directory;
  const LibraryStorage(this.directory);
  String get _jsonPath => p.join(directory, 'library.json');

  Future<List<Book>> load() async {
    final file = File(_jsonPath);
    if (!await file.exists()) return [];

    try {
      final jsonString = await file
          .readAsString(); // <-- вот тут используется file
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((e) => Book.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      final backupFile = File('$_jsonPath.bak');
      await file.rename(backupFile.path);
      stderr.writeln(
        'Файл повреждён. Создана резервная копия: ${backupFile.path}',
      );
      return [];
    }
  }

  Future<void> save(List<Book> books) async {
    final dir = Directory(directory);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final tempFile = File('$_jsonPath.tmp');

    final jsonList = books.map((b) => b.toJson()).toList();
    final encoder = JsonEncoder.withIndent('  ');
    final jsonString = encoder.convert(jsonList);

    await tempFile.writeAsString(jsonString);
    await tempFile.rename(_jsonPath);
  }

  Future<bool> backup() async {
    final file = File(_jsonPath);
    if (!await file.exists()) return false;

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final backupPath = p.join(directory, 'library_$timestamp.json.bak');

    await file.copy(backupPath);
    return true;
  }
}
