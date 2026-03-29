import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/guild/data/guild_repository.dart';
import 'package:swf_app/src/guild/models/guild.dart';
import 'package:swf_app/src/guild/presentation/guild_detail_page.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// "Guild Board" — paginated discovery of public guilds with infinite scroll.
///
/// Follows the same infinite-scroll pattern as [CatalogPage].
class DiscoverGuildsPage extends StatefulWidget {
  const DiscoverGuildsPage({super.key});

  @override
  State<DiscoverGuildsPage> createState() => _DiscoverGuildsPageState();
}

class _DiscoverGuildsPageState extends State<DiscoverGuildsPage> {
  late final GuildRepository _repo;
  final ScrollController _scrollController = ScrollController();

  List<Guild> _guilds = [];
  int _currentPage = 1;
  bool _hasNextPage = false;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _repo = ServiceLocator.guildRepository;
    _scrollController.addListener(_onScroll);
    _fetchGuilds(page: 1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchGuilds({required int page}) async {
    if (page == 1) {
      setState(() {
        _isLoading = true;
        _error = null;
        _isLoadingMore = false;
        _guilds = [];
        _currentPage = 1;
        _hasNextPage = false;
      });
    } else {
      setState(() => _isLoadingMore = true);
    }

    final result = await _repo.discoverGuilds(page: page);
    if (!mounted) return;

    result.when(
      success: (paginated) {
        setState(() {
          if (page == 1) {
            _guilds = paginated.items;
          } else {
            _guilds = [..._guilds, ...paginated.items];
          }
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

        if (_guilds.isNotEmpty && page != 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      },
    );
  }

  void _onScroll() {
    if (_isLoadingMore || !_hasNextPage) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchGuilds(page: _currentPage + 1);
    }
  }

  Future<void> _joinGuild(Guild guild) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await _repo.joinGuild(guild.id);
    if (!mounted) return;

    result.when(
      success: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.guildJoined)),
        );
        // Refresh the list to update state
        _fetchGuilds(page: 1);
      },
      failure: (message, statusCode) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  }

  void _openGuildDetail(Guild guild) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => GuildDetailPage(guild: guild),
      ),
    ).then((_) {
      if (mounted) _fetchGuilds(page: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: SwfColors.primaryBackground,
      appBar: AppBar(
        title: Text(
          l10n.guildDiscoverTitle,
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

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _guilds.isEmpty) {
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
            TextButton(
              onPressed: () => _fetchGuilds(page: 1),
              child: Text(l10n.catalogRetry),
            ),
          ],
        ),
      );
    }

    if (_guilds.isEmpty) {
      return Center(
        child: Text(
          l10n.guildDiscoverEmpty,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withAlpha(140),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _fetchGuilds(page: 1),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: _guilds.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _guilds.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          final guild = _guilds[index];
          return _DiscoverGuildCard(
            guild: guild,
            onJoin: () => _joinGuild(guild),
            onTap: () => _openGuildDetail(guild),
          );
        },
      ),
    );
  }
}

class _DiscoverGuildCard extends StatelessWidget {
  const _DiscoverGuildCard({
    required this.guild,
    required this.onJoin,
    required this.onTap,
  });

  final Guild guild;
  final VoidCallback onJoin;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    const accent = SwfColors.secondaryAccent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2235),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent.withAlpha(40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    guild.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.guildMemberCountLabel(guild.memberCount),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withAlpha(100),
                  ),
                ),
              ],
            ),
            if (guild.description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                guild.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withAlpha(140),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: accent,
                  side: BorderSide(color: accent.withAlpha(100)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onPressed: onJoin,
                child: Text(l10n.guildJoinButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
