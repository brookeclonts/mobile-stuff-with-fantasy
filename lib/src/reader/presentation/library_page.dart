import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/catalog/presentation/book_detail_page.dart';
import 'package:swf_app/src/catalog/presentation/widgets/book_tile.dart';
import 'package:swf_app/src/reader/data/reading_list_repository.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// The user's saved books.
class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key, this.repository});

  final ReadingListRepository? repository;

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late final ReadingListRepository _repo;
  List<Book> _books = [];
  bool _isLoading = true;
  String? _error;

  bool get _isAuthenticated => ServiceLocator.sessionStore.isAuthenticated;

  @override
  void initState() {
    super.initState();
    _repo = widget.repository ?? ServiceLocator.readingListRepository;
    _loadReadingList(forceRefresh: true);
  }

  Future<void> _loadReadingList({bool forceRefresh = false}) async {
    if (!_isAuthenticated) {
      if (!mounted) return;
      setState(() {
        _books = const [];
        _isLoading = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _repo.fetchReadingList(forceRefresh: forceRefresh);
    if (!mounted) return;

    result.when(
      success: (books) {
        setState(() {
          _books = books;
          _isLoading = false;
          _error = null;
        });
      },
      failure: (message, _) {
        setState(() {
          _books = const [];
          _isLoading = false;
          _error = message;
        });
      },
    );
  }

  Future<void> _removeFromReadingList(Book book) async {
    final result = await _repo.remove(book.id);
    if (!mounted) return;

    result.when(
      success: (_) {
        setState(() {
          _books = _repo.books;
        });
      },
      failure: (message, _) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }

  Future<void> _openBook(Book book) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => BookDetailPage(book: book)),
    );
    if (!mounted) return;
    await _loadReadingList(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reading List',
          style: GoogleFonts.playfairDisplay(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: switch ((_isAuthenticated, _isLoading, _error, _books.isEmpty)) {
        (_, true, _, _) => const Center(child: CircularProgressIndicator()),
        (false, _, _, _) => _buildGuestState(theme),
        (_, _, final String error, _) => _ErrorState(
          message: error,
          onRetry: () => _loadReadingList(forceRefresh: true),
        ),
        (_, _, _, true) => _buildEmptyState(theme),
        _ => RefreshIndicator(
          onRefresh: () => _loadReadingList(forceRefresh: true),
          color: SwfColors.color4,
          child: _buildGrid(),
        ),
      },
    );
  }

  Widget _buildGuestState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmarks_outlined,
              size: 72,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
            ),
            const SizedBox(height: 18),
            Text(
              'Sign in to start a reading list',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Open your profile to create an account, then save books from the catalog.',
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

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 72,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
            ),
            const SizedBox(height: 18),
            Text(
              'Nothing saved yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Save books from the catalog to build your reading list.',
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

  Widget _buildGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = switch (constraints.maxWidth) {
          >= 900 => 4,
          >= 600 => 3,
          _ => 2,
        };

        return GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.48,
          ),
          itemCount: _books.length,
          itemBuilder: (context, index) {
            final book = _books[index];
            return BookTile(
              book: book,
              isSaved: true,
              onSaveTap: () => _removeFromReadingList(book),
              onTap: () => _openBook(book),
            );
          },
        );
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: theme.colorScheme.error.withAlpha(170),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => onRetry(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
