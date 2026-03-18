import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/auth/data/auth_repository.dart';
import 'package:swf_app/src/auth/data/session_store.dart';
import 'package:swf_app/src/auth/models/user.dart';
import 'package:swf_app/src/auth/presentation/sign_up_flow.dart';
import 'package:swf_app/src/catalog/presentation/catalog_page.dart';
import 'package:swf_app/src/profile/data/profile_repository.dart';
import 'package:swf_app/src/profile/data/quest_compendium.dart';
import 'package:swf_app/src/profile/data/rune_compendium.dart';
import 'package:swf_app/src/profile/models/quest_campaign.dart';
import 'package:swf_app/src/profile/presentation/widgets/character_sheet.dart';
import 'package:swf_app/src/profile/presentation/widgets/guest_guild_state.dart';
import 'package:swf_app/src/profile/presentation/widgets/quest_scroll_card.dart';
import 'package:swf_app/src/profile/presentation/widgets/realm_map.dart';
import 'package:swf_app/src/profile/presentation/widgets/relic_vault.dart';
import 'package:swf_app/src/profile/presentation/widgets/reward_reveal_dialog.dart';
import 'package:swf_app/src/profile/presentation/widgets/rune_config_sheets.dart';
import 'package:swf_app/src/profile/presentation/widgets/rune_slots.dart';
import 'package:swf_app/src/profile/presentation/widgets/section_divider.dart';
import 'package:swf_app/src/profile/presentation/widgets/staggered_fade_slide.dart';
import 'package:swf_app/src/profile/presentation/widgets/subscriber_ledger.dart';
import 'package:swf_app/src/theme/swf_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    this.authRepository,
    this.profileRepository,
    this.sessionStore,
  });

  final AuthRepository? authRepository;
  final ProfileRepository? profileRepository;
  final SessionStore? sessionStore;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _subscriberFeatureUnlocked = false;

  late final AuthRepository? _authRepository;
  late final ProfileRepository? _profileRepository;
  late final SessionStore? _sessionStore;

  User? _user;
  bool _isLoading = true;
  bool _isSigningOut = false;
  String? _errorMessage;
  int? _errorStatusCode;
  SubscriberStats? _subscriberStats;
  bool _isLoadingSubscriberStats = false;
  String? _subscriberError;
  final Set<String> _completedObjectiveIds = <String>{};
  final Set<String> _revealedRewardIds = <String>{};
  final Set<String> _expandedScrollIds = <String>{};

  // Rune configuration state
  bool _arcEnabled = false;
  final Set<String> _selectedGenres = <String>{};
  final Set<String> _enabledNotifications = <String>{};

  // ---------------------------------------------------------------------------
  // Computed properties
  // ---------------------------------------------------------------------------

  QuestCampaign get _campaign => campaignForRole(_user?.role);

  int get _totalObjectives =>
      _campaign.scrolls.fold(0, (sum, s) => sum + s.objectives.length);

  int get _completedObjectives => _completedObjectiveIds.length;

  double get _progress {
    final total = _totalObjectives;
    if (total == 0) return 0;
    return _completedObjectives / total;
  }

  int get _rankIndex {
    final titles = _campaign.rankTitles;
    if (titles.isEmpty) return 0;
    return (_progress * (titles.length - 1))
        .round()
        .clamp(0, titles.length - 1);
  }

  String get _rankTitle {
    final titles = _campaign.rankTitles;
    if (titles.isEmpty) return 'Unknown Rank';
    return titles[_rankIndex];
  }

  bool get _isGuestState =>
      _errorStatusCode == 401 || (_authRepository == null && _user == null);

  bool _isScrollComplete(QuestScroll scroll) =>
      scroll.objectives
          .every((obj) => _completedObjectiveIds.contains(obj.id));

  bool get _allScrollsComplete =>
      _campaign.scrolls.every(_isScrollComplete);

  ScrollState _scrollState(int index) {
    final scroll = _campaign.scrolls[index];
    if (_isScrollComplete(scroll)) return ScrollState.sealed;
    final firstIncomplete = _campaign.scrolls.indexWhere(
      (s) => !_isScrollComplete(s),
    );
    if (index == firstIncomplete) return ScrollState.active;
    return ScrollState.locked;
  }

  QuestScroll? get _activeScroll {
    for (final scroll in _campaign.scrolls) {
      if (!_isScrollComplete(scroll)) return scroll;
    }
    return null;
  }

  int get _completedScrollCount =>
      _campaign.scrolls.where(_isScrollComplete).length;

  int get _relicsTotal {
    var count = _campaign.scrolls.length;
    if (_campaign.finalReward != null) count++;
    return count;
  }

  Set<String> get _completedScrollIds {
    return _campaign.scrolls
        .where(_isScrollComplete)
        .map((s) => s.id)
        .toSet();
  }

  int get _relicsCollected {
    final allRewardIds = <String>[
      ..._campaign.scrolls.map((s) => s.reward.id),
      if (_campaign.finalReward != null) _campaign.finalReward!.id,
    ];
    return allRewardIds.where(_revealedRewardIds.contains).length;
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? ServiceLocator.authRepository;
    _profileRepository =
        widget.profileRepository ?? ServiceLocator.profileRepository;
    _sessionStore = widget.sessionStore ?? ServiceLocator.sessionStore;

    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final authRepository = _authRepository;
    if (authRepository == null) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _errorStatusCode = null;
    });

    final result = await authRepository.getCurrentUser();
    if (!mounted) return;

    result.when(
      success: (user) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
        if (campaignForRole(user.role).role == 'author') {
          _loadSubscriberStats();
        }
      },
      failure: (message, statusCode) {
        setState(() {
          _errorMessage = message;
          _errorStatusCode = statusCode;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _loadSubscriberStats() async {
    final repo = _profileRepository;
    if (repo == null) return;

    setState(() {
      _isLoadingSubscriberStats = true;
      _subscriberError = null;
    });

    final result = await repo.getSubscriberStats();
    if (!mounted) return;

    result.when(
      success: (stats) {
        setState(() {
          _subscriberStats = stats;
          _isLoadingSubscriberStats = false;
        });
      },
      failure: (message, _) {
        setState(() {
          _subscriberError = message;
          _isLoadingSubscriberStats = false;
        });
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  Future<void> _openReference(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    final didLaunch = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!didLaunch && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open that scroll.')),
      );
    }
  }

  Future<void> _signOut() async {
    if (_isSigningOut) return;

    setState(() => _isSigningOut = true);

    final authRepository = _authRepository;
    final result = authRepository != null
        ? await authRepository.signOut()
        : const Success<void>(null);

    if (!mounted) return;

    result.when(
      success: (_) {
        _sessionStore?.clear();
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(builder: (_) => const CatalogPage()),
          (_) => false,
        );
      },
      failure: (message, _) {
        setState(() => _isSigningOut = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }

  void _goToSignUp() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const SignUpFlow()),
    );
  }

  void _toggleObjective(QuestScroll scroll, QuestObjective objective) {
    final wasComplete = _completedObjectiveIds.contains(objective.id);

    setState(() {
      if (wasComplete) {
        _completedObjectiveIds.remove(objective.id);
      } else {
        _completedObjectiveIds.add(objective.id);
      }
    });

    if (wasComplete) return;

    final newlyUnlockedRewards = <QuestReward>[];
    if (_isScrollComplete(scroll) &&
        _revealedRewardIds.add(scroll.reward.id)) {
      newlyUnlockedRewards.add(scroll.reward);
    }
    if (_allScrollsComplete &&
        _campaign.finalReward != null &&
        _revealedRewardIds.add(_campaign.finalReward!.id)) {
      newlyUnlockedRewards.add(_campaign.finalReward!);
    }

    if (newlyUnlockedRewards.isEmpty) return;

    for (final reward in newlyUnlockedRewards) {
      Future<void>.microtask(() async {
        if (!mounted) return;
        await showRewardReveal(
          context,
          reward: reward,
          accentColor: _campaign.accentColor,
          isGrandReward: _campaign.finalReward?.id == reward.id,
        );
      });
    }
  }

  void _onRuneTapped(String runeId) {
    switch (runeId) {
      case 'reader-arc-shield':
        showArcShieldConfig(
          context,
          accentColor: _campaign.accentColor,
          isArcEnabled: _arcEnabled,
          onChanged: (value) => setState(() => _arcEnabled = value),
        );
      case 'reader-genre-attunement':
        showGenreAttunementConfig(
          context,
          accentColor: _campaign.accentColor,
          selectedGenres: _selectedGenres,
          onChanged: (genres) =>
              setState(() {
                _selectedGenres
                  ..clear()
                  ..addAll(genres);
              }),
        );
      case 'reader-event-watchtower':
        showEventWatchtowerConfig(
          context,
          accentColor: _campaign.accentColor,
          enabledNotifications: _enabledNotifications,
          onChanged: (notifs) =>
              setState(() {
                _enabledNotifications
                  ..clear()
                  ..addAll(notifs);
              }),
        );
      // Author and Influencer runes — placeholder for future backend integration
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This rune will be configurable soon.'),
          ),
        );
    }
  }

  void _toggleScrollExpanded(String scrollId) {
    setState(() {
      if (_expandedScrollIds.contains(scrollId)) {
        _expandedScrollIds.remove(scrollId);
      } else {
        _expandedScrollIds.add(scrollId);
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SwfColors.primaryBackground,
      appBar: AppBar(
        title: Text(
          'Guild Hall',
          style: GoogleFonts.playfairDisplay(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading && _user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_isGuestState) {
      return GuestGuildState(
        campaigns: guestCampaignPreview,
        onCreateAccount: _goToSignUp,
      );
    }

    if (_errorMessage != null && _user == null) {
      return _ProfileErrorState(
        message: _errorMessage!,
        onRetry: _loadProfile,
      );
    }

    final user = _user!;
    final active = _activeScroll;
    final activeDone = active != null
        ? active.objectives
              .where((obj) => _completedObjectiveIds.contains(obj.id))
              .length
        : 0;

    final runes = runesForRole(_user?.role);

    return RefreshIndicator(
      onRefresh: () async {
        await _loadProfile();
        if (_campaign.role == 'author') {
          await _loadSubscriberStats();
        }
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ── Realm Map ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 100),
              child: RealmMap(
                campaign: _campaign,
                currentRankIndex: _rankIndex,
                rankTitle: _rankTitle,
                userName: _displayName(user),
                completedObjectives: _completedObjectives,
                totalObjectives: _totalObjectives,
                activeScrollTitle: active?.title,
                activeScrollObjectivesDone: activeDone,
                activeScrollObjectivesTotal:
                    active?.objectives.length ?? 0,
              ),
            ),
          ),

          // ── Error notice (if API failed but cached user available) ──
          if (_errorMessage != null)
            SliverToBoxAdapter(
              child: _InlineNotice(
                message: _errorMessage!,
                accentColor: _campaign.accentColor,
                onRetry: _loadProfile,
              ),
            ),

          // ── Rune Slots ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 250),
              child: Column(
                children: [
                  const SectionDivider(
                    title: 'Runes',
                    subtitle: 'Seal quests to engrave ability runes.',
                  ),
                  RuneSlots(
                    runes: runes,
                    completedScrollIds: _completedScrollIds,
                    accentColor: _campaign.accentColor,
                    onRuneTapped: _onRuneTapped,
                  ),
                ],
              ),
            ),
          ),

          // ── Reference link (e.g. Author Help Scroll) ──
          if (_campaign.referenceUrl != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SwfColors.secondaryAccent,
                    side: BorderSide(
                      color: SwfColors.secondaryAccent.withAlpha(80),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () =>
                      _openReference(_campaign.referenceUrl!),
                  icon: const Icon(Icons.menu_book_rounded, size: 18),
                  label: Text(
                    _campaign.referenceLabel ?? 'Open reference',
                  ),
                ),
              ),
            ),

          // ── Quest Log ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 400),
              child: const SectionDivider(
                title: 'Quest Log',
                subtitle: 'Unfurl scrolls to track and seal objectives.',
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final scroll = _campaign.scrolls[index];
                  final state = _scrollState(index);

                  return StaggeredFadeSlide(
                    delay: Duration(milliseconds: 450 + index * 100),
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom:
                            index == _campaign.scrolls.length - 1
                                ? 0
                                : 12,
                      ),
                      child: QuestScrollCard(
                        scroll: scroll,
                        scrollState: state,
                        accentColor: _campaign.accentColor,
                        borderColor: _campaign.borderColor,
                        parchmentColor: _campaign.scrollColor,
                        completedObjectiveIds: _completedObjectiveIds,
                        onToggleObjective: (obj) =>
                            _toggleObjective(scroll, obj),
                        isExpanded:
                            _expandedScrollIds.contains(scroll.id),
                        onToggleExpand: () =>
                            _toggleScrollExpanded(scroll.id),
                      ),
                    ),
                  );
                },
                childCount: _campaign.scrolls.length,
              ),
            ),
          ),

          // ── Relic Vault ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 800),
              child: Column(
                children: [
                  const SectionDivider(
                    title: 'Relic Vault',
                    subtitle:
                        'Seal scrolls to claim relics for your vault.',
                  ),
                  RelicVault(
                    campaign: _campaign,
                    unlockedRewardIds: _revealedRewardIds,
                  ),
                ],
              ),
            ),
          ),

          // ── Author: Subscriber Ledger ──
          if (_campaign.role == 'author') ...[
            SliverToBoxAdapter(
              child: StaggeredFadeSlide(
                delay: const Duration(milliseconds: 950),
                child: Column(
                  children: [
                    const SectionDivider(
                      title: 'Subscriber Ledger',
                    ),
                    SubscriberLedger(
                      isUnlocked: _subscriberFeatureUnlocked,
                      stats: _subscriberStats,
                      isLoading: _isLoadingSubscriberStats,
                      errorMessage: _subscriberError,
                    ),
                  ],
                ),
              ),
            ),
          ],

          // ── Character Sheet ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 1050),
              child: Column(
                children: [
                  const SectionDivider(
                    title: 'Character Sheet',
                  ),
                  CharacterSheet(
                    name: _displayName(user),
                    guild: _roleLabel(user.role),
                    rank: _rankTitle,
                    questsCompleted: _completedScrollCount,
                    questsTotal: _campaign.scrolls.length,
                    relicsCollected: _relicsCollected,
                    relicsTotal: _relicsTotal,
                    signal: user.email,
                    accentColor: _campaign.accentColor,
                  ),
                ],
              ),
            ),
          ),

          // ── Exit the Realm ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 1200),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 40),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white.withAlpha(140),
                    side: BorderSide(
                      color: Colors.white.withAlpha(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                  ),
                  onPressed: _isSigningOut ? null : _signOut,
                  icon: _isSigningOut
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.logout_rounded),
                  label: Text(
                    _isSigningOut
                        ? 'Leaving the realm...'
                        : 'Exit the Realm',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _displayName(User user) {
    final name = user.name?.trim();
    if (name != null && name.isNotEmpty) return name;
    return user.email.split('@').first;
  }

  String _roleLabel(String? role) {
    return switch (role) {
      'author' => 'Author',
      'influencer' => 'Influencer',
      'reader' => 'Reader',
      _ => 'Member',
    };
  }
}

// ---------------------------------------------------------------------------
// Small inline widgets specific to this page
// ---------------------------------------------------------------------------

class _InlineNotice extends StatelessWidget {
  const _InlineNotice({
    required this.message,
    required this.accentColor,
    required this.onRetry,
  });

  final String message;
  final Color accentColor;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: accentColor.withAlpha(15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accentColor.withAlpha(50)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: accentColor, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withAlpha(180),
                ),
              ),
            ),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: TextStyle(color: accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileErrorState extends StatelessWidget {
  const _ProfileErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                'The quest board failed to load',
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
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
