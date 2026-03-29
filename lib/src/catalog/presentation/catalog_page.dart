import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/auth/data/auth_repository.dart';
import 'package:swf_app/src/auth/data/session_store.dart';
import 'package:swf_app/src/auth/models/user.dart';
import 'package:swf_app/src/catalog/data/book_repository.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/catalog/models/taxonomy.dart';
import 'package:swf_app/src/catalog/presentation/book_detail_page.dart';
import 'package:swf_app/src/catalog/presentation/widgets/book_tile.dart';
import 'package:swf_app/src/catalog/presentation/widgets/filter_bar.dart';
import 'package:swf_app/src/catalog/presentation/widgets/filter_sheet.dart';
import 'package:swf_app/src/creators/data/creator_repository.dart';
import 'package:swf_app/src/creators/models/creator.dart';
import 'package:swf_app/src/creators/presentation/creator_detail_page.dart';
import 'package:swf_app/src/creators/presentation/widgets/featured_creators_row.dart';
import 'package:swf_app/src/events/models/event.dart';
import 'package:swf_app/src/events/presentation/event_detail_page.dart';
import 'package:swf_app/src/events/presentation/widgets/event_banner.dart';
import 'package:swf_app/src/guild/presentation/guild_hub_page.dart';
import 'package:swf_app/src/lore_board/presentation/lore_board_page.dart';
import 'package:swf_app/src/profile/presentation/profile_page.dart';
import 'package:swf_app/src/reader/presentation/library_page.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({
    super.key,
    this.repository,
    this.authRepository,
    this.sessionStore,
  });

  final BookRepository? repository;
  final AuthRepository? authRepository;
  final SessionStore? sessionStore;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late final BookRepository _repo;
  late final CreatorRepository _creatorRepo;
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
  Set<String> _savedBookIds = <String>{};
  Timer? _searchDebounce;
  int _requestToken = 0;

  List<Creator> _featuredCreators = [];
  Event? _nextEvent;

  @override
  void initState() {
    super.initState();
    _repo = widget.repository ?? ServiceLocator.bookRepository;
    _creatorRepo = ServiceLocator.creatorRepository;
    _scrollController.addListener(_onScroll);
    _initializeCatalog();
    _loadFeaturedCreators();
    _loadNextEvent();
    _loadReadingList();
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
      subgenreIds: _filters.subgenreIds.isNotEmpty
          ? _filters.subgenreIds.toList()
          : null,
      tropeIds: _filters.tropeIds.isNotEmpty
          ? _filters.tropeIds.toList()
          : null,
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

  Future<void> _loadFeaturedCreators() async {
    final result = await _creatorRepo.getFeaturedCreators();
    if (!mounted) return;
    result.when(
      success: (creators) => setState(() => _featuredCreators = creators),
      failure: (_, _) {},
    );
  }

  Future<void> _loadNextEvent() async {
    final result = await ServiceLocator.eventRepository.fetchNextEvent();
    if (!mounted) return;
    result.when(
      success: (event) => setState(() => _nextEvent = event),
      failure: (_, _) {},
    );
  }

  void _openEventDetail(Event event) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => EventDetailPage(event: event)),
    );
  }

  void _openCreatorDetail(Creator creator) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CreatorDetailPage(creator: creator),
      ),
    );
  }

  Future<void> _onRefresh() async {
    unawaited(_loadFeaturedCreators());
    unawaited(_loadNextEvent());
    unawaited(_loadReadingList(forceRefresh: true));
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSignUpPrompt() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.catalogSignUpPrompt),
        action: SnackBarAction(
          label: l10n.catalogSnackbarActionProfile,
          onPressed: _openProfile,
        ),
      ),
    );
  }

  AuthRepository? _resolveAuthRepository() {
    if (widget.authRepository != null) return widget.authRepository;
    try {
      return ServiceLocator.authRepository;
    } catch (_) {
      return null;
    }
  }

  SessionStore? _resolveSessionStore() {
    if (widget.sessionStore != null) return widget.sessionStore;
    try {
      return ServiceLocator.sessionStore;
    } catch (_) {
      return null;
    }
  }

  Future<void> _openProfile() async {
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
    await _loadReadingList(forceRefresh: true);
  }

  User? _currentUser() => _resolveSessionStore()?.user;

  Future<void> _loadReadingList({bool forceRefresh = false}) async {
    if (_currentUser() == null) {
      if (!mounted) return;
      setState(() => _savedBookIds = <String>{});
      return;
    }

    final result = await ServiceLocator.readingListRepository.fetchReadingList(
      forceRefresh: forceRefresh,
    );
    if (!mounted) return;

    result.when(
      success: (_) {
        setState(() {
          _savedBookIds = ServiceLocator.readingListRepository.savedIds;
        });
      },
      failure: (message, statusCode) {},
    );
  }

  Future<void> _toggleReadingList(Book book) async {
    if (_currentUser() == null) {
      _showSignUpPrompt();
      return;
    }

    final isSaved = _savedBookIds.contains(book.id);
    final result = isSaved
        ? await ServiceLocator.readingListRepository.remove(book.id)
        : await ServiceLocator.readingListRepository.save(book);
    if (!mounted) return;

    result.when(
      success: (_) {
        setState(() {
          _savedBookIds = ServiceLocator.readingListRepository.savedIds;
        });
      },
      failure: (message, statusCode) {
        if (statusCode == 401) {
          _showSignUpPrompt();
          return;
        }
        _showMessage(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = _currentUser();

    return Scaffold(
      appBar: AppBar(
        title: ColorFiltered(
          colorFilter: const ColorFilter.mode(
            SwfColors.color8,
            BlendMode.srcIn,
          ),
          child: SvgPicture.asset(
            'assets/images/swf_logo_cream.svg',
            height: 38,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.campaign_outlined, size: 22),
            tooltip: l10n.loreBoardTooltip,
            color: SwfColors.color8,
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(builder: (_) => const LoreBoardPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.shield_outlined, size: 22),
            tooltip: l10n.guildHubTitle,
            color: SwfColors.color8,
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(builder: (_) => const GuildHubPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.local_library_outlined, size: 22),
            tooltip: l10n.catalogTooltipLibrary,
            color: SwfColors.color8,
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(builder: (_) => const LibraryPage()),
            ).then((_) => _loadReadingList(forceRefresh: true)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Tooltip(
              message: l10n.catalogTooltipProfile,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: _openProfile,
                child: Ink(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(18),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withAlpha(24)),
                  ),
                  child: Center(
                    child: user != null
                        ? Text(
                            _initialsFor(user),
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          )
                        : const Icon(
                            Icons.person_outline_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _books.isEmpty) {
      return _ErrorState(message: _error!, onRetry: _retry);
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
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Event banner
              if (_nextEvent != null)
                SliverToBoxAdapter(
                  child: EventBanner(
                    event: _nextEvent!,
                    onTap: () => _openEventDetail(_nextEvent!),
                  ),
                ),
              // Featured creators row
              if (_featuredCreators.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: FeaturedCreatorsRow(
                      creators: _featuredCreators,
                      onCreatorTap: _openCreatorDetail,
                    ),
                  ),
                ),
              // Result count
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                  child: Text(
                    l10n.booksCount(_totalBooks),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              // Book grid
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
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
                      isSaved: _savedBookIds.contains(book.id),
                      onSaveTap: () => _toggleReadingList(book),
                      onTap: () => Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => BookDetailPage(book: book),
                        ),
                      ).then((_) => _loadReadingList(forceRefresh: true)),
                    );
                  }, childCount: _books.length + (_isLoadingMore ? 1 : 0)),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.48,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showFilterSheet() {
    if (_repo.taxonomy.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      _showMessage(l10n.catalogFiltersUnavailable);
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

  String _initialsFor(User user) {
    final source = user.name?.trim().isNotEmpty == true
        ? user.name!.trim()
        : user.email.split('@').first;
    final parts = source
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .toList();
    if (parts.isEmpty) return '?';
    return parts.map((part) => part.substring(0, 1)).join().toUpperCase();
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
              label: Text(l10n.catalogRetry),
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
    final l10n = AppLocalizations.of(context)!;

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
              hasFilters ? l10n.catalogEmptyFiltered : l10n.catalogEmptyNoBooks,
              style: theme.textTheme.titleMedium,
            ),
            if (hasFilters) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onClear,
                child: Text(l10n.catalogClearFilters),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
