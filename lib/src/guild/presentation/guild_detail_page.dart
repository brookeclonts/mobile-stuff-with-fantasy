import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/guild/data/guild_repository.dart';
import 'package:swf_app/src/guild/models/guild.dart';
import 'package:swf_app/src/guild/presentation/widgets/companion_row.dart';
import 'package:swf_app/src/guild/presentation/widgets/party_ledger_section.dart';
import 'package:swf_app/src/profile/presentation/widgets/section_divider.dart';
import 'package:swf_app/src/profile/presentation/widgets/staggered_fade_slide.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// "Guild Chamber" — detail view for a single guild.
///
/// Shows guild name, description, member list with role badges,
/// party ledger, and management actions.
class GuildDetailPage extends StatefulWidget {
  const GuildDetailPage({
    super.key,
    required this.guild,
  });

  final Guild guild;

  @override
  State<GuildDetailPage> createState() => _GuildDetailPageState();
}

class _GuildDetailPageState extends State<GuildDetailPage> {
  late final GuildRepository _repo;
  late Guild _guild;
  bool _isLoading = true;
  String? _error;

  String get _currentUserId =>
      ServiceLocator.sessionStore.user?.id ?? '';

  bool get _isMember => _guild.members.any((m) => m.userId == _currentUserId);

  bool get _isGuildmaster =>
      _guild.members.any(
        (m) => m.userId == _currentUserId && m.role == 'guildmaster',
      ) ||
      _guild.createdBy == _currentUserId;

  @override
  void initState() {
    super.initState();
    _repo = ServiceLocator.guildRepository;
    _guild = widget.guild;
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _repo.fetchGuildDetail(_guild.id);
    if (!mounted) return;

    result.when(
      success: (guild) {
        setState(() {
          _guild = guild;
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

  Future<void> _leaveGuild() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await _repo.leaveGuild(_guild.id);
    if (!mounted) return;

    result.when(
      success: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.guildLeft)),
        );
        Navigator.pop(context);
      },
      failure: (message, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  }

  Future<void> _deleteGuild() async {
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
          l10n.guildDeleteConfirmTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        content: Text(
          l10n.guildDeleteConfirmBody,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withAlpha(180),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.guildDeleteCancel,
              style: TextStyle(color: Colors.white.withAlpha(140)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.guildDeleteConfirm,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final result = await _repo.deleteGuild(_guild.id);
    if (!mounted) return;

    result.when(
      success: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.guildDeleted)),
        );
        Navigator.pop(context);
      },
      failure: (message, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  }

  Future<void> _removeFromLedger(GuildLedgerEntry entry) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await _repo.removeFromLedger(
      _guild.id,
      bookId: entry.bookId,
    );
    if (!mounted) return;

    result.when(
      success: (updated) {
        setState(() => _guild = updated);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.guildBookRemoved)),
        );
      },
      failure: (message, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: SwfColors.primaryBackground,
      appBar: AppBar(
        title: Text(
          _guild.name,
          style: GoogleFonts.playfairDisplay(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _error!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white.withAlpha(140)),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _loadDetail,
                        child: Text(l10n.catalogRetry),
                      ),
                    ],
                  ),
                )
              : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    const accent = SwfColors.secondaryAccent;

    return RefreshIndicator(
      onRefresh: _loadDetail,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: Duration.zero,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.shield_rounded,
                          size: 20,
                          color: accent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.guildMemberCountLabel(_guild.memberCount),
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: accent,
                            letterSpacing: 2.0,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    if (_guild.description.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        _guild.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withAlpha(180),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Companions section
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 100),
              child: SectionDivider(
                title: l10n.guildDetailCompanions,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 150),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CompanionRow(members: _guild.members),
              ),
            ),
          ),

          // Ledger section
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 200),
              child: SectionDivider(
                title: l10n.guildDetailLedger,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StaggeredFadeSlide(
              delay: const Duration(milliseconds: 250),
              child: PartyLedgerSection(
                ledger: _guild.ledger,
                onRemove: _isMember ? _removeFromLedger : null,
              ),
            ),
          ),

          // Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
              child: Column(
                children: [
                  if (_isMember && !_isGuildmaster)
                    Center(
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red.withAlpha(140),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                        ),
                        onPressed: _leaveGuild,
                        icon: const Icon(Icons.logout_rounded, size: 18),
                        label: Text(l10n.guildLeaveButton),
                      ),
                    ),
                  if (_isGuildmaster)
                    Center(
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red.withAlpha(140),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                        ),
                        onPressed: _deleteGuild,
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        label: Text(l10n.guildDeleteConfirm),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
