import 'package:bookshelf/services/open_library_service.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/paper_book.dart';
import '../models/reading_status.dart';
import '../models/library.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Library<Book> myLibrary = Library<Book>();
  final OpenLibraryService _service = OpenLibraryService();
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    myLibrary.add(PaperBook(
      title: 'Война и мир',
      author: 'Л. Толстой',
      shelf: 'A-1',
      year: 1869,
      pages: 1274,
      genres: {'Классика'},
      status: ReadingStatus.planned,
    ));
    myLibrary.add(PaperBook(
      title: 'Книга, которой нет',
      author: 'Алекс Новак',
      shelf: 'B-2',
      year: 2015,
      pages: 178,
      genres: {'Нон-фикшен'},
      status: ReadingStatus.finished,
    ));
  }

  Future<void> _searchInLibrary() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isSearching = true);

    try {
      final foundBooks = await _service.search(query, limit: 5);

      if (!mounted) return;
      setState(() => _isSearching = false);

      if (foundBooks.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ничего не найдено')),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Результаты поиска'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: foundBooks.length,
                itemBuilder: (context, index) {
                  final b = foundBooks[index];
                  return ListTile(
                    title: Text(b.title),
                    subtitle: Text(b.author),
                    onTap: () {
                      myLibrary.add(b);
                      Navigator.pop(context);
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Добавление: ${b.title}')),
                      );
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Закрыть'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSearching = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка поиска: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookshelf: Каталог (${myLibrary.count})'),
        backgroundColor: const Color(0xFF932121),
        foregroundColor: const Color(0xFFFFFBDE),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Поиск в Open Library'),
                    content: TextField(
                      controller: _searchController,
                      decoration:
                          const InputDecoration(hintText: 'Например, Dune'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _searchInLibrary();
                        },
                        child: const Text('Искать'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : myLibrary.count == 0
              ? const Center(child: Text('Каталог пуст'))
              : ListView.builder(
                  itemCount: myLibrary.count,
                  itemBuilder: (context, index) {
                    final book = myLibrary.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: ListTile(
                        leading: Icon(
                          book.status.isDone ? Icons.check_circle : Icons.book,
                          color:
                              book.status.isDone ? Colors.green : Colors.grey,
                        ),
                        title: Text(book.title),
                        subtitle: Text('${book.author} (${book.year} г.)'),
                        trailing: Text(
                          book.status.label,
                          style: TextStyle(
                            color:
                                book.status.isDone ? Colors.green : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Скоро будет')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _service.dispose();
    super.dispose();
  }
}
