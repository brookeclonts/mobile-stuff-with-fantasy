import 'package:flutter/material.dart';
import 'package:swf_app/l10n/app_localizations.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/reader/models/readable_book.dart';
import 'package:swf_app/src/reader/presentation/reader_launcher.dart';
import 'package:swf_app/src/oath/models/book_oath.dart';
import 'package:swf_app/src/theme/swf_colors.dart';
import 'package:url_launcher/url_launcher.dart';

/// Full-screen detail view for a single book.
///
/// Opens with the catalog-list [Book] for instant display, then fetches the
/// fully-populated detail in the background (for complete description, etc.).
class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key, required this.book});

  final Book book;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late Book _book = widget.book;
  List<Book> _similarBooks = [];
  bool _descriptionExpanded = false;
  bool _isSaved = false;
  BookReadAccess? _readAccess;
  bool _readBusy = false;
  bool _saveBusy = false;
  bool _oathLogBusy = false;

  BookOath? get _activeOath => ServiceLocator.oathRepository.cachedOath;

  bool get _isLoggedToOath {
    final oath = _activeOath;
    if (oath == null) return false;
    return oath.entries.any((e) => e.bookId == _book.id);
  }

  @override
  void initState() {
    super.initState();
    _isSaved = ServiceLocator.readingListRepository.contains(widget.book.id);
    _loadFullDetail();
    _loadSimilarBooks();
    _syncReadingListState();
    _loadReadAccess();
  }

  Future<void> _loadFullDetail() async {
    final result = await ServiceLocator.bookRepository.getBook(widget.book.id);
    if (!mounted) return;
    result.when(
      success: (book) => setState(() => _book = book),
      failure: (_, _) {},
    );
  }

  Future<void> _loadSimilarBooks() async {
    final result = await ServiceLocator.bookRepository.getSimilarBooks(
      widget.book.id,
    );
    if (!mounted) return;
    result.when(
      success: (books) => setState(() => _similarBooks = books),
      failure: (_, _) {},
    );
  }

  Future<void> _openLink(String url) async {
    var uri = Uri.tryParse(url);
    if (uri == null) return;
    // Append Amazon affiliate tag to Amazon links.
    if (uri.host.contains('amazon.')) {
      uri = uri.replace(
        queryParameters: {...uri.queryParameters, 'tag': 'stuffwithfant-20'},
      );
    }
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _syncReadingListState() async {
    if (!ServiceLocator.sessionStore.isAuthenticated) return;

    final result = await ServiceLocator.readingListRepository
        .fetchReadingList();
    if (!mounted) return;

    result.when(
      success: (_) {
        setState(() {
          _isSaved = ServiceLocator.readingListRepository.contains(_book.id);
        });
      },
      failure: (message, statusCode) {},
    );
  }

  Future<void> _loadReadAccess() async {
    if (!ServiceLocator.sessionStore.isAuthenticated) return;

    final result = await ServiceLocator.readerAccessRepository.checkAccess(
      widget.book.id,
    );
    if (!mounted) return;

    result.when(
      success: (access) {
        setState(() => _readAccess = access);
      },
      failure: (_, _) {},
    );
  }

  Future<void> _toggleReadingList() async {
    if (!ServiceLocator.sessionStore.isAuthenticated) {
      _showSignUpPrompt();
      return;
    }

    setState(() => _saveBusy = true);
    final result = _isSaved
        ? await ServiceLocator.readingListRepository.remove(_book.id)
        : await ServiceLocator.readingListRepository.save(_book);
    if (!mounted) return;

    result.when(
      success: (_) {
        setState(() {
          _isSaved = ServiceLocator.readingListRepository.contains(_book.id);
          _saveBusy = false;
        });
      },
      failure: (message, statusCode) {
        setState(() => _saveBusy = false);
        if (statusCode == 401) {
          _showSignUpPrompt();
          return;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }

  Future<void> _openReader() async {
    if (_readAccess?.hasAccess != true || _readBusy) return;

    setState(() => _readBusy = true);
    await openBookReader(context, book: _book);
    if (!mounted) return;
    setState(() => _readBusy = false);
  }

  Future<void> _logToOath() async {
    final oath = _activeOath;
    if (oath == null || _oathLogBusy) return;

    final l10n = AppLocalizations.of(context)!;

    if (_isLoggedToOath) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.oathAlreadyLogged)),
      );
      return;
    }

    setState(() => _oathLogBusy = true);

    final result = await ServiceLocator.oathRepository.logEntry(
      oath.id,
      bookId: _book.id,
      bookTitle: _book.title,
    );

    if (!mounted) return;

    result.when(
      success: (_) {
        setState(() => _oathLogBusy = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.oathEntryLogged)),
        );
      },
      failure: (message, _) {
        setState(() => _oathLogBusy = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  }

  void _showSignUpPrompt() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.bookDetailSignUpPrompt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Collapsing cover header ──
          SliverAppBar(
            expandedHeight: screenWidth * 0.85,
            pinned: true,
            backgroundColor: SwfColors.brandDark,
            foregroundColor: SwfColors.color8,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (_book.imageUrl.isNotEmpty)
                    Image.network(
                      _book.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _buildCoverFallback(theme),
                    )
                  else
                    _buildCoverFallback(theme),
                  // Gradient scrim for readability
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black26,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black54,
                        ],
                        stops: [0.0, 0.2, 0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Body content ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(_book.title, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    l10n.bookDetailByAuthor(_book.authorName),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick stats row
                  _StatsRow(book: _book),
                  const SizedBox(height: 20),

                  if (_readAccess?.hasAccess == true) ...[
                    _ReadInAppButton(
                      isLoading: _readBusy,
                      onPressed: _openReader,
                    ),
                    const SizedBox(height: 12),
                  ],

                  _ReadingListButton(
                    isSaved: _isSaved,
                    isLoading: _saveBusy,
                    onPressed: _toggleReadingList,
                  ),

                  // Log toward Oath (only if user has an active, incomplete oath)
                  if (_activeOath != null && !_activeOath!.isComplete && !_isLoggedToOath) ...[
                    const SizedBox(height: 8),
                    _OathLogButton(
                      isLoading: _oathLogBusy,
                      onPressed: _logToOath,
                    ),
                  ],
                  const SizedBox(height: 12),

                  // Action buttons
                  _ActionButtons(book: _book, onOpenLink: _openLink),
                  const SizedBox(height: 24),

                  // Subgenres
                  if (_book.subgenres.isNotEmpty) ...[
                    _SectionLabel(label: l10n.bookDetailSectionSubgenres),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _book.subgenres
                          .map(
                            (s) => _Chip(
                              label: s,
                              color: SwfColors.spicinessPill,
                              textColor: SwfColors.color3,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Tropes
                  if (_book.tropes.isNotEmpty) ...[
                    _SectionLabel(label: l10n.bookDetailSectionTropes),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _book.tropes
                          .map(
                            (t) => _Chip(
                              label: t,
                              color: SwfColors.tropePill,
                              textColor: SwfColors.color3,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Representations
                  if (_book.representations.isNotEmpty) ...[
                    _SectionLabel(label: l10n.bookDetailSectionRepresentation),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _book.representations
                          .map(
                            (r) => _Chip(
                              label: r,
                              color: SwfColors.representationPill,
                              textColor: SwfColors.color7,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Description
                  if (_book.description.isNotEmpty) ...[
                    _SectionLabel(label: l10n.bookDetailSectionAbout),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => setState(
                        () => _descriptionExpanded = !_descriptionExpanded,
                      ),
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 250),
                        crossFadeState: _descriptionExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _book.description,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.bookDetailReadMore,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        secondChild: Text(
                          _book.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),

          // ── Similar books ──
          if (_similarBooks.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: _SectionLabel(label: l10n.bookDetailSectionSimilar),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _similarBooks.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final similar = _similarBooks[index];
                    return _SimilarBookCard(
                      book: similar,
                      onTap: () => Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => BookDetailPage(book: similar),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],

          // Bottom padding
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }

  Widget _buildCoverFallback(ThemeData theme) {
    const palettes = [
      [SwfColors.color2, SwfColors.color3],
      [SwfColors.color7, SwfColors.color3],
      [SwfColors.darkNavy, SwfColors.color4],
    ];
    final colors = palettes[_book.id.hashCode.abs() % palettes.length];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Text(
          _book.title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats row — spice, age, language in compact indicators
// ─────────────────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final dividerColor = isDark ? SwfColors.color3 : SwfColors.color5;

    return Row(
      children: [
        // Spice
        _StatItem(
          icon: Icons.local_fire_department_rounded,
          iconColor: book.spiceLevel == SpiceLevel.none
              ? theme.colorScheme.outline
              : SwfColors.color4,
          label: book.spiceLevel.localizedLabel(l10n),
        ),
        _VerticalDivider(color: dividerColor),
        // Age category
        if (book.ageCategory.isNotEmpty) ...[
          _StatItem(
            icon: Icons.people_outline_rounded,
            iconColor: SwfColors.blue,
            label: book.ageCategory,
          ),
          _VerticalDivider(color: dividerColor),
        ],
        // Language
        _StatItem(
          icon: Icons.chat_bubble_outline_rounded,
          iconColor: SwfColors.color6,
          label: book.languageLevel.localizedLabel(l10n),
        ),
        // KU / Audiobook badges
        const Spacer(),
        if (book.kindleUnlimited)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: SwfColors.color6,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                l10n.bookDetailBadgeKu,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        if (book.hasAudiobook)
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: isDark
                  ? SwfColors.color3.withAlpha(120)
                  : SwfColors.color5,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.headphones_rounded,
              size: 15,
              color: theme.colorScheme.onSurface,
            ),
          ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 16,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: color,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reading list button
// ─────────────────────────────────────────────────────────────────────────────

class _ReadingListButton extends StatelessWidget {
  const _ReadingListButton({
    required this.isSaved,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isSaved;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: isSaved
          ? OutlinedButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.bookmark_remove_outlined, size: 18),
              label: Text(
                isLoading ? l10n.bookDetailUpdating : l10n.bookDetailRemoveFromList,
              ),
            )
          : FilledButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.bookmark_add_outlined, size: 18),
              label: Text(isLoading ? l10n.bookDetailSaving : l10n.bookDetailSaveToList),
            ),
    );
  }
}

class _ReadInAppButton extends StatelessWidget {
  const _ReadInAppButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.auto_stories_rounded, size: 18),
        label: Text(isLoading ? l10n.bookDetailOpening : l10n.bookDetailReadInApp),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action buttons — Buy / Audiobook
// ─────────────────────────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.book, required this.onOpenLink});

  final Book book;
  final ValueChanged<String> onOpenLink;

  String? get _amazonUrl {
    if (book.amazonAsin.isEmpty) return null;
    return 'https://www.amazon.com/dp/${book.amazonAsin}?tag=stuffwithfant-20';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final amazonUrl = _amazonUrl;
    final hasPrimary = book.purchaseLink.isNotEmpty;
    final hasAudio = book.audiobookLink.isNotEmpty;
    final hasAny = amazonUrl != null || hasPrimary || hasAudio;

    if (!hasAny) return const SizedBox.shrink();

    // When we have an ASIN: Amazon is the big button, books2read is a text link.
    // When no ASIN: books2read gets the big button instead.
    final primaryUrl = amazonUrl ?? (hasPrimary ? book.purchaseLink : null);
    final primaryLabel = amazonUrl != null
        ? l10n.bookDetailAmazon
        : l10n.bookDetailGetBook;

    return Column(
      children: [
        Row(
          children: [
            if (primaryUrl != null)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => onOpenLink(primaryUrl),
                  icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                  label: Text(primaryLabel),
                ),
              ),
            if (primaryUrl != null && hasAudio) const SizedBox(width: 12),
            if (hasAudio)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onOpenLink(book.audiobookLink),
                  icon: const Icon(Icons.headphones_rounded, size: 18),
                  label: Text(l10n.bookDetailAudiobook),
                ),
              ),
          ],
        ),
        // Show "View all retailers" link when Amazon is the primary button
        if (amazonUrl != null && hasPrimary) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => onOpenLink(book.purchaseLink),
            child: Text(
              l10n.bookDetailAllRetailers,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared small widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? color.withAlpha(50) : color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: isDark ? color : textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Similar book card (horizontal scroll)
// ─────────────────────────────────────────────────────────────────────────────

class _SimilarBookCard extends StatelessWidget {
  const _SimilarBookCard({required this.book, this.onTap});

  final Book book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: book.imageUrl.isNotEmpty
                    ? Image.network(
                        book.imageUrl,
                        fit: BoxFit.cover,
                        width: 120,
                        errorBuilder: (_, _, _) => _miniGradient(book, theme),
                      )
                    : _miniGradient(book, theme),
              ),
            ),
            const SizedBox(height: 6),
            // Title
            Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium,
            ),
            Text(
              book.authorName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _miniGradient(Book book, ThemeData theme) {
    const colors = [SwfColors.color2, SwfColors.color3];
    return Container(
      width: 120,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
    );
  }
}

class _OathLogButton extends StatelessWidget {
  const _OathLogButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: SwfColors.secondaryAccent,
          side: BorderSide(color: SwfColors.secondaryAccent.withAlpha(100)),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: SwfColors.secondaryAccent,
                ),
              )
            : const Icon(Icons.auto_stories_rounded, size: 18),
        label: Text(l10n.oathLogBookAction),
      ),
    );
  }
}
