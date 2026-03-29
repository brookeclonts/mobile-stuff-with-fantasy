import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/auth/data/auth_repository.dart';
import 'package:swf_app/src/auth/data/session_store.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/catalog/presentation/book_detail_page.dart';
import 'package:swf_app/src/catalog/presentation/widgets/book_tile.dart';
import 'package:swf_app/src/profile/presentation/profile_page.dart';
import 'package:swf_app/src/reader/data/reader_access_repository.dart';
import 'package:swf_app/src/reader/data/reading_list_repository.dart';
import 'package:swf_app/src/reader/models/readable_book.dart';
import 'package:swf_app/src/reader/presentation/reader_launcher.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

enum LibraryTab { myBooks, readingList }

/// The user's saved and readable books.
class LibraryPage extends StatefulWidget {
  const LibraryPage({
    super.key,
    this.initialTab = LibraryTab.myBooks,
    this.repository,
    this.readerAccessRepository,
  });

  final LibraryTab initialTab;
  final ReadingListRepository? repository;
  final ReaderAccessRepository? readerAccessRepository;

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late final ReadingListRepository _readingListRepo;
  late final ReaderAccessRepository _readerAccessRepo;

  List<Book> _readingListBooks = [];
  List<ReadableBook> _myBooks = [];

  bool _readingListLoading = true;
  bool _myBooksLoading = true;

  String? _readingListError;
  String? _myBooksError;

  bool get _isAuthenticated => ServiceLocator.sessionStore.isAuthenticated;

  @override
  void initState() {
    super.initState();
    _readingListRepo =
        widget.repository ?? ServiceLocator.readingListRepository;
    _readerAccessRepo =
        widget.readerAccessRepository ?? ServiceLocator.readerAccessRepository;
    _loadReadingList(forceRefresh: true);
    _loadMyBooks(forceRefresh: true);
  }

  Future<void> _loadReadingList({bool forceRefresh = false}) async {
    if (!_isAuthenticated) {
      if (!mounted) return;
      setState(() {
        _readingListBooks = const [];
        _readingListLoading = false;
        _readingListError = null;
      });
      return;
    }

    setState(() {
      _readingListLoading = true;
      _readingListError = null;
    });

    final result = await _readingListRepo.fetchReadingList(
      forceRefresh: forceRefresh,
    );
    if (!mounted) return;

    result.when(
      success: (books) {
        setState(() {
          _readingListBooks = books;
          _readingListLoading = false;
          _readingListError = null;
        });
      },
      failure: (message, _) {
        setState(() {
          _readingListBooks = const [];
          _readingListLoading = false;
          _readingListError = message;
        });
      },
    );
  }

  Future<void> _loadMyBooks({bool forceRefresh = false}) async {
    if (!_isAuthenticated) {
      if (!mounted) return;
      setState(() {
        _myBooks = const [];
        _myBooksLoading = false;
        _myBooksError = null;
      });
      return;
    }

    setState(() {
      _myBooksLoading = true;
      _myBooksError = null;
    });

    final result = await _readerAccessRepo.fetchMyBooks(
      forceRefresh: forceRefresh,
    );
    if (!mounted) return;

    result.when(
      success: (books) {
        setState(() {
          _myBooks = books;
          _myBooksLoading = false;
          _myBooksError = null;
        });
      },
      failure: (message, _) {
        setState(() {
          _myBooks = const [];
          _myBooksLoading = false;
          _myBooksError = message;
        });
      },
    );
  }

  Future<void> _removeFromReadingList(Book book) async {
    final result = await _readingListRepo.remove(book.id);
    if (!mounted) return;

    result.when(
      success: (_) {
        setState(() {
          _readingListBooks = _readingListRepo.books;
        });
      },
      failure: (message, _) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }

  Future<void> _openReadingListBook(Book book) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => BookDetailPage(book: book)),
    );
    if (!mounted) return;
    await Future.wait([
      _loadReadingList(forceRefresh: true),
      _loadMyBooks(forceRefresh: true),
    ]);
  }

  Future<void> _openReadableBook(ReadableBook readableBook) async {
    await openBookReader(context, book: readableBook.book);
    if (!mounted) return;
    await _loadMyBooks(forceRefresh: true);
  }

  AuthRepository? _resolveAuthRepository() {
    try {
      return ServiceLocator.authRepository;
    } catch (_) {
      return null;
    }
  }

  SessionStore? _resolveSessionStore() {
    try {
      return ServiceLocator.sessionStore;
    } catch (_) {
      return null;
    }
  }

  Future<void> _openSignIn() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ProfilePage(
          authRepository: _resolveAuthRepository(),
          sessionStore: _resolveSessionStore(),
        ),
      ),
    );
    if (!mounted) return;
    await Future.wait([
      _loadReadingList(forceRefresh: true),
      _loadMyBooks(forceRefresh: true),
    ]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      initialIndex: widget.initialTab.index,
      length: 2,
      child: Scaffold(
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
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Books'),
              Tab(text: 'Reading List'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildMyBooksTab(theme), _buildReadingListTab(theme)],
        ),
      ),
    );
  }

  Widget _buildMyBooksTab(ThemeData theme) {
    return switch ((
      _isAuthenticated,
      _myBooksLoading,
      _myBooksError,
      _myBooks.isEmpty,
    )) {
      (_, true, _, _) => const Center(child: CircularProgressIndicator()),
      (false, _, _, _) => _SignInEmptyState(
        icon: Icons.auto_stories_outlined,
        title: 'Your bookshelf awaits',
        message:
            'Sign in to access books you\'ve purchased, claimed, or uploaded — ready to read right here.',
        onSignIn: _openSignIn,
      ),
      (_, _, final String error, _) => _ErrorState(
        message: error,
        onRetry: () => _loadMyBooks(forceRefresh: true),
      ),
      (_, _, _, true) => _EmptyState(
        icon: Icons.library_books_outlined,
        title: 'No readable books yet',
        message:
            'Books you buy, claim, or upload will show up here when they are ready to read.',
      ),
      _ => RefreshIndicator(
        onRefresh: () => _loadMyBooks(forceRefresh: true),
        color: SwfColors.color4,
        child: _buildMyBooksGrid(),
      ),
    };
  }

  Widget _buildReadingListTab(ThemeData theme) {
    return switch ((
      _isAuthenticated,
      _readingListLoading,
      _readingListError,
      _readingListBooks.isEmpty,
    )) {
      (_, true, _, _) => const Center(child: CircularProgressIndicator()),
      (false, _, _, _) => _SignInEmptyState(
        icon: Icons.bookmarks_outlined,
        title: 'Start your reading list',
        message:
            'Sign in to save books from the catalog and build your personal reading list.',
        onSignIn: _openSignIn,
      ),
      (_, _, final String error, _) => _ErrorState(
        message: error,
        onRetry: () => _loadReadingList(forceRefresh: true),
      ),
      (_, _, _, true) => _EmptyState(
        icon: Icons.menu_book_outlined,
        title: 'Nothing saved yet',
        message: 'Save books from the catalog to build your reading list.',
      ),
      _ => RefreshIndicator(
        onRefresh: () => _loadReadingList(forceRefresh: true),
        color: SwfColors.color4,
        child: _buildReadingListGrid(),
      ),
    };
  }

  Widget _buildMyBooksGrid() {
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
          itemCount: _myBooks.length,
          itemBuilder: (context, index) {
            final readableBook = _myBooks[index];
            return _ReadableBookTile(
              readableBook: readableBook,
              onTap: () => _openReadableBook(readableBook),
            );
          },
        );
      },
    );
  }

  Widget _buildReadingListGrid() {
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
          itemCount: _readingListBooks.length,
          itemBuilder: (context, index) {
            final book = _readingListBooks[index];
            return BookTile(
              book: book,
              isSaved: true,
              onSaveTap: () => _removeFromReadingList(book),
              onTap: () => _openReadingListBook(book),
            );
          },
        );
      },
    );
  }
}

class _ReadableBookTile extends StatelessWidget {
  const _ReadableBookTile({required this.readableBook, required this.onTap});

  final ReadableBook readableBook;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BookTile(book: readableBook.book, onTap: onTap),
        ),
        Positioned(
          left: 10,
          top: 10,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: SwfColors.color7.withAlpha(210),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: Text(
                  readableBook.accessLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: SwfColors.color4.withAlpha(18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: SwfColors.color4.withAlpha(180),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
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
}

class _SignInEmptyState extends StatelessWidget {
  const _SignInEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    required this.onSignIn,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    SwfColors.color3.withAlpha(40),
                    SwfColors.color4.withAlpha(30),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: SwfColors.color4.withAlpha(50),
                ),
              ),
              child: Icon(
                icon,
                size: 44,
                color: SwfColors.color4,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: onSignIn,
              icon: const Icon(Icons.person_outline, size: 20),
              label: const Text('Sign In'),
              style: FilledButton.styleFrom(
                backgroundColor: SwfColors.color4,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
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
