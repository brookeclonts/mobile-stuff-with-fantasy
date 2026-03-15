import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/catalog/data/book_repository.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/catalog/models/taxonomy.dart';
import 'package:swf_app/src/catalog/presentation/book_detail_page.dart';
import 'package:swf_app/src/catalog/presentation/widgets/book_tile.dart';
import 'package:swf_app/src/catalog/presentation/widgets/filter_bar.dart';
import 'package:swf_app/src/catalog/presentation/widgets/filter_sheet.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key, this.repository});

  final BookRepository? repository;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late final BookRepository _repo;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  ActiveFilters _filters = const ActiveFilters();
  List<Book> _books = [];
  int _totalBooks = 0;
  int _currentPage = 1;
  bool _hasNextPage = false;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;
  Timer? _searchDebounce;
  int _requestToken = 0;

  @override
  void initState() {
    super.initState();
    _repo = widget.repository ?? ServiceLocator.bookRepository;
    _scrollController.addListener(_onScroll);
    _initializeCatalog();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeCatalog() async {
    final taxonomyResult = await _repo.loadTaxonomy();
    if (!mounted) return;

    if (taxonomyResult is Failure<TaxonomyData>) {
      setState(() {
        _error = taxonomyResult.message;
        _isLoading = false;
        _isLoadingMore = false;
      });
      return;
    }

    await _fetchBooks(page: 1);
  }

  Future<void> _fetchBooks({required int page}) async {
    final requestToken = ++_requestToken;

    if (page == 1) {
      setState(() {
        _isLoading = true;
        _error = null;
        _isLoadingMore = false;
        _books = [];
        _totalBooks = 0;
        _currentPage = 1;
        _hasNextPage = false;
      });
    } else {
      setState(() => _isLoadingMore = true);
    }

    final trimmedSearch = _filters.searchQuery.trim();
    final result = await _repo.getBooks(
      page: page,
      search: trimmedSearch.isNotEmpty ? trimmedSearch : null,
      subgenreIds:
          _filters.subgenreIds.isNotEmpty ? _filters.subgenreIds.toList() : null,
      tropeIds: _filters.tropeIds.isNotEmpty ? _filters.tropeIds.toList() : null,
      spiceLevelIds: _filters.spiceLevelIds.isNotEmpty
          ? _filters.spiceLevelIds.toList()
          : null,
      ageCategoryIds: _filters.ageCategoryIds.isNotEmpty
          ? _filters.ageCategoryIds.toList()
          : null,
      representationIds: _filters.representationIds.isNotEmpty
          ? _filters.representationIds.toList()
          : null,
      languageLevels: _filters.languageLevels.isNotEmpty
          ? _filters.languageLevels.map((l) => l.name).toList()
          : null,
      kindleUnlimited: _filters.kindleUnlimitedOnly ? true : null,
      hasAudiobook: _filters.audiobookOnly ? true : null,
    );

    if (!mounted || requestToken != _requestToken) return;

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

        if (_books.isNotEmpty && page != 1) {
          _showMessage(message);
        }
      },
    );
  }

  void _onFiltersChanged(ActiveFilters newFilters) {
    _searchDebounce?.cancel();
    _syncSearchField(newFilters.searchQuery);
    setState(() => _filters = newFilters);
    _fetchBooks(page: 1);
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    setState(() => _filters = _filters.copyWith(searchQuery: value));
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _fetchBooks(page: 1);
    });
  }

  void _clearFilters() {
    _searchDebounce?.cancel();
    _searchController.clear();
    _onFiltersChanged(const ActiveFilters());
  }

  void _onScroll() {
    if (_isLoadingMore || !_hasNextPage) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchBooks(page: _currentPage + 1);
    }
  }

  Future<void> _onRefresh() async {
    final taxonomyResult = await _repo.loadTaxonomy();
    if (!mounted) return;

    if (taxonomyResult is Failure<TaxonomyData>) {
      _showMessage(taxonomyResult.message);
      return;
    }

    await _fetchBooks(page: 1);
  }

  Future<void> _retry() async {
    if (_repo.taxonomy.isEmpty) {
      await _initializeCatalog();
      return;
    }

    await _fetchBooks(page: 1);
  }

  void _syncSearchField(String value) {
    if (_searchController.text == value) return;
    _searchController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ColorFiltered(
          colorFilter: const ColorFilter.mode(
            SwfColors.color8,
            BlendMode.srcIn,
          ),
          child: SvgPicture.asset(
            'assets/images/sykfantasylogo.svg',
            height: 38,
          ),
        ),
      ),
      body: Column(
        children: [
          FilterBar(
            filters: _filters,
            taxonomy: _repo.taxonomy,
            searchController: _searchController,
            resultCount: _totalBooks,
            onFiltersChanged: _onFiltersChanged,
            onSearchChanged: _onSearchChanged,
            onClearAll: _clearFilters,
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
        onRetry: _retry,
      );
    }

    if (_books.isEmpty) {
      return _EmptyState(
        hasFilters: _filters.hasActiveFilters,
        onClear: _clearFilters,
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
              childAspectRatio: 0.48,
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
              final book = _books[index];
              return BookTile(
                book: book,
                onTap: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => BookDetailPage(book: book),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showFilterSheet() {
    if (_repo.taxonomy.isEmpty) {
      _showMessage('Filters are unavailable until taxonomy loads successfully.');
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterSheet(
        taxonomy: _repo.taxonomy,
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
