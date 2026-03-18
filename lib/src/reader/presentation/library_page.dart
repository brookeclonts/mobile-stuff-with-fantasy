import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/reader/data/reader_repository.dart';
import 'package:swf_app/src/reader/models/reader_book.dart';
import 'package:swf_app/src/reader/presentation/reader_page.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// The user's reading library — books they've added for reading.
class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key, this.repository});

  final ReaderRepository? repository;

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late final ReaderRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = widget.repository ?? ServiceLocator.readerRepository;
  }

  void _openReader(ReaderBook book) {
    final source = EpubSource.fromUrl(book.epubUrl);
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ReaderPage(book: book, epubSource: source),
      ),
    );
  }

  void _loadSampleBooks() {
    const samples = [
      ReaderBook(
        id: 'gutenberg-11',
        title: "Alice's Adventures in Wonderland",
        author: 'Lewis Carroll',
        epubUrl: 'https://www.gutenberg.org/ebooks/11.epub.images',
        coverUrl: 'https://www.gutenberg.org/cache/epub/11/pg11.cover.medium.jpg',
      ),
      ReaderBook(
        id: 'gutenberg-84',
        title: 'Frankenstein',
        author: 'Mary Shelley',
        epubUrl: 'https://www.gutenberg.org/ebooks/84.epub.images',
        coverUrl: 'https://www.gutenberg.org/cache/epub/84/pg84.cover.medium.jpg',
      ),
      ReaderBook(
        id: 'gutenberg-345',
        title: 'Dracula',
        author: 'Bram Stoker',
        epubUrl: 'https://www.gutenberg.org/ebooks/345.epub.images',
        coverUrl: 'https://www.gutenberg.org/cache/epub/345/pg345.cover.medium.jpg',
      ),
      ReaderBook(
        id: 'gutenberg-55',
        title: 'The Wonderful Wizard of Oz',
        author: 'L. Frank Baum',
        epubUrl: 'https://www.gutenberg.org/ebooks/55.epub.images',
        coverUrl: 'https://www.gutenberg.org/cache/epub/55/pg55.cover.medium.jpg',
      ),
      ReaderBook(
        id: 'gutenberg-1661',
        title: 'The Adventures of Sherlock Holmes',
        author: 'Arthur Conan Doyle',
        epubUrl: 'https://www.gutenberg.org/ebooks/1661.epub.images',
        coverUrl: 'https://www.gutenberg.org/cache/epub/1661/pg1661.cover.medium.jpg',
      ),
    ];

    setState(() {
      for (final book in samples) {
        _repo.addBook(book);
      }
    });
  }

  void _addBook() {
    showDialog<void>(
      context: context,
      builder: (context) => _AddBookDialog(
        onAdd: (book) {
          setState(() => _repo.addBook(book));
        },
      ),
    );
  }

  void _removeBook(ReaderBook book) {
    setState(() => _repo.removeBook(book.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed "${book.title}"'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() => _repo.addBook(book)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final books = _repo.books;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Library',
          style: GoogleFonts.playfairDisplay(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          GestureDetector(
            onLongPress: _loadSampleBooks,
            child: Container(
              width: 48,
              height: 48,
              color: Colors.red.withAlpha(100),
            ),
          ),
        ],
      ),
      body: books.isEmpty ? _buildEmptyState(theme) : _buildGrid(theme, books),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        tooltip: 'Add book',
        backgroundColor: SwfColors.color4,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 72,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
            ),
            const SizedBox(height: 20),
            Text(
              'Your library awaits',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add books to start reading. Tap + to add an EPUB by URL.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(ThemeData theme, List<ReaderBook> books) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = switch (constraints.maxWidth) {
          >= 900 => 4,
          >= 600 => 3,
          _ => 2,
        };
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            childAspectRatio: 0.58,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return _LibraryBookCard(
              book: book,
              onTap: () => _openReader(book),
              onLongPress: () => _removeBook(book),
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Library book card
// ─────────────────────────────────────────────────────────────────────────────

class _LibraryBookCard extends StatelessWidget {
  const _LibraryBookCard({
    required this.book,
    this.onTap,
    this.onLongPress,
  });

  final ReaderBook book;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (book.coverUrl.isNotEmpty)
                    Image.network(
                      book.coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _coverFallback(theme),
                    )
                  else
                    _coverFallback(theme),
                  // Progress overlay at the bottom
                  if (book.progress > 0)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: LinearProgressIndicator(
                        value: book.progress,
                        minHeight: 3,
                        backgroundColor: Colors.black38,
                        valueColor:
                            const AlwaysStoppedAnimation(SwfColors.color4),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isDark ? SwfColors.color8 : SwfColors.gray,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Author
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isDark ? SwfColors.color5 : SwfColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _coverFallback(ThemeData theme) {
    final colors = [
      [SwfColors.color2, SwfColors.color3],
      [SwfColors.color7, SwfColors.color3],
      [SwfColors.darkNavy, SwfColors.color4],
    ];
    final pair = colors[book.id.hashCode.abs() % colors.length];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: pair,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Text(
          book.title,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add book dialog
// ─────────────────────────────────────────────────────────────────────────────

class _AddBookDialog extends StatefulWidget {
  const _AddBookDialog({required this.onAdd});

  final ValueChanged<ReaderBook> onAdd;

  @override
  State<_AddBookDialog> createState() => _AddBookDialogState();
}

class _AddBookDialogState extends State<_AddBookDialog> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final url = _urlController.text.trim();

    if (title.isEmpty || url.isEmpty) return;

    final book = ReaderBook(
      id: url.hashCode.toRadixString(16),
      title: title,
      author: _authorController.text.trim(),
      epubUrl: url,
    );

    widget.onAdd(book);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Book'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'The Name of the Wind',
            ),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _authorController,
            decoration: const InputDecoration(
              labelText: 'Author (optional)',
              hintText: 'Patrick Rothfuss',
            ),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'EPUB URL',
              hintText: 'https://example.com/book.epub',
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
