import 'package:flutter/material.dart';
import 'package:swf_app/src/api/api_result.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/auth/data/auth_repository.dart';
import 'package:swf_app/src/auth/data/session_store.dart';
import 'package:swf_app/src/auth/models/user.dart';
import 'package:swf_app/src/auth/presentation/sign_up_flow.dart';
import 'package:swf_app/src/profile/data/profile_repository.dart';
import 'package:swf_app/src/profile/data/quest_compendium.dart';
import 'package:swf_app/src/profile/models/quest_campaign.dart';
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
  Set<String> _completedObjectiveIds = <String>{};
  Set<String> _revealedRewardIds = <String>{};

  QuestCampaign get _campaign => campaignForRole(_user?.role);

  bool get _isGuestState =>
      _user == null && (_errorStatusCode == 401 || _authRepository == null);

  int get _totalObjectives => _campaign.scrolls.fold<int>(
    0,
    (sum, scroll) => sum + scroll.objectives.length,
  );

  int get _completedObjectives => _completedObjectiveIds.length;

  double get _progress =>
      _totalObjectives == 0 ? 0 : _completedObjectives / _totalObjectives;

  String get _rankTitle {
    final titles = _campaign.rankTitles;
    if (_progress >= 1) return titles.last;
    if (_progress >= 0.67) return titles[2];
    if (_progress >= 0.34) return titles[1];
    return titles.first;
  }

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? _resolveAuthRepository();
    _profileRepository =
        widget.profileRepository ?? _resolveProfileRepository();
    _sessionStore = widget.sessionStore ?? _resolveSessionStore();
    _user = _sessionStore?.user;
    _isLoading = _user == null;

    if (_user?.role == 'author') {
      _loadSubscriberStats();
    }

    _loadProfile();
  }

  AuthRepository? _resolveAuthRepository() {
    try {
      return ServiceLocator.authRepository;
    } catch (_) {
      return null;
    }
  }

  ProfileRepository? _resolveProfileRepository() {
    try {
      return ServiceLocator.profileRepository;
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

  Future<void> _loadProfile() async {
    final authRepository = _authRepository;
    if (authRepository == null) {
      setState(() {
        _isLoading = false;
        if (_user == null) {
          _errorStatusCode = 401;
        }
      });
      return;
    }

    final result = await authRepository.getCurrentUser();
    if (!mounted) return;

    result.when(
      success: (user) {
        final previousRole = _campaign.role;
        setState(() {
          _user = user;
          _errorMessage = null;
          _errorStatusCode = null;
          _isLoading = false;
          if (previousRole != campaignForRole(user.role).role) {
            _completedObjectiveIds = <String>{};
            _revealedRewardIds = <String>{};
          }
        });
        if (user.role == 'author') {
          _loadSubscriberStats();
        } else {
          setState(() {
            _subscriberStats = null;
            _subscriberError = null;
            _isLoadingSubscriberStats = false;
          });
        }
      },
      failure: (message, statusCode) {
        setState(() {
          _user = _sessionStore?.user;
          _errorMessage = message;
          _errorStatusCode = statusCode;
          _isLoading = false;
          if (_user?.role != 'author') {
            _subscriberStats = null;
            _subscriberError = null;
            _isLoadingSubscriberStats = false;
          }
        });
      },
    );
  }

  Future<void> _loadSubscriberStats() async {
    if (_campaign.role != 'author') return;

    final profileRepository = _profileRepository;
    if (profileRepository == null) {
      setState(() {
        _subscriberStats = null;
        _subscriberError = null;
        _isLoadingSubscriberStats = false;
      });
      return;
    }

    setState(() {
      _isLoadingSubscriberStats = true;
      _subscriberError = null;
    });

    final result = await profileRepository.getSubscriberStats();
    if (!mounted) return;

    result.when(
      success: (stats) {
        setState(() {
          _subscriberStats = stats;
          _isLoadingSubscriberStats = false;
          _subscriberError = null;
        });
      },
      failure: (message, _) {
        setState(() {
          _subscriberStats = null;
          _isLoadingSubscriberStats = false;
          _subscriberError = message;
        });
      },
    );
  }

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
          MaterialPageRoute<void>(builder: (_) => const SignUpFlow()),
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
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const SignUpFlow()),
      (_) => false,
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
    if (_isScrollComplete(scroll) && _revealedRewardIds.add(scroll.reward.id)) {
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
        await _showRewardReveal(
          reward,
          isGrandReward: _campaign.finalReward?.id == reward.id,
        );
      });
    }
  }

  bool _isScrollComplete(QuestScroll scroll) {
    return scroll.objectives.every(
      (objective) => _completedObjectiveIds.contains(objective.id),
    );
  }

  bool get _allScrollsComplete =>
      _campaign.scrolls.every((scroll) => _isScrollComplete(scroll));

  Future<void> _showRewardReveal(
    QuestReward reward, {
    required bool isGrandReward,
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Reward reveal',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, _, _) => _RewardRevealDialog(
        reward: reward,
        accentColor: _campaign.accentColor,
        isGrandReward: isGrandReward,
      ),
      transitionBuilder: (_, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeIn,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: curved, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Field Journal')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF4F1EC), SwfColors.color8],
          ),
        ),
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading && _user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_isGuestState) {
      return _GuestGuildState(
        campaigns: guestCampaignPreview,
        onCreateAccount: _goToSignUp,
      );
    }

    if (_errorMessage != null && _user == null) {
      return _ProfileErrorState(message: _errorMessage!, onRetry: _loadProfile);
    }

    final user = _user!;

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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _QuestHero(
                    user: user,
                    campaign: _campaign,
                    progress: _progress,
                    rankTitle: _rankTitle,
                    completedObjectives: _completedObjectives,
                    totalObjectives: _totalObjectives,
                    onOpenReference: _campaign.referenceUrl != null
                        ? () => _openReference(_campaign.referenceUrl!)
                        : null,
                  ),
                  if (_campaign.role == 'author') ...[
                    const SizedBox(height: 18),
                    _SubscriberLedgerCard(
                      isUnlocked: _subscriberFeatureUnlocked,
                      stats: _subscriberStats,
                      isLoading: _isLoadingSubscriberStats,
                      errorMessage: _subscriberError,
                    ),
                  ],
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 18),
                    _InlineNotice(
                      message: _errorMessage!,
                      accentColor: _campaign.accentColor,
                      onRetry: _loadProfile,
                    ),
                  ],
                  const SizedBox(height: 18),
                  _SectionHeader(
                    title: 'Relic Shelf',
                    subtitle: 'Completed entries turn into collectible relics.',
                  ),
                  const SizedBox(height: 12),
                  _UnlockVault(
                    campaign: _campaign,
                    unlockedRewardIds: _revealedRewardIds,
                  ),
                  const SizedBox(height: 18),
                  _SectionHeader(
                    title: 'Character Sheet',
                    subtitle:
                        'Identity, rank, and guild standing written into the journal.',
                  ),
                  const SizedBox(height: 12),
                  _DossierCard(
                    name: _displayName(user),
                    email: user.email,
                    roleLabel: _roleLabel(user.role),
                    rankTitle: _rankTitle,
                  ),
                  const SizedBox(height: 20),
                  _SectionHeader(
                    title: 'Journal Entries',
                    subtitle:
                        'Seal each objective as you complete it and claim the relic tied to that entry.',
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final scroll = _campaign.scrolls[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == _campaign.scrolls.length - 1 ? 0 : 16,
                  ),
                  child: _QuestScrollCard(
                    scroll: scroll,
                    accentColor: _campaign.accentColor,
                    borderColor: _campaign.borderColor,
                    parchmentColor: _campaign.scrollColor,
                    completedCount: scroll.objectives
                        .where(
                          (objective) =>
                              _completedObjectiveIds.contains(objective.id),
                        )
                        .length,
                    isComplete: _isScrollComplete(scroll),
                    completedObjectiveIds: _completedObjectiveIds,
                    onToggleObjective: (objective) =>
                        _toggleObjective(scroll, objective),
                  ),
                );
              }, childCount: _campaign.scrolls.length),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: OutlinedButton.icon(
                onPressed: _isSigningOut ? null : _signOut,
                icon: _isSigningOut
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout_rounded),
                label: Text(
                  _isSigningOut ? 'Leaving the realm...' : 'Exit the Realm',
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

class _QuestHero extends StatelessWidget {
  const _QuestHero({
    required this.user,
    required this.campaign,
    required this.progress,
    required this.rankTitle,
    required this.completedObjectives,
    required this.totalObjectives,
    this.onOpenReference,
  });

  final User user;
  final QuestCampaign campaign;
  final double progress;
  final String rankTitle;
  final int completedObjectives;
  final int totalObjectives;
  final VoidCallback? onOpenReference;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = user.name?.trim().isNotEmpty == true
        ? user.name!.trim()
        : user.email.split('@').first;
    final initials = name
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.substring(0, 1))
        .join()
        .toUpperCase();

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: campaign.heroGradient,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
        border: Border.all(color: Colors.white24),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -18,
            right: -14,
            child: Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(20),
              ),
            ),
          ),
          Positioned(
            bottom: -28,
            left: -12,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: campaign.accentColor.withAlpha(45),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 18,
                    color: Colors.white.withAlpha(220),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Field Journal',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white.withAlpha(220),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                campaign.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                campaign.headline,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha(225),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: campaign.accentColor,
                    child: Text(
                      initials.isEmpty ? '?' : initials,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 240),
                          child: Text(
                            rankTitle,
                            key: ValueKey<String>(rankTitle),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withAlpha(220),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _HeroChip(
                    icon: Icons.shield_rounded,
                    label:
                        '$completedObjectives / $totalObjectives objectives complete',
                  ),
                  _HeroChip(
                    icon: Icons.auto_awesome_rounded,
                    label: campaign.progressLabel,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _QuestProgressBar(
                progress: progress,
                accentColor: campaign.accentColor,
              ),
              const SizedBox(height: 10),
              Text(
                campaign.flavorText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withAlpha(220),
                  height: 1.45,
                ),
              ),
              if (onOpenReference != null) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                  onPressed: onOpenReference,
                  icon: const Icon(Icons.menu_book_rounded),
                  label: Text(campaign.referenceLabel ?? 'Open reference'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withAlpha(28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _QuestProgressBar extends StatelessWidget {
  const _QuestProgressBar({required this.progress, required this.accentColor});

  final double progress;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 320),
      tween: Tween<double>(begin: 0, end: progress.clamp(0, 1)),
      builder: (context, animatedProgress, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                height: 12,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: Colors.white.withAlpha(30)),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: animatedProgress,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [accentColor, Colors.white],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(animatedProgress * 100).round()}% charged',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white.withAlpha(220),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SubscriberLedgerCard extends StatelessWidget {
  const _SubscriberLedgerCard({
    required this.isUnlocked,
    required this.stats,
    required this.isLoading,
    this.errorMessage,
  });

  final bool isUnlocked;
  final SubscriberStats? stats;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayValue = switch ((isUnlocked, stats, isLoading)) {
      (true, final SubscriberStats stats, _) => '${stats.active}',
      (true, null, true) => '--',
      _ => '???',
    };
    final detailText = switch ((isUnlocked, isLoading, errorMessage, stats)) {
      (true, true, _, _) => 'Counting your active subscribers...',
      (true, false, final String error, _) => error,
      (true, false, _, final SubscriberStats stats) =>
        '${stats.confirmed} confirmed, ${stats.unsubscribed} unsubscribed, ${stats.total} total records',
      _ =>
        'Paid feature. Unlock this relic to reveal your live subscriber count and the full subscriber list tools.',
    };

    return Container(
      key: const Key('subscriber-ledger-card'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: SwfColors.color2,
        border: Border.all(color: SwfColors.color6.withAlpha(130)),
      ),
      child: Row(
        children: [
          Container(
            width: 110,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Text(
                    displayValue,
                    key: ValueKey<String>(displayValue),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'subscriber count',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withAlpha(210),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Subscriber Ledger',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        isUnlocked ? 'Unlocked' : 'Locked upgrade',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  detailText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withAlpha(215),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.diamond_rounded,
              size: 16,
              color: SwfColors.color6,
            ),
            const SizedBox(width: 8),
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 1,
                color: SwfColors.color6.withAlpha(90),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _UnlockVault extends StatelessWidget {
  const _UnlockVault({required this.campaign, required this.unlockedRewardIds});

  final QuestCampaign campaign;
  final Set<String> unlockedRewardIds;

  @override
  Widget build(BuildContext context) {
    final rewards = <QuestReward>[
      ...campaign.scrolls.map((scroll) => scroll.reward),
      if (campaign.finalReward != null) campaign.finalReward!,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: rewards.map((reward) {
          final isUnlocked = unlockedRewardIds.contains(reward.id);
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _VaultRelic(
              reward: reward,
              accentColor: campaign.accentColor,
              isUnlocked: isUnlocked,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _VaultRelic extends StatelessWidget {
  const _VaultRelic({
    required this.reward,
    required this.accentColor,
    required this.isUnlocked,
  });

  final QuestReward reward;
  final Color accentColor;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      width: 168,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : Colors.white.withAlpha(180),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isUnlocked ? accentColor : SwfColors.color5,
          width: isUnlocked ? 2 : 1,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: accentColor.withAlpha(45),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : const [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isUnlocked ? accentColor.withAlpha(18) : SwfColors.color5,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isUnlocked
                    ? accentColor.withAlpha(80)
                    : SwfColors.color5.withAlpha(150),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isUnlocked ? reward.icon : Icons.lock_outline_rounded,
                  color: isUnlocked ? accentColor : SwfColors.mediumGray,
                ),
                const Spacer(),
                Text(
                  isUnlocked ? 'Owned' : 'Sealed',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isUnlocked
                        ? accentColor
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            reward.title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: isUnlocked
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isUnlocked ? reward.description : 'Still sealed inside the vault.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _DossierCard extends StatelessWidget {
  const _DossierCard({
    required this.name,
    required this.email,
    required this.roleLabel,
    required this.rankTitle,
  });

  final String name;
  final String email;
  final String roleLabel;
  final String rankTitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _DossierRow(label: 'Name', value: name),
            _DossierRow(label: 'Guild', value: roleLabel),
            _DossierRow(label: 'Rank', value: rankTitle),
            _DossierRow(label: 'Signal', value: email, isLast: true),
          ],
        ),
      ),
    );
  }
}

class _DossierRow extends StatelessWidget {
  const _DossierRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 78,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}

class _QuestScrollCard extends StatelessWidget {
  const _QuestScrollCard({
    required this.scroll,
    required this.accentColor,
    required this.borderColor,
    required this.parchmentColor,
    required this.completedCount,
    required this.isComplete,
    required this.completedObjectiveIds,
    required this.onToggleObjective,
  });

  final QuestScroll scroll;
  final Color accentColor;
  final Color borderColor;
  final Color parchmentColor;
  final int completedCount;
  final bool isComplete;
  final Set<String> completedObjectiveIds;
  final ValueChanged<QuestObjective> onToggleObjective;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: parchmentColor,
        border: Border.all(
          color: isComplete ? borderColor : borderColor.withAlpha(90),
          width: isComplete ? 2 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isComplete
                ? borderColor.withAlpha(34)
                : const Color(0x15000000),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 14,
            right: 14,
            child: Icon(
              Icons.diamond_rounded,
              size: 18,
              color: borderColor.withAlpha(90),
            ),
          ),
          Positioned(
            bottom: 14,
            left: 14,
            child: Icon(
              Icons.diamond_rounded,
              size: 18,
              color: borderColor.withAlpha(90),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                decoration: BoxDecoration(
                  color: SwfColors.color2.withAlpha(210),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withAlpha(34),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        scroll.chapterLabel,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$completedCount / ${scroll.objectives.length}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white.withAlpha(210),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(scroll.title, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(
                      scroll.summary,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(150),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: accentColor.withAlpha(60)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accentColor.withAlpha(26),
                            ),
                            child: Icon(scroll.reward.icon, color: accentColor),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  scroll.reward.title,
                                  style: theme.textTheme.titleSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  scroll.reward.description,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isComplete)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Unlocked',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...scroll.objectives.map(
                      (objective) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _QuestObjectiveTile(
                          objective: objective,
                          accentColor: accentColor,
                          isComplete: completedObjectiveIds.contains(
                            objective.id,
                          ),
                          onTap: () => onToggleObjective(objective),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuestObjectiveTile extends StatelessWidget {
  const _QuestObjectiveTile({
    required this.objective,
    required this.accentColor,
    required this.isComplete,
    required this.onTap,
  });

  final QuestObjective objective;
  final Color accentColor;
  final bool isComplete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('quest-toggle-${objective.id}'),
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isComplete
                ? accentColor.withAlpha(20)
                : Colors.white.withAlpha(120),
            border: Border.all(
              color: isComplete ? accentColor : SwfColors.color5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isComplete ? accentColor : Colors.white,
                  border: Border.all(color: accentColor),
                ),
                child: Icon(
                  isComplete ? Icons.check_rounded : Icons.circle_outlined,
                  size: 16,
                  color: isComplete ? Colors.white : accentColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      objective.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        decoration: isComplete
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      objective.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accentColor.withAlpha(20),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withAlpha(70)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: accentColor),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _GuestGuildState extends StatelessWidget {
  const _GuestGuildState({
    required this.campaigns,
    required this.onCreateAccount,
  });

  final List<QuestCampaign> campaigns;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [SwfColors.color2, SwfColors.color7, SwfColors.color3],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your guild path',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Profile is not a settings drawer here. It is the campaign board for whatever kind of fantasy traveler you are becoming.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha(220),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onCreateAccount,
                  child: const Text('Create account to begin'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ...campaigns.map(
          (campaign) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(campaign.title, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      campaign.headline,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: campaign.scrolls
                          .map(
                            (scroll) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: campaign.accentColor.withAlpha(18),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                scroll.reward.title,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: campaign.accentColor,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileErrorState extends StatelessWidget {
  const _ProfileErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 42,
                  color: SwfColors.color4,
                ),
                const SizedBox(height: 16),
                Text(
                  'The quest board failed to load',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardRevealDialog extends StatelessWidget {
  const _RewardRevealDialog({
    required this.reward,
    required this.accentColor,
    required this.isGrandReward,
  });

  final QuestReward reward;
  final Color accentColor;
  final bool isGrandReward;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 26, 24, 22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [SwfColors.color2, accentColor, SwfColors.color3],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -10,
                  right: -8,
                  child: Icon(
                    Icons.auto_awesome,
                    size: 72,
                    color: Colors.white.withAlpha(22),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.8, end: 1),
                      duration: const Duration(milliseconds: 420),
                      curve: Curves.elasticOut,
                      builder: (context, scale, child) {
                        return Transform.scale(scale: scale, child: child);
                      },
                      child: Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withAlpha(22),
                          border: Border.all(color: Colors.white.withAlpha(40)),
                        ),
                        child: Icon(reward.icon, size: 40, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isGrandReward
                          ? 'Legend Reward Claimed'
                          : 'Relic Unlocked',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white.withAlpha(220),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      reward.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      reward.description,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withAlpha(225),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: SwfColors.color2,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Continue questing'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
