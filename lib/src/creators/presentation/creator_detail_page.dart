import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/catalog/presentation/book_detail_page.dart';
import 'package:swf_app/src/catalog/presentation/widgets/book_tile.dart';
import 'package:swf_app/src/creators/models/creator.dart';
import 'package:swf_app/src/creators/models/social_links.dart';
import 'package:swf_app/src/theme/swf_colors.dart';
import 'package:url_launcher/url_launcher.dart';

/// Full-screen profile for an author or influencer.
///
/// Opens with the minimal [Creator] from the featured row, then fetches the
/// full detail (bio, books, social links) in the background.
class CreatorDetailPage extends StatefulWidget {
  const CreatorDetailPage({super.key, required this.creator});

  final Creator creator;

  @override
  State<CreatorDetailPage> createState() => _CreatorDetailPageState();
}

class _CreatorDetailPageState extends State<CreatorDetailPage> {
  late Creator _creator = widget.creator;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    final result = await ServiceLocator.creatorRepository
        .getCreator(_creator.slug.isNotEmpty ? _creator.slug : _creator.id);
    if (!mounted) return;

    result.when(
      success: (creator) => setState(() {
        _creator = creator;
        _isLoading = false;
      }),
      failure: (message, _) => setState(() {
        _error = message;
        _isLoading = false;
      }),
    );
  }

  Future<void> _openLink(String url) async {
    var resolved = url;
    if (!resolved.startsWith('http')) resolved = 'https://$resolved';
    final uri = Uri.tryParse(resolved);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final ringColor =
        _creator.role.isAuthor ? SwfColors.color6 : SwfColors.blueBright;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App bar ──
          SliverAppBar(
            pinned: true,
            backgroundColor: SwfColors.brandDark,
            foregroundColor: SwfColors.color8,
            title: Text(
              _creator.name,
              style: theme.textTheme.titleMedium?.copyWith(
                color: SwfColors.color8,
              ),
            ),
          ),

          // ── Hero section ──
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [SwfColors.brandDark, SwfColors.primaryBackground],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                children: [
                  // Avatar with ring
                  Container(
                    width: 96,
                    height: 96,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ringColor, width: 2.5),
                    ),
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: SwfColors.color5,
                      backgroundImage: _creator.imageUrl.isNotEmpty
                          ? NetworkImage(_creator.imageUrl)
                          : null,
                      child: _creator.imageUrl.isEmpty
                          ? Text(
                              _creator.name.isNotEmpty
                                  ? _creator.name.substring(0, 1).toUpperCase()
                                  : '?',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: SwfColors.color3,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Name
                  Text(
                    _creator.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: SwfColors.color8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Role badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: ringColor.withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ringColor.withAlpha(80)),
                    ),
                    child: Text(
                      _creator.role.localizedLabel(l10n),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: ringColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bio
                  if (_creator.bio.isNotEmpty)
                    Text(
                      _creator.bio,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: SwfColors.color8.withAlpha(200),
                        height: 1.5,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Social links ──
          if (!_creator.socialLinks.isEmpty)
            SliverToBoxAdapter(
              child: _SocialLinksRow(
                socialLinks: _creator.socialLinks,
                onTap: _openLink,
              ),
            ),

          // ── Favorites line ──
          if (_creator.favoriteBook.isNotEmpty ||
              _creator.favoriteSubgenres.isNotEmpty)
            SliverToBoxAdapter(
              child: _FavoritesSection(creator: _creator),
            ),

          // ── Loading / error ──
          if (_isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),

          if (_error != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    _error!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),

          // ── Books grid ──
          if (!_isLoading && _creator.displayBooks.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text(
                  _creator.localizedBooksLabel(l10n),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: _BooksGrid(
                books: _creator.displayBooks,
                onBookTap: (book) => Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => BookDetailPage(book: book),
                  ),
                ),
              ),
            ),
          ],

          // ── Empty state for books ──
          if (!_isLoading && _error == null && _creator.displayBooks.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    l10n.creatorDetailNoBooksYet,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Social links row
// ─────────────────────────────────────────────────────────────────────────────

class _SocialLinksRow extends StatelessWidget {
  const _SocialLinksRow({required this.socialLinks, required this.onTap});

  final SocialLinks socialLinks;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entries = <_SocialEntry>[
      if (socialLinks.tiktok.isNotEmpty)
        _SocialEntry(l10n.socialLinkTiktok, Icons.music_note_rounded, socialLinks.tiktok),
      if (socialLinks.instagram.isNotEmpty)
        _SocialEntry(
            l10n.socialLinkInstagram, Icons.camera_alt_rounded, socialLinks.instagram),
      if (socialLinks.youtube.isNotEmpty)
        _SocialEntry(
            l10n.socialLinkYoutube, Icons.play_circle_outline_rounded, socialLinks.youtube),
      if (socialLinks.threads.isNotEmpty)
        _SocialEntry(l10n.socialLinkThreads, Icons.alternate_email_rounded,
            socialLinks.threads),
      if (socialLinks.goodreads.isNotEmpty)
        _SocialEntry(
            l10n.socialLinkGoodreads, Icons.menu_book_rounded, socialLinks.goodreads),
      if (socialLinks.storygraph.isNotEmpty)
        _SocialEntry(
            l10n.socialLinkStorygraph, Icons.auto_graph_rounded, socialLinks.storygraph),
      if (socialLinks.bookbub.isNotEmpty)
        _SocialEntry(
            l10n.socialLinkBookbub, Icons.notifications_rounded, socialLinks.bookbub),
      if (socialLinks.facebook.isNotEmpty)
        _SocialEntry(l10n.socialLinkFacebook, Icons.people_rounded, socialLinks.facebook),
      if (socialLinks.website.isNotEmpty)
        _SocialEntry(l10n.socialLinkWebsite, Icons.language_rounded, socialLinks.website),
    ];

    if (entries.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: entries
            .map((e) => _SocialChip(entry: e, onTap: () => onTap(e.url)))
            .toList(),
      ),
    );
  }
}

class _SocialEntry {
  const _SocialEntry(this.label, this.icon, this.url);
  final String label;
  final IconData icon;
  final String url;
}

class _SocialChip extends StatelessWidget {
  const _SocialChip({required this.entry, required this.onTap});

  final _SocialEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: SwfColors.color3.withAlpha(80),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(entry.icon, size: 14, color: SwfColors.color8),
              const SizedBox(width: 5),
              Text(
                entry.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: SwfColors.color8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Favorites section
// ─────────────────────────────────────────────────────────────────────────────

class _FavoritesSection extends StatelessWidget {
  const _FavoritesSection({required this.creator});

  final Creator creator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (creator.favoriteBook.isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.favorite_rounded,
                    size: 16, color: SwfColors.color4),
                const SizedBox(width: 6),
                Expanded(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: l10n.creatorDetailFavoriteBookLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: creator.favoriteBook,
                        style: theme.textTheme.bodySmall,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (creator.favoriteSubgenres.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.auto_awesome_rounded,
                    size: 16, color: SwfColors.color6),
                const SizedBox(width: 6),
                Expanded(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: l10n.creatorDetailLovesLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: creator.favoriteSubgenres,
                        style: theme.textTheme.bodySmall,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Books grid (reuses BookTile)
// ─────────────────────────────────────────────────────────────────────────────

class _BooksGrid extends StatelessWidget {
  const _BooksGrid({required this.books, required this.onBookTap});

  final List<Book> books;
  final ValueChanged<Book> onBookTap;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final book = books[index];
          return BookTile(
            book: book,
            onTap: () => onBookTap(book),
          );
        },
        childCount: books.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.sizeOf(context).width >= 600 ? 3 : 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.48,
      ),
    );
  }
}
