import 'package:flutter/material.dart';
import '../models/book.dart';

class DetailScreen extends StatelessWidget {
  final Book book;
  final bool showAppBar;

  const DetailScreen({
    super.key,
    required this.book,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(book.shortTitle),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 240,
                  child: (book.coverUrl != null && book.coverUrl!.isNotEmpty)
                      ? Image.network(
                          book.coverUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(colors),
                        )
                      : _placeholder(colors),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${book.year}',
                      style: textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title, style: textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  if (book.genres.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: book.genres
                          .map((genre) => Chip(label: Text(genre)))
                          .toList(),
                    ),
                  ],
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(
                        label: 'Объём',
                        value: '${book.pages} стр.',
                      ),
                      _StatItem(
                        label: 'Время чтения',
                        value: '~${book.readingHours.toStringAsFixed(1)} ч',
                      ),
                      _StatItem(
                        label: 'Состояние',
                        value: book.status.label,
                      ),
                      _StatItem(
                        label: 'Оценка',
                        value: book.rating != null ? '${book.rating} ★' : 'Нет',
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Text('Описание', style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Здесь размещается аннотация к произведению "${book.title}". '
                    'Книга написана автором ${book.author} в ${book.year} году и '
                    'насчитывает ${book.pages} страниц. Краткое описание помогает '
                    'быстро вспомнить сюжет и главные идеи произведения.',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {},
                          child: const Text('Отметить прочитанной'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text('Редактировать'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(ColorScheme colors) {
    return Container(
      color: colors.surfaceContainerHighest,
      child: Icon(
        Icons.menu_book,
        size: 64,
        color: colors.onSurfaceVariant,
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(value, style: textTheme.titleSmall),
        const SizedBox(height: 2),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
