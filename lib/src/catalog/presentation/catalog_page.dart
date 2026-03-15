import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/catalog/data/book_repository.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/catalog/models/taxonomy.dart';
import 'package:swf_app/src/catalog/presentation/widgets/book_tile.dart';
import 'package:swf_app/src/catalog/presentation/widgets/filter_bar.dart';
import 'package:swf_app/src/catalog/presentation/widgets/filter_sheet.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final BookRepository _repo = ServiceLocator.bookRepository;
  final ScrollController _scrollController = ScrollController();

  ActiveFilters _filters = const ActiveFilters();
  List<Book> _books = [];
  int _totalBooks = 0;
  int _currentPage = 1;
  bool _hasNextPage = false;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _init();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    // Load taxonomy first so we can resolve ObjectId → name in book responses.
    await _repo.loadTaxonomy();
    await _fetchBooks(page: 1);
  }

  Future<void> _fetchBooks({required int page}) async {
    if (page == 1) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    } else {
      setState(() => _isLoadingMore = true);
    }

    final result = await _repo.getBooks(
      page: page,
      search: _filters.searchQuery.isNotEmpty ? _filters.searchQuery : null,
      subgenreIds: _resolveIds(_filters.subgenres, _repo.taxonomy.subgenres),
      tropeIds: _resolveIds(_filters.tropes, _repo.taxonomy.tropes),
      spiceLevelIds: _resolveSpiceLevelIds(_filters.spiceLevels),
      ageCategoryIds:
          _resolveIds(_filters.ageCategories, _repo.taxonomy.ageCategories),
      representationIds:
          _resolveIds(_filters.representations, _repo.taxonomy.representations),
      languageLevels: _filters.languageLevels.isNotEmpty
          ? _filters.languageLevels.map((l) => l.name).toList()
          : null,
      hasAudiobook: _filters.audiobookOnly ? true : null,
    );

    if (!mounted) return;

    result.when(
      success: (paginated) {
        setState(() {
          if (page == 1) {
            _books = paginated.items;
          } else {
            _books = [..._books, ...paginated.items];
          }
          _totalBooks = paginated.total;
          _currentPage = paginated.page;
          _hasNextPage = paginated.hasNext;
          _isLoading = false;
          _isLoadingMore = false;
          _error = null;
        });
      },
      failure: (message, _) {
        setState(() {
          _error = message;
          _isLoading = false;
          _isLoadingMore = false;
        });
      },
    );
  }

  void _onFiltersChanged(ActiveFilters newFilters) {
    setState(() => _filters = newFilters);
    _fetchBooks(page: 1);
  }

  void _onScroll() {
    if (_isLoadingMore || !_hasNextPage) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchBooks(page: _currentPage + 1);
    }
  }

  Future<void> _onRefresh() async {
    await _repo.loadTaxonomy();
    await _fetchBooks(page: 1);
  }

  // ---------------------------------------------------------------------------
  // Filter name → ObjectId resolution
  // ---------------------------------------------------------------------------

  /// Given a set of display names, find matching taxonomy ObjectIds.
  List<String>? _resolveIds(
    Set<String> names,
    List<TaxonomyItem> items,
  ) {
    if (names.isEmpty) return null;
    return items.where((i) => names.contains(i.name)).map((i) => i.id).toList();
  }

  /// Special handling for spice levels — match by label substring.
  List<String>? _resolveSpiceLevelIds(Set<SpiceLevel> levels) {
    if (levels.isEmpty) return null;
    final labels = levels.map((l) => l.label.toLowerCase()).toSet();
    return _repo.taxonomy.spiceLevels
        .where((item) => labels.any((l) => item.name.toLowerCase().contains(l)))
        .map((item) => item.id)
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            SvgPicture.asset('assets/images/sykfantasylogo.svg', height: 38),
      ),
      body: Column(
        children: [
          FilterBar(
            filters: _filters,
            resultCount: _totalBooks,
            onFiltersChanged: _onFiltersChanged,
            onOpenFilterSheet: _showFilterSheet,
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _books.isEmpty) {
      return _ErrorState(
        message: _error!,
        onRetry: () => _fetchBooks(page: 1),
      );
    }

    if (_books.isEmpty) {
      return _EmptyState(
        hasFilters: _filters.hasActiveFilters,
        onClear: () => _onFiltersChanged(const ActiveFilters()),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = switch (constraints.maxWidth) {
            >= 900 => 4,
            >= 600 => 3,
            _ => 2,
          };
          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.52,
            ),
            itemCount: _books.length + (_isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _books.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return BookTile(
                book: _books[index],
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterSheet(
        filters: _filters,
        onApply: _onFiltersChanged,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

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
              Icons.cloud_off_outlined,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(message, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasFilters, required this.onClear});

  final bool hasFilters;
  final VoidCallback onClear;

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
              hasFilters
                  ? Icons.filter_alt_off_outlined
                  : Icons.menu_book_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              hasFilters ? 'No books match your filters' : 'No books yet',
              style: theme.textTheme.titleMedium,
            ),
            if (hasFilters) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onClear,
                child: const Text('Clear Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
