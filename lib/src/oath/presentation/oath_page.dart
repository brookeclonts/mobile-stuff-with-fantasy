import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/auth/presentation/sign_up_flow.dart';
import 'package:swf_app/src/oath/data/oath_repository.dart';
import 'package:swf_app/src/oath/models/book_oath.dart';
import 'package:swf_app/src/oath/presentation/swear_oath_page.dart';
import 'package:swf_app/src/oath/presentation/widgets/oath_entry_tile.dart';
import 'package:swf_app/src/oath/presentation/widgets/oath_progress_bar.dart';
import 'package:swf_app/src/profile/presentation/widgets/guest_guild_state.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Full-page view of the user's book oath.
///
/// Shows oath progress, logged entries, and management actions.
/// If no oath exists, displays a CTA to swear one.
class OathPage extends StatefulWidget {
  const OathPage({super.key});

  @override
  State<OathPage> createState() => _OathPageState();
}

class _OathPageState extends State<OathPage> {
  late final OathRepository _repo;
  BookOath? _oath;
  bool _isLoading = true;
  String? _error;

  bool get _isAuthenticated => ServiceLocator.sessionStore.isAuthenticated;

  @override
  void initState() {
    super.initState();
    _repo = ServiceLocator.oathRepository;
    _loadOath();
  }

  Future<void> _loadOath() async {
    if (!_isAuthenticated) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _repo.fetchMyOath(forceRefresh: true);
    if (!mounted) return;

    result.when(
      success: (oath) {
        setState(() {
          _oath = oath;
          _isLoading = false;
        });
      },
      failure: (message, _) {
        setState(() {
          _error = message;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _removeEntry(OathEntry entry) async {
    final oath = _oath;
    if (oath == null) return;

    final result = await _repo.removeEntry(
      oath.id,
      entryId: entry.id,
    );
    if (!mounted) return;

    result.when(
      success: (updated) {
        setState(() => _oath = updated);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.oathEntryRemoved)),
        );
      },
      failure: (message, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  }

  Future<void> _deleteOath() async {
    final l10n = AppLocalizations.of(context)!;
    final oath = _oath;
    if (oath == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2235),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.red.withAlpha(80)),
        ),
        title: Text(
          l10n.oathDeleteConfirmTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        content: Text(
          l10n.oathDeleteConfirmBody,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withAlpha(180),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.oathDeleteCancel,
              style: TextStyle(color: Colors.white.withAlpha(140)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.oathDeleteConfirm,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final result = await _repo.deleteOath(oath.id);
    if (!mounted) return;

    result.when(
      success: (_) {
        setState(() => _oath = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.oathDeleted)),
        );
      },
      failure: (message, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  }

  void _goToSwearOath() async {
    final created = await Navigator.push<BookOath>(
      context,
      MaterialPageRoute<BookOath>(builder: (_) => const SwearOathPage()),
    );
    if (created != null && mounted) {
      setState(() => _oath = created);
    }
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
          l10n.oathAppBarTitle,
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
    final l10n = AppLocalizations.of(context)!;

    if (!_isAuthenticated) {
      return GuestGuildState(onCreateAccount: _goToSignUp);
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withAlpha(140),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: _loadOath, child: Text(l10n.catalogRetry)),
          ],
        ),
      );
    }

    final oath = _oath;
    if (oath == null) {
      return _EmptyOathState(
        onSwear: _goToSwearOath,
      );
    }

    return _OathContent(
      oath: oath,
      onRemoveEntry: _removeEntry,
      onDelete: _deleteOath,
      onRefresh: _loadOath,
    );
  }
}

class _EmptyOathState extends StatelessWidget {
  const _EmptyOathState({required this.onSwear});

  final VoidCallback onSwear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SwfColors.secondaryAccent.withAlpha(20),
                border: Border.all(
                  color: SwfColors.secondaryAccent.withAlpha(50),
                ),
              ),
              child: Icon(
                Icons.auto_stories_rounded,
                size: 36,
                color: SwfColors.secondaryAccent.withAlpha(140),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.oathGuestHeadline,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.oathSwearSubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withAlpha(160),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onSwear,
              child: Text(l10n.oathSwearCta),
            ),
          ],
        ),
      ),
    );
  }
}

class _OathContent extends StatelessWidget {
  const _OathContent({
    required this.oath,
    required this.onRemoveEntry,
    required this.onDelete,
    required this.onRefresh,
  });

  final BookOath oath;
  final ValueChanged<OathEntry> onRemoveEntry;
  final VoidCallback onDelete;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    const accent = SwfColors.secondaryAccent;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Header — oath title + progress
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_stories_rounded,
                        size: 20,
                        color: accent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.oathSectionTitle.toUpperCase(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: accent,
                          letterSpacing: 2.0,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    oath.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  OathProgressBar(
                    progress: oath.progress,
                    accentColor: accent,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.oathProgressLabel(
                          oath.currentCount,
                          oath.targetCount,
                        ),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (oath.isComplete)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            l10n.oathProgressComplete,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Divider
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white.withAlpha(15),
              ),
            ),
          ),

          // Entries
          if (oath.entries.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Text(
                  l10n.oathEmptyEntries,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withAlpha(100),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = oath.entries[index];
                    return OathEntryTile(
                      entry: entry,
                      index: index,
                      accentColor: accent,
                      onRemove: () => onRemoveEntry(entry),
                    );
                  },
                  childCount: oath.entries.length,
                ),
              ),
            ),

          // Delete button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 40),
              child: Center(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red.withAlpha(140),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                  ),
                  onPressed: onDelete,
                  icon: const Icon(Icons.link_off_rounded, size: 18),
                  label: Text(l10n.oathDeleteConfirm),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
