import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/auth/presentation/sign_up_flow.dart';
import 'package:swf_app/src/lore_board/data/lore_board_repository.dart';
import 'package:swf_app/src/lore_board/models/lore_entry.dart';
import 'package:swf_app/src/lore_board/presentation/widgets/lore_entry_card.dart';
import 'package:swf_app/src/profile/presentation/widgets/guest_guild_state.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Full-page activity feed.
///
/// Two tabs: Global (all public activity) and Friends (guild-mates).
/// Uses pull-to-refresh and infinite scroll.
class LoreBoardPage extends StatefulWidget {
  const LoreBoardPage({super.key});

  @override
  State<LoreBoardPage> createState() => _LoreBoardPageState();
}

class _LoreBoardPageState extends State<LoreBoardPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final LoreBoardRepository _repo;

  // Global feed state
  List<LoreEntry> _globalEntries = [];
  int _globalPage = 1;
  bool _globalHasNext = false;
  bool _globalLoading = true;
  bool _globalLoadingMore = false;

  // Friends feed state
  List<LoreEntry> _friendsEntries = [];
  int _friendsPage = 1;
  bool _friendsHasNext = false;
  bool _friendsLoading = true;
  bool _friendsLoadingMore = false;

  bool get _isAuthenticated => ServiceLocator.sessionStore.isAuthenticated;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _repo = ServiceLocator.loreBoardRepository;
    _loadGlobal();
    if (_isAuthenticated) _loadFriends();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadGlobal({bool loadMore = false}) async {
    if (loadMore && _globalLoadingMore) return;

    final page = loadMore ? _globalPage + 1 : 1;

    setState(() {
      if (loadMore) {
        _globalLoadingMore = true;
      } else {
        _globalLoading = true;
      }
    });

    final result = await _repo.fetchGlobalFeed(page: page);
    if (!mounted) return;

    result.when(
      success: (paginated) {
        setState(() {
          if (loadMore) {
            _globalEntries.addAll(paginated.items);
          } else {
            _globalEntries = paginated.items;
          }
          _globalPage = paginated.page;
          _globalHasNext = paginated.hasNext;
          _globalLoading = false;
          _globalLoadingMore = false;
        });
      },
      failure: (_, _) {
        setState(() {
          _globalLoading = false;
          _globalLoadingMore = false;
        });
      },
    );
  }

  Future<void> _loadFriends({bool loadMore = false}) async {
    if (loadMore && _friendsLoadingMore) return;

    final page = loadMore ? _friendsPage + 1 : 1;

    setState(() {
      if (loadMore) {
        _friendsLoadingMore = true;
      } else {
        _friendsLoading = true;
      }
    });

    final result = await _repo.fetchFriendsFeed(page: page);
    if (!mounted) return;

    result.when(
      success: (paginated) {
        setState(() {
          if (loadMore) {
            _friendsEntries.addAll(paginated.items);
          } else {
            _friendsEntries = paginated.items;
          }
          _friendsPage = paginated.page;
          _friendsHasNext = paginated.hasNext;
          _friendsLoading = false;
          _friendsLoadingMore = false;
        });
      },
      failure: (_, _) {
        setState(() {
          _friendsLoading = false;
          _friendsLoadingMore = false;
        });
      },
    );
  }

  void _goToSignUp() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const SignUpFlow()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: SwfColors.primaryBackground,
      appBar: AppBar(
        title: Text(
          l10n.loreBoardTitle,
          style: GoogleFonts.playfairDisplay(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: SwfColors.secondaryAccent,
          labelColor: SwfColors.secondaryAccent,
          unselectedLabelColor: Colors.white.withAlpha(120),
          tabs: [
            Tab(text: l10n.loreBoardGlobalTab),
            Tab(text: l10n.loreBoardFriendsTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _FeedList(
            entries: _globalEntries,
            isLoading: _globalLoading,
            isLoadingMore: _globalLoadingMore,
            hasNext: _globalHasNext,
            onRefresh: () => _loadGlobal(),
            onLoadMore: () => _loadGlobal(loadMore: true),
          ),
          _isAuthenticated
              ? _FeedList(
                  entries: _friendsEntries,
                  isLoading: _friendsLoading,
                  isLoadingMore: _friendsLoadingMore,
                  hasNext: _friendsHasNext,
                  onRefresh: () => _loadFriends(),
                  onLoadMore: () => _loadFriends(loadMore: true),
                )
              : GuestGuildState(onCreateAccount: _goToSignUp),
        ],
      ),
    );
  }
}

class _FeedList extends StatefulWidget {
  const _FeedList({
    required this.entries,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasNext,
    required this.onRefresh,
    required this.onLoadMore,
  });

  final List<LoreEntry> entries;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasNext;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;

  @override
  State<_FeedList> createState() => _FeedListState();
}

class _FeedListState extends State<_FeedList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        widget.hasNext &&
        !widget.isLoadingMore) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            l10n.loreBoardEmpty,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withAlpha(120),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: widget.entries.length + (widget.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == widget.entries.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return LoreEntryCard(entry: widget.entries[index]);
        },
      ),
    );
  }
}
