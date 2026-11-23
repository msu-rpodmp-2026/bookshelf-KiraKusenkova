import 'package:bookshelf/services/open_library_service.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/paper_book.dart';
import '../models/reading_status.dart';
import '../models/library.dart';
import '../widgets/book_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;

  const HomeScreen({super.key, this.onToggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Library<Book> myLibrary = Library<Book>();
  final OpenLibraryService _service = OpenLibraryService();
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  Book? _selectedBook;

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

    if (myLibrary.count > 0) {
      _selectedBook = myLibrary.items.first;
    }
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
                      _selectedBook ??= b;
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

  Widget _buildBookList({required bool isWide}) {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }
    if (myLibrary.count == 0) {
      return const Center(child: Text('Каталог пуст'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      itemCount: myLibrary.count,
      itemBuilder: (context, index) {
        final book = myLibrary.items[index];
        return BookCard(
          book: book,
          onTap: () {
            if (isWide) {
              setState(() => _selectedBook = book);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(book: book),
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final size = MediaQuery.sizeOf(context);
    final orientation = size.width >= size.height ? 'альбомная' : 'портретная';
    debugPrint(
      'Размер экрана: ${size.width.toStringAsFixed(0)}x${size.height.toStringAsFixed(0)}, ориентация: $orientation',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Моя библиотека (${myLibrary.count})'),
        actions: [
          if (widget.onToggleTheme != null)
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              tooltip: isDark ? 'Светлая тема' : 'Тёмная тема',
              onPressed: widget.onToggleTheme,
            ),
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;

            if (!isWide) {
              return _buildBookList(isWide: false);
            }

            final selected = _selectedBook ??
                (myLibrary.count > 0 ? myLibrary.items.first : null);

            return Row(
              children: [
                SizedBox(
                  width: 320,
                  child: _buildBookList(isWide: true),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: selected != null
                      ? DetailScreen(book: selected, showAppBar: false)
                      : const Center(child: Text('Выберите книгу из списка')),
                ),
              ],
            );
          },
        ),
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
