import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/auth/presentation/sign_up_flow.dart';
import 'package:swf_app/src/guild/data/guild_repository.dart';
import 'package:swf_app/src/guild/models/guild.dart';
import 'package:swf_app/src/guild/presentation/create_guild_page.dart';
import 'package:swf_app/src/guild/presentation/discover_guilds_page.dart';
import 'package:swf_app/src/guild/presentation/guild_detail_page.dart';
import 'package:swf_app/src/guild/presentation/widgets/guild_card.dart';
import 'package:swf_app/src/profile/presentation/widgets/guest_guild_state.dart';
import 'package:swf_app/src/profile/presentation/widgets/staggered_fade_slide.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// "The Guild Hall" — hub page showing the user's guilds, with links to
/// create or discover guilds.
class GuildHubPage extends StatefulWidget {
  const GuildHubPage({super.key});

  @override
  State<GuildHubPage> createState() => _GuildHubPageState();
}

class _GuildHubPageState extends State<GuildHubPage> {
  late final GuildRepository _repo;
  List<Guild> _guilds = [];
  bool _isLoading = true;
  String? _error;

  bool get _isAuthenticated => ServiceLocator.sessionStore.isAuthenticated;

  @override
  void initState() {
    super.initState();
    _repo = ServiceLocator.guildRepository;
    _loadGuilds();
  }

  Future<void> _loadGuilds() async {
    if (!_isAuthenticated) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _repo.fetchMyGuilds(forceRefresh: true);
    if (!mounted) return;

    result.when(
      success: (guilds) {
        setState(() {
          _guilds = guilds;
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

  void _goToSignUp() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const SignUpFlow()),
    );
  }

  Future<void> _goToCreateGuild() async {
    final created = await Navigator.push<Guild>(
      context,
      MaterialPageRoute<Guild>(builder: (_) => const CreateGuildPage()),
    );
    if (created != null && mounted) {
      setState(() => _guilds = [..._guilds, created]);
    }
  }

  void _goToDiscoverGuilds() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const DiscoverGuildsPage()),
    ).then((_) {
      if (mounted) _loadGuilds();
    });
  }

  void _goToGuildDetail(Guild guild) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => GuildDetailPage(guild: guild),
      ),
    ).then((_) {
      if (mounted) _loadGuilds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: SwfColors.primaryBackground,
      appBar: AppBar(
        title: Text(
          l10n.guildHubTitle,
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
            TextButton(onPressed: _loadGuilds, child: Text(l10n.catalogRetry)),
          ],
        ),
      );
    }

    if (_guilds.isEmpty) {
      return _EmptyGuildState(
        onCreateGuild: _goToCreateGuild,
        onDiscover: _goToDiscoverGuilds,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadGuilds,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          // Guild list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final guild = _guilds[index];
                return StaggeredFadeSlide(
                  delay: Duration(milliseconds: 80 * index),
                  child: GuildCard(
                    guild: guild,
                    onTap: () => _goToGuildDetail(guild),
                  ),
                );
              },
              childCount: _guilds.length,
            ),
          ),
          // Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _goToCreateGuild,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(l10n.guildCreateButton),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: TextButton(
                onPressed: _goToDiscoverGuilds,
                child: Text(
                  l10n.guildDiscoverButton,
                  style: TextStyle(
                    color: SwfColors.secondaryAccent.withAlpha(200),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class _EmptyGuildState extends StatelessWidget {
  const _EmptyGuildState({
    required this.onCreateGuild,
    required this.onDiscover,
  });

  final VoidCallback onCreateGuild;
  final VoidCallback onDiscover;

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
                Icons.shield_rounded,
                size: 36,
                color: SwfColors.secondaryAccent.withAlpha(140),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.guildGuestHeadline,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.guildHubEmpty,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withAlpha(160),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCreateGuild,
                child: Text(l10n.guildCreateButton),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onDiscover,
              child: Text(
                l10n.guildDiscoverButton,
                style: TextStyle(
                  color: SwfColors.secondaryAccent.withAlpha(200),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
