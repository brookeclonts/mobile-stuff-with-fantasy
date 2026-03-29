import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/profile/data/leaderboard_mock.dart';
import 'package:swf_app/src/profile/models/leaderboard.dart';
import 'package:swf_app/src/profile/presentation/widgets/leaderboard_opt_in_sheet.dart';
import 'package:swf_app/src/profile/presentation/widgets/ranking_tile.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Full-page leaderboard / "Hall of Fame" for the guild hall.
///
/// Displays realm rankings with a metric selector, scrollable list, and a
/// sticky footer that pins the current user's position when they scroll
/// past their own entry.
class RealmRankingsPage extends StatefulWidget {
  const RealmRankingsPage({super.key});

  @override
  State<RealmRankingsPage> createState() => _RealmRankingsPageState();
}

class _RealmRankingsPageState extends State<RealmRankingsPage> {
  LeaderboardMetric _selectedMetric = LeaderboardMetric.questsSealed;
  LeaderboardPage? _page;
  bool _isLoading = true;
  String? _errorMessage;
  bool _showStickyFooter = false;

  final _scrollController = ScrollController();

  // Key used to find the current-user tile position in the list.
  final _currentUserKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadLeaderboard();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_page == null) return;
    final currentUserEntry = _page!.entries
        .where((e) => e.isCurrentUser)
        .firstOrNull;
    if (currentUserEntry == null) return;

    final keyContext = _currentUserKey.currentContext;
    if (keyContext == null) {
      // The widget is not visible — show sticky footer.
      if (!_showStickyFooter) {
        setState(() => _showStickyFooter = true);
      }
      return;
    }

    final box = keyContext.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;

    final position = box.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final visible = position.dy >= 0 && position.dy < screenHeight - 80;

    if (_showStickyFooter == visible) {
      setState(() => _showStickyFooter = !visible);
    }
  }

  Future<void> _loadLeaderboard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final repo = ServiceLocator.leaderboardRepository;
    final result = await repo.fetchLeaderboard(metric: _selectedMetric);

    if (!mounted) return;

    result.when(
      success: (page) {
        setState(() {
          _page = page;
          _isLoading = false;
        });
      },
      failure: (message, _) {
        // Fall back to mock data so the page is still usable offline.
        setState(() {
          _page = mockLeaderboardPage(metric: _selectedMetric);
          _errorMessage = message;
          _isLoading = false;
        });
      },
    );
  }

  void _onMetricChanged(LeaderboardMetric metric) {
    if (metric == _selectedMetric) return;
    setState(() => _selectedMetric = metric);
    _loadLeaderboard();
  }

  void _openOptInSheet() {
    showLeaderboardOptInSheet(
      context,
      accentColor: SwfColors.primaryButton,
      isOptedIn: false,
      onChanged: (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUserEntry =
        _page?.entries.where((e) => e.isCurrentUser).firstOrNull;

    return Scaffold(
      backgroundColor: SwfColors.primaryBackground,
      appBar: AppBar(
        title: Text(
          l10n.realmRankingsTitle,
          style: GoogleFonts.playfairDisplay(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: l10n.leaderboardOptInTitle,
            onPressed: _openOptInSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Metric selector
          _MetricSelector(
            selected: _selectedMetric,
            onChanged: _onMetricChanged,
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null && _page == null
                    ? _ErrorState(
                        message: _errorMessage!,
                        onRetry: _loadLeaderboard,
                      )
                    : RefreshIndicator(
                        onRefresh: _loadLeaderboard,
                        child: _page != null
                            ? _LeaderboardList(
                                page: _page!,
                                scrollController: _scrollController,
                                currentUserKey: _currentUserKey,
                              )
                            : const SizedBox.shrink(),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: _showStickyFooter && currentUserEntry != null
          ? _StickyPositionBar(
              entry: currentUserEntry,
              total: _page!.total,
            )
          : null,
    );
  }
}

// ---------------------------------------------------------------------------
// Metric selector
// ---------------------------------------------------------------------------

class _MetricSelector extends StatelessWidget {
  const _MetricSelector({
    required this.selected,
    required this.onChanged,
  });

  final LeaderboardMetric selected;
  final ValueChanged<LeaderboardMetric> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _MetricTab(
            label: l10n.leaderboardMetricQuests,
            icon: Icons.auto_stories_rounded,
            isSelected: selected == LeaderboardMetric.questsSealed,
            onTap: () => onChanged(LeaderboardMetric.questsSealed),
          ),
          const SizedBox(width: 8),
          _MetricTab(
            label: l10n.leaderboardMetricBooks,
            icon: Icons.menu_book_rounded,
            isSelected: selected == LeaderboardMetric.booksRead,
            onTap: () => onChanged(LeaderboardMetric.booksRead),
          ),
          const SizedBox(width: 8),
          _MetricTab(
            label: l10n.leaderboardMetricRelics,
            icon: Icons.diamond_rounded,
            isSelected: selected == LeaderboardMetric.relicsCollected,
            onTap: () => onChanged(LeaderboardMetric.relicsCollected),
          ),
        ],
      ),
    );
  }
}

class _MetricTab extends StatelessWidget {
  const _MetricTab({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = SwfColors.primaryButton;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? accent.withAlpha(20)
                : Colors.white.withAlpha(6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? accent.withAlpha(80)
                  : Colors.white.withAlpha(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? accent
                    : Colors.white.withAlpha(100),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? accent
                      : Colors.white.withAlpha(120),
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Leaderboard list
// ---------------------------------------------------------------------------

class _LeaderboardList extends StatelessWidget {
  const _LeaderboardList({
    required this.page,
    required this.scrollController,
    required this.currentUserKey,
  });

  final LeaderboardPage page;
  final ScrollController scrollController;
  final GlobalKey currentUserKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return CustomScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Header stats
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Icon(
                  Icons.people_alt_rounded,
                  size: 14,
                  color: Colors.white.withAlpha(100),
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.leaderboardTotalParticipants(page.total),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withAlpha(120),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Entries
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final entry = page.entries[index];
                final tile = RankingTile(
                  entry: entry,
                  accentColor: SwfColors.primaryButton,
                );

                if (entry.isCurrentUser) {
                  return KeyedSubtree(
                    key: currentUserKey,
                    child: tile,
                  );
                }
                return tile;
              },
              childCount: page.entries.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sticky footer for current user position
// ---------------------------------------------------------------------------

class _StickyPositionBar extends StatelessWidget {
  const _StickyPositionBar({
    required this.entry,
    required this.total,
  });

  final LeaderboardEntry entry;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final accent = SwfColors.primaryButton;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2235),
        border: Border(
          top: BorderSide(color: accent.withAlpha(60)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(80),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: accent.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: accent.withAlpha(60)),
            ),
            child: Text(
              '#${entry.position}',
              style: theme.textTheme.titleSmall?.copyWith(
                color: accent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.leaderboardYourPosition,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withAlpha(120),
                    letterSpacing: 1.0,
                    fontSize: 9,
                  ),
                ),
                Text(
                  entry.userName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            l10n.leaderboardPositionOfTotal(entry.position, total),
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withAlpha(160),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error state
// ---------------------------------------------------------------------------

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2235),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: SwfColors.primaryButton.withAlpha(50),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 42,
                color: SwfColors.primaryButton,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.leaderboardErrorHeadline,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha(160),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(l10n.profileTryAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
