import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/auth/data/auth_repository.dart';
import 'package:swf_app/src/auth/data/session_store.dart';
import 'package:swf_app/src/auth/models/user.dart';
import 'package:swf_app/src/auth/presentation/sign_up_flow.dart';
import 'package:swf_app/src/catalog/presentation/catalog_page.dart';
import 'package:swf_app/src/profile/data/quest_compendium.dart';
import 'package:swf_app/src/profile/data/rune_compendium.dart';
import 'package:swf_app/src/profile/data/skill_tree_compendium.dart';
import 'package:swf_app/src/profile/data/seasonal_compendium.dart';
import 'package:swf_app/src/profile/models/daily_reading_entry.dart';
import 'package:swf_app/src/profile/models/quest_campaign.dart';
import 'package:swf_app/src/profile/models/reading_stats.dart';
import 'package:swf_app/src/profile/models/skill_tree.dart';
import 'package:swf_app/src/profile/presentation/widgets/achievement_sigils.dart';
import 'package:swf_app/src/profile/presentation/widgets/character_sheet.dart';
import 'package:swf_app/src/profile/presentation/widgets/guest_guild_state.dart';
import 'package:swf_app/src/profile/presentation/widgets/quest_scroll_card.dart';
import 'package:swf_app/src/profile/presentation/widgets/reading_chronicle.dart';
import 'package:swf_app/src/profile/presentation/widgets/realm_map.dart';
import 'package:swf_app/src/profile/presentation/widgets/relic_vault.dart';
import 'package:swf_app/src/profile/presentation/widgets/reward_reveal_dialog.dart';
import 'package:swf_app/src/profile/presentation/widgets/rune_config_sheets.dart';
import 'package:swf_app/src/profile/presentation/widgets/skill_branch_sheet.dart';
import 'package:swf_app/src/profile/presentation/widgets/rune_slots.dart';
import 'package:swf_app/src/profile/presentation/widgets/seasonal_campaign_banner.dart';
import 'package:swf_app/src/profile/presentation/widgets/seasonal_campaign_card.dart';
import 'package:swf_app/src/profile/presentation/widgets/seasonal_relic_section.dart';
import 'package:swf_app/src/profile/presentation/widgets/section_divider.dart';
import 'package:swf_app/src/profile/presentation/widgets/staggered_fade_slide.dart';
import 'package:swf_app/src/profile/presentation/widgets/tome_counter.dart';
import 'package:swf_app/src/profile/presentation/widgets/recommendation_forge_section.dart';
import 'package:swf_app/src/profile/presentation/widgets/review_scroll_section.dart';
import 'package:swf_app/src/profile/models/recommendation_pairing.dart';
import 'package:swf_app/src/profile/models/review.dart' as review_model;
import 'package:swf_app/src/profile/presentation/forge_editor_page.dart';
import 'package:swf_app/src/profile/presentation/review_editor_page.dart';
import 'package:swf_app/src/profile/presentation/widgets/book_picker_sheet.dart';
import 'package:swf_app/src/profile/data/preferences_provider.dart';
import 'package:swf_app/src/profile/data/profile_repository.dart';
import 'package:swf_app/src/profile/presentation/realm_rankings_page.dart';
import 'package:swf_app/src/profile/presentation/widgets/theme_attunement_sheet.dart';
import 'package:swf_app/src/profile/data/sigil_compendium.dart';
import 'package:swf_app/src/profile/data/title_compendium.dart';
import 'package:swf_app/src/profile/models/sigil_config.dart';
import 'package:swf_app/src/profile/presentation/widgets/sigil_builder_sheet.dart';
import 'package:swf_app/src/profile/presentation/widgets/title_picker_sheet.dart';
import 'package:swf_app/src/theme/swf_colors.dart';
import 'package:swf_app/src/oath/presentation/widgets/oath_stone_card.dart';
import 'package:swf_app/src/oath/presentation/swear_oath_page.dart';
import 'package:swf_app/src/oath/presentation/oath_page.dart';
import 'package:swf_app/src/oath/models/book_oath.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    this.authRepository,
    this.sessionStore,
  });

  final AuthRepository? authRepository;
  final SessionStore? sessionStore;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final AuthRepository? _authRepository;
  late final SessionStore? _sessionStore;
  late final ProfileRepository _profileRepository;
  late final ProfilePreferencesProvider _preferencesProvider;

  User? _user;
  bool _isLoading = true;
  bool _isSigningOut = false;
  bool _isDeletingAccount = false;
  String? _errorMessage;
  int? _errorStatusCode;
  final Set<String> _completedObjectiveIds = <String>{};
  final Set<String> _revealedRewardIds = <String>{};
  final Set<String> _expandedScrollIds = <String>{};

  // Reading stats
  ReadingStats _readingStats = const ReadingStats();
  List<DailyReadingEntry> _dailyEntries = const [];

  // Reviews & recommendations
  List<review_model.Review> _reviews = [];
  List<RecommendationPairing> _pairings = [];
  bool _reviewsLoading = true;
  bool _pairingsLoading = true;
  final Set<String> _expandedReviewIds = <String>{};

  // Oath
  BookOath? _oath;
  bool _oathLoading = true;

  // Rune configuration state
  bool _arcEnabled = false;
  final Set<String> _selectedGenres = <String>{};
  final Set<String> _enabledNotifications = <String>{};

  // Skill tree
  SkillTree? _skillTree;

  // Seasonal campaigns
  List<QuestCampaign> _seasonalCampaigns = <QuestCampaign>[];
  final Map<String, Set<String>> _seasonalCompletedObjectives = <String, Set<String>>{};
  final Map<String, Set<String>> _seasonalRevealedRewards = <String, Set<String>>{};
  bool _seasonalBannerExpanded = false;

  // ---------------------------------------------------------------------------
  // Computed properties
  // ---------------------------------------------------------------------------

  QuestCampaign get _campaign => campaignForRole(_user?.role);

  Color get _accentColor =>
      resolveAccentColor(_preferencesProvider.accentColorKey);

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
    if (titles.isEmpty) return AppLocalizations.of(context)!.profileUnknownRank;
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

  // Seasonal campaign helpers
  List<QuestCampaign> get _activeSeasonalCampaigns =>
      _seasonalCampaigns.where((c) => c.isActive).toList();

  int _seasonalTotalObjectives(QuestCampaign campaign) =>
      campaign.scrolls.fold(0, (sum, s) => sum + s.objectives.length);

  int _seasonalCompletedObjectiveCount(QuestCampaign campaign) {
    final ids = _seasonalCompletedObjectives[campaign.seasonId];
    if (ids == null) return 0;
    return ids.length;
  }

  bool _isSeasonalScrollComplete(QuestCampaign campaign, QuestScroll scroll) {
    final ids = _seasonalCompletedObjectives[campaign.seasonId] ?? const <String>{};
    return scroll.objectives.every((obj) => ids.contains(obj.id));
  }

  ScrollState _seasonalScrollState(QuestCampaign campaign, int index) {
    final scroll = campaign.scrolls[index];
    if (_isSeasonalScrollComplete(campaign, scroll)) return ScrollState.sealed;
    final firstIncomplete = campaign.scrolls.indexWhere(
      (s) => !_isSeasonalScrollComplete(campaign, s),
    );
    if (index == firstIncomplete) return ScrollState.active;
    return ScrollState.locked;
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? ServiceLocator.authRepository;
    _sessionStore = widget.sessionStore ?? ServiceLocator.sessionStore;
    _profileRepository = ServiceLocator.profileRepository;
    _preferencesProvider = ServiceLocator.preferencesProvider;
    _preferencesProvider.addListener(_onPreferencesChanged);

    _loadProfile();
    _loadReadingStats();
    _loadSeasonalCampaigns();
    _loadReviews();
    _loadPairings();
    _loadOath();
  }

  @override
  void dispose() {
    _preferencesProvider.removeListener(_onPreferencesChanged);
    super.dispose();
  }

  void _onPreferencesChanged() {
    if (mounted) setState(() {});
  }


  Future<void> _loadReadingStats() async {
    final repo = ServiceLocator.readingStatsRepository;
    final stats = await repo.getStats();
    final entries = await repo.getDailyEntries();
    if (!mounted) return;
    setState(() {
      _readingStats = stats;
      _dailyEntries = entries;
    });
  }

  Future<void> _loadOath() async {
    final result = await ServiceLocator.oathRepository.fetchMyOath();
    if (!mounted) return;
    result.when(
      success: (oath) => setState(() {
        _oath = oath;
        _oathLoading = false;
      }),
      failure: (_, _) => setState(() => _oathLoading = false),
    );
  }

  void _openOathPage() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const OathPage()),
    ).then((_) => _loadOath());
  }

  void _openSwearOath() async {
    final created = await Navigator.push<BookOath>(
      context,
      MaterialPageRoute<BookOath>(builder: (_) => const SwearOathPage()),
    );
    if (created != null && mounted) {
      setState(() => _oath = created);
    }
  }

  Future<void> _loadProfile() async {
    final authRepository = _authRepository;
    if (authRepository == null) {
      print('[PROFILE] authRepository is null — showing guest state');
      setState(() => _isLoading = false);
      return;
    }

    final token = _sessionStore?.token;
    print('[PROFILE] _loadProfile called. '
        'hasToken: ${token != null}, '
        'tokenLength: ${token?.length ?? 0}');

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _errorStatusCode = null;
    });

    final result = await authRepository.getCurrentUser();
    if (!mounted) return;

    result.when(
      success: (user) {
        print('[PROFILE] getCurrentUser SUCCESS: ${user.email}');
        setState(() {
          _user = user;
          _isLoading = false;
          _skillTree = defaultSkillTree();
        });
        _loadPreferences();
      },
      failure: (message, statusCode) {
        print('[PROFILE] getCurrentUser FAILED: $statusCode — $message');
        setState(() {
          _errorMessage = message;
          _errorStatusCode = statusCode;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _loadSeasonalCampaigns() async {
    // Try API first, fall back to mock data
    final campaigns = mockSeasonalCampaigns()
        .map((c) => c.isSeasonal ? summerReadingExpedition : c)
        .where((c) => c.isActive)
        .toList();
    if (!mounted) return;
    setState(() => _seasonalCampaigns = campaigns);
  }

  void _toggleSeasonalObjective(
    QuestCampaign campaign,
    QuestScroll scroll,
    QuestObjective objective,
  ) {
    final seasonId = campaign.seasonId ?? '';
    final completed = _seasonalCompletedObjectives.putIfAbsent(
      seasonId,
      () => <String>{},
    );
    final revealed = _seasonalRevealedRewards.putIfAbsent(
      seasonId,
      () => <String>{},
    );
    final wasComplete = completed.contains(objective.id);

    setState(() {
      if (wasComplete) {
        completed.remove(objective.id);
      } else {
        completed.add(objective.id);
      }
    });

    if (wasComplete) return;

    final newlyUnlockedRewards = <QuestReward>[];
    if (_isSeasonalScrollComplete(campaign, scroll) &&
        revealed.add(scroll.reward.id)) {
      newlyUnlockedRewards.add(scroll.reward);
    }
    final allDone = campaign.scrolls.every(
      (s) => _isSeasonalScrollComplete(campaign, s),
    );
    if (allDone &&
        campaign.finalReward != null &&
        revealed.add(campaign.finalReward!.id)) {
      newlyUnlockedRewards.add(campaign.finalReward!);
    }

    for (final reward in newlyUnlockedRewards) {
      Future<void>.microtask(() async {
        if (!mounted) return;
        await showRewardReveal(
          context,
          reward: reward,
          accentColor: campaign.accentColor,
          isGrandReward: campaign.finalReward?.id == reward.id,
        );
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Reviews & Recommendations
  // ---------------------------------------------------------------------------

  Future<void> _loadReviews() async {
    final result = await ServiceLocator.reviewRepository.fetchMyReviews();
    if (!mounted) return;
    result.when(
      success: (reviews) => setState(() {
            _reviews = reviews;
            _reviewsLoading = false;
          }),
      failure: (_, __) => setState(() => _reviewsLoading = false),
    );
  }

  Future<void> _loadPairings() async {
    final result =
        await ServiceLocator.recommendationRepository.fetchMyPairings();
    if (!mounted) return;
    result.when(
      success: (pairings) => setState(() {
            _pairings = pairings;
            _pairingsLoading = false;
          }),
      failure: (_, __) => setState(() => _pairingsLoading = false),
    );
  }

  void _toggleReviewExpanded(String reviewId) {
    setState(() {
      if (_expandedReviewIds.contains(reviewId)) {
        _expandedReviewIds.remove(reviewId);
      } else {
        _expandedReviewIds.add(reviewId);
      }
    });
  }

  Future<void> _navigateToReviewEditor({
    required Book book,
    review_model.Review? existing,
  }) async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewEditorPage(
          book: book,
          existingReview: existing,
        ),
      ),
    );
    if (created == true && mounted) {
      _loadReviews();
    }
  }

  void _onInscribeNewReview() {
    showBookPicker(
      context,
      onBookSelected: (book) => _navigateToReviewEditor(book: book),
    );
  }

  Future<void> _deleteReview(review_model.Review review) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Review'),
        content: const Text('Remove this review permanently?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await ServiceLocator.reviewRepository.deleteReview(review.id);
    if (mounted) _loadReviews();
  }

  Future<void> _navigateToForgeEditor() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ForgeEditorPage()),
    );
    if (created == true && mounted) {
      _loadPairings();
    }
  }

  Future<void> _deletePairing(RecommendationPairing pairing) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Recommendation'),
        content: const Text('Remove this pairing permanently?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await ServiceLocator.recommendationRepository.deletePairing(pairing.id);
    if (mounted) _loadPairings();
  }

  void _sharePairing(RecommendationPairing pairing) {
    final url = 'https://stuffwithfantasy.com/recommendations/${pairing.id}';
    final text =
        'If you liked "${pairing.sourceTitle}", try "${pairing.targetTitle}"! $url';
    Share.share(text);
  }

  Future<void> _loadPreferences() async {
    final result = await _profileRepository.fetchPreferences();
    if (!mounted) return;
    result.when(
      success: (data) => _preferencesProvider.mergeFromServer(data),
      failure: (_, _) {},
    );
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  Future<void> _signOut() async {
    if (_isSigningOut) return;

    setState(() => _isSigningOut = true);

    final authRepository = _authRepository;
    if (authRepository != null) {
      await authRepository.signOut();
    } else {
      _sessionStore?.clear();
    }

    if (!mounted) return;

    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const CatalogPage()),
      (_) => false,
    );
  }

  Future<void> _deleteAccount() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2235),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.red.withAlpha(80)),
        ),
        title: Text(
          l10n.profileDeleteAccountTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        content: Text(
          l10n.profileDeleteAccountBody,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withAlpha(180),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.profileDeleteCancel,
              style: TextStyle(color: Colors.white.withAlpha(140)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.profileDeleteConfirm,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    if (_isDeletingAccount) return;

    setState(() => _isDeletingAccount = true);

    final authRepository = _authRepository;
    final result = authRepository != null
        ? await authRepository.deleteAccount()
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
        setState(() => _isDeletingAccount = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }

  Future<void> _goToSignUp() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const SignUpFlow()),
    );
    if (!mounted) return;
    // Reload all data so the Guild Hall reflects the new session.
    _loadProfile();
    _loadReadingStats();
    _loadReviews();
    _loadPairings();
    _loadOath();
    _loadSeasonalCampaigns();
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
          accentColor: _accentColor,
          isGrandReward: _campaign.finalReward?.id == reward.id,
        );
      });
    }
  }

  void _onSkillTierTapped(String branchId, String tierId) {
    final tree = _skillTree;
    if (tree == null) return;

    final branch = tree.branches.where((b) => b.id == branchId).firstOrNull;
    if (branch == null) return;

    showSkillBranchSheet(
      context,
      branch: branch,
      accentColor: _accentColor,
      onRuneTapped: (runeId) {
        Navigator.of(context).pop();
        _onRuneTapped(runeId);
      },
    );
  }

  void _onRuneTapped(String runeId) {
    switch (runeId) {
      case 'reader-arc-shield':
        showArcShieldConfig(
          context,
          accentColor: _accentColor,
          isArcEnabled: _arcEnabled,
          onChanged: (value) => setState(() => _arcEnabled = value),
        );
      case 'reader-genre-attunement':
        showGenreAttunementConfig(
          context,
          accentColor: _accentColor,
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
          accentColor: _accentColor,
          enabledNotifications: _enabledNotifications,
          onChanged: (notifs) =>
              setState(() {
                _enabledNotifications
                  ..clear()
                  ..addAll(notifs);
              }),
        );
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.profileSnackbarRuneComingSoon),
          ),
        );
    }
  }

  Future<void> _openThemeAttunement() async {
    final result = await showThemeAttunementSheet(
      context,
      currentKey: _preferencesProvider.accentColorKey,
      accentColor: _accentColor,
    );
    if (!mounted) return;
    await _preferencesProvider.setAccentColorKey(result);
    _profileRepository.updatePreferences({'accentColorKey': result});
  }

  Future<void> _openTitlePicker() async {
    final scrollObjectives = <String, List<String>>{
      for (final scroll in _campaign.scrolls)
        scroll.id: scroll.objectives.map((o) => o.id).toList(),
    };
    final unlocked = evaluateUnlockedTitles(
      completedObjectiveIds: _completedObjectiveIds,
      revealedRewardIds: _revealedRewardIds,
      selectedGenres: _selectedGenres,
      hasConfiguredRune: _arcEnabled || _selectedGenres.isNotEmpty || _enabledNotifications.isNotEmpty,
      leaderboardOptIn: false,
      scrollObjectives: scrollObjectives,
    );
    final result = await showTitlePickerSheet(
      context,
      selectedTitleId: _preferencesProvider.selectedTitleId,
      unlockedTitles: unlocked,
      accentColor: _accentColor,
    );
    if (!mounted) return;
    await _preferencesProvider.setSelectedTitleId(result);
    _profileRepository.updatePreferences({'selectedTitleId': result});
  }

  Future<void> _openSigilBuilder() async {
    final current = _preferencesProvider.sigilConfig ?? defaultSigilConfig;
    final result = await showSigilBuilderSheet(
      context,
      currentConfig: current,
      accentColor: _accentColor,
      revealedRewardIds: _revealedRewardIds,
    );
    if (!mounted || result == null) return;
    await _preferencesProvider.setSigilConfig(result);
    _profileRepository.updatePreferences({'sigilConfig': result.toJson()});
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: SwfColors.primaryBackground,
      appBar: AppBar(
        title: Text(
          l10n.profileAppBarTitle,
          style: GoogleFonts.playfairDisplay(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          if (!_isGuestState && _user != null)
            IconButton(
              icon: Icon(
                Icons.auto_awesome_rounded,
                color: _accentColor,
              ),
              tooltip: 'Theme Attunement',
              onPressed: _openThemeAttunement,
            ),
            IconButton(
              icon: Icon(
                Icons.military_tech_rounded,
                color: _accentColor,
              ),
              tooltip: 'Choose Title',
              onPressed: _openTitlePicker,
            ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading && _user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_isGuestState) {
      return GuestGuildState(
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
      onRefresh: _loadProfile,
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
                customTitle: titleById(_preferencesProvider.selectedTitleId)?.label,
                sigilConfig: _preferencesProvider.sigilConfig,
                onSigilTapped: _openSigilBuilder,
              ),
            ),
          ),

          // ── Error notice (if API failed but cached user available) ──
          if (_errorMessage != null)
            SliverToBoxAdapter(
              child: _InlineNotice(
                message: _errorMessage!,
                accentColor: _accentColor,
                onRetry: _loadProfile,
              ),
            ),

          // ── Oath Stone ──
          if (!_oathLoading)
            SliverToBoxAdapter(
              child: StaggeredFadeSlide(
                delay: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    SectionDivider(
                      title: l10n.oathSectionTitle,
                      subtitle: l10n.oathSectionSubtitle,
                    ),
                    if (_oath != null)
                      OathStoneCard(
                        oath: _oath!,
                        accentColor: _accentColor,
                        onTap: _openOathPage,
                      )
                    else
                      OathSwearCta(
                        accentColor: _accentColor,
                        onTap: _openSwearOath,
                      ),
                  ],
                ),
              ),
            ),


          // ── Seasonal Campaign ──
          ..._buildSeasonalCampaignSlivers(l10n),

          // ── Rune Slots ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 250),
              child: Column(
                children: [
                  SectionDivider(
                    title: _skillTree != null
                        ? l10n.skillTreeSectionTitle
                        : l10n.profileSectionRunes,
                    subtitle: _skillTree != null
                        ? l10n.skillTreeSectionSubtitle
                        : l10n.profileSectionRunesSubtitle,
                  ),
                  RuneSlots(
                    runes: runes,
                    completedScrollIds: _completedScrollIds,
                    accentColor: _accentColor,
                    onRuneTapped: _onRuneTapped,
                    skillTree: _skillTree,
                    onTierTapped: _onSkillTierTapped,
                  ),
                ],
              ),
            ),
          ),

          // ── Quest Log ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 400),
              child: SectionDivider(
                title: l10n.profileSectionQuestLog,
                subtitle: l10n.profileSectionQuestLogSubtitle,
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
                        accentColor: _accentColor,
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
                  SectionDivider(
                    title: l10n.profileSectionRelicVault,
                    subtitle: l10n.profileSectionRelicVaultSubtitle,
                  ),
                  RelicVault(
                    campaign: _campaign,
                    unlockedRewardIds: _revealedRewardIds,
                  ),
                  // Seasonal relics
                  ...(_activeSeasonalCampaigns.map((sc) => Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SeasonalRelicSection(
                      campaign: sc,
                      unlockedRewardIds: _seasonalRevealedRewards[sc.seasonId] ?? const <String>{},
                    ),
                  ))),
                ],
              ),
            ),
          ),

          // ── Realm Rankings ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 925),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _accentColor,
                    side: BorderSide(color: _accentColor.withAlpha(80)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const RealmRankingsPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.emoji_events_rounded, color: _accentColor),
                  label: Text(l10n.realmRankingsTitle),
                ),
              ),
            ),
          ),

          // ── Reading Chronicle ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 1050),
              child: Column(
                children: [
                  SectionDivider(
                    title: l10n.profileSectionReadingChronicle,
                    subtitle: l10n.profileSectionReadingChronicleSubtitle,
                  ),
                  ReadingChronicle(
                    entries: _dailyEntries,
                    stats: _readingStats,
                    accentColor: _accentColor,
                  ),
                ],
              ),
            ),
          ),

          // ── Tome Counter ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 1200),
              child: Column(
                children: [
                  SectionDivider(
                    title: l10n.profileSectionTomeCounter,
                    subtitle: l10n.profileSectionTomeCounterSubtitle,
                  ),
                  TomeCounter(
                    stats: _readingStats,
                    accentColor: _accentColor,
                  ),
                ],
              ),
            ),
          ),

          // ── Achievement Sigils ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 1350),
              child: Column(
                children: [
                  SectionDivider(
                    title: l10n.profileSectionAchievementSigils,
                    subtitle: l10n.profileSectionAchievementSigilsSubtitle,
                  ),
                  AchievementSigils(
                    stats: _readingStats,
                    accentColor: _accentColor,
                  ),
                ],
              ),
            ),
          ),


          // ── Scroll of Reviews ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 1425),
              child: Column(
                children: [
                  const SectionDivider(
                    title: 'Scroll of Reviews',
                    subtitle: 'Your inscribed judgments',
                  ),
                  ReviewScrollSection(
                    reviews: _reviews,
                    accentColor: _accentColor,
                    expandedReviewIds: _expandedReviewIds,
                    onToggleExpand: _toggleReviewExpanded,
                    onInscribeNew: _onInscribeNewReview,
                    onEdit: (review) {
                      final book = Book.minimal(
                        id: review.bookId,
                        title: review.bookTitle,
                        authorName: review.bookAuthor,
                        imageUrl: review.bookImageUrl,
                      );
                      _navigateToReviewEditor(
                        book: book,
                        existing: review,
                      );
                    },
                    onDelete: _deleteReview,
                    isLoading: _reviewsLoading,
                  ),
                ],
              ),
            ),
          ),

          // ── Recommendation Forge ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 1500),
              child: Column(
                children: [
                  const SectionDivider(
                    title: 'Recommendation Forge',
                    subtitle: 'Books you have bound together',
                  ),
                  RecommendationForgeSection(
                    pairings: _pairings,
                    accentColor: _accentColor,
                    onLightTheForge: _navigateToForgeEditor,
                    onShare: _sharePairing,
                    onDelete: _deletePairing,
                    isLoading: _pairingsLoading,
                  ),
                ],
              ),
            ),
          ),

          // ── Character Sheet ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 1500),
              child: Column(
                children: [
                  SectionDivider(
                    title: l10n.profileSectionCharacterSheet,
                  ),
                  CharacterSheet(
                    name: _displayName(user),
                    customTitle: titleById(_preferencesProvider.selectedTitleId)?.label,
                    rank: _rankTitle,
                    questsCompleted: _completedScrollCount,
                    questsTotal: _campaign.scrolls.length,
                    relicsCollected: _relicsCollected,
                    relicsTotal: _relicsTotal,
                    signal: user.email,
                    accentColor: _accentColor,
                    realmRankPosition: 42,
                    realmRankTotal: 1200,
                    isLeaderboardOptedIn: true,
                  ),
                ],
              ),
            ),
          ),

          // ── Language ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 1650),
              child: _LanguagePicker(
                accentColor: _accentColor,
              ),
            ),
          ),

          // ── Exit the Realm & Delete Account ──
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 1800),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 40),
                child: Column(
                  children: [
                    OutlinedButton.icon(
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
                            ? l10n.profileSigningOut
                            : l10n.profileSignOut,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.withAlpha(140),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                      ),
                      onPressed: _isDeletingAccount ? null : _deleteAccount,
                      icon: _isDeletingAccount
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                          : const Icon(Icons.delete_forever_rounded, size: 20),
                      label: Text(
                        _isDeletingAccount
                            ? l10n.profileDeletingAccount
                            : l10n.profileDeleteAccount,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSeasonalCampaignSlivers(AppLocalizations l10n) {
    final campaigns = _activeSeasonalCampaigns;
    if (campaigns.isEmpty) return const <Widget>[];

    final slivers = <Widget>[];

    for (final campaign in campaigns) {
      final totalObj = _seasonalTotalObjectives(campaign);
      final completedObj = _seasonalCompletedObjectiveCount(campaign);
      final completedIds =
          _seasonalCompletedObjectives[campaign.seasonId] ?? const <String>{};

      // Banner
      slivers.add(
        SliverToBoxAdapter(
          child: StaggeredFadeSlide(
            delay: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SeasonalCampaignBanner(
                campaign: campaign,
                completedObjectiveCount: completedObj,
                totalObjectiveCount: totalObj,
                isExpanded: _seasonalBannerExpanded,
                onToggleExpand: () => setState(
                  () => _seasonalBannerExpanded = !_seasonalBannerExpanded,
                ),
              ),
            ),
          ),
        ),
      );

      // Expanded seasonal scrolls
      if (_seasonalBannerExpanded) {
        slivers.add(
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 350),
              child: SectionDivider(
                title: l10n.profileSectionSeasonalQuests,
                subtitle: l10n.profileSectionSeasonalQuestsSubtitle,
              ),
            ),
          ),
        );

        slivers.add(
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final scroll = campaign.scrolls[index];
                  final state = _seasonalScrollState(campaign, index);

                  return StaggeredFadeSlide(
                    delay: Duration(milliseconds: 400 + index * 100),
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: index == campaign.scrolls.length - 1 ? 0 : 12,
                      ),
                      child: SeasonalCampaignCard(
                        campaign: campaign,
                        scroll: scroll,
                        scrollState: state,
                        completedObjectiveIds: completedIds,
                        onToggleObjective: (obj) =>
                            _toggleSeasonalObjective(campaign, scroll, obj),
                        isExpanded: _expandedScrollIds.contains(scroll.id),
                        onToggleExpand: () => _toggleScrollExpanded(scroll.id),
                      ),
                    ),
                  );
                },
                childCount: campaign.scrolls.length,
              ),
            ),
          ),
        );
      }
    }

    return slivers;
  }

  String _displayName(User user) {
    final name = user.name?.trim();
    if (name != null && name.isNotEmpty) return name;
    return user.email.split('@').first;
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
    final l10n = AppLocalizations.of(context)!;
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
                l10n.profileRetry,
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
                l10n.profileErrorHeadline,
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

// ---------------------------------------------------------------------------
// Language picker
// ---------------------------------------------------------------------------

class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker({required this.accentColor});

  final Color accentColor;

  static const _locales = <(String, Locale?)>[
    ('languageSystemDefault', null),
    ('languageEnglish', Locale('en')),
    ('languageSpanish', Locale('es')),
    ('languagePortuguese', Locale('pt')),
    ('languageGerman', Locale('de')),
    ('languageRussian', Locale('ru')),
    ('languageBulgarian', Locale('bg')),
    ('languageJapanese', Locale('ja')),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = ServiceLocator.localeProvider;
    final current = provider.locale;

    String label(String key) => switch (key) {
          'languageSystemDefault' => l10n.languageSystemDefault,
          'languageEnglish' => l10n.languageEnglish,
          'languageSpanish' => l10n.languageSpanish,
          'languagePortuguese' => l10n.languagePortuguese,
          'languageGerman' => l10n.languageGerman,
          'languageRussian' => l10n.languageRussian,
          'languageBulgarian' => l10n.languageBulgarian,
          'languageJapanese' => l10n.languageJapanese,
          _ => key,
        };

    return Column(
      children: [
        SectionDivider(title: l10n.profileSectionLanguage),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              for (final (key, locale) in _locales)
                _LanguageOption(
                  label: label(key),
                  selected: current?.languageCode == locale?.languageCode,
                  accentColor: accentColor,
                  onTap: () => provider.setLocale(locale),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 20,
              color: selected ? accentColor : Colors.white.withAlpha(80),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: selected ? Colors.white : Colors.white.withAlpha(180),
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
