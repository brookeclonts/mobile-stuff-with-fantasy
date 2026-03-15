import 'package:flutter/material.dart';
import 'package:swf_app/src/api/service_locator.dart';
import 'package:swf_app/src/catalog/models/book.dart';
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

  @override
  void initState() {
    super.initState();
    _loadFullDetail();
    _loadSimilarBooks();
  }

  Future<void> _loadFullDetail() async {
    final result =
        await ServiceLocator.bookRepository.getBook(widget.book.id);
    if (!mounted) return;
    result.when(
      success: (book) => setState(() => _book = book),
      failure: (_, _) {},
    );
  }

  Future<void> _loadSimilarBooks() async {
    final result =
        await ServiceLocator.bookRepository.getSimilarBooks(widget.book.id);
    if (!mounted) return;
    result.when(
      success: (books) => setState(() => _similarBooks = books),
      failure: (_, _) {},
    );
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                      errorBuilder: (_, _, _) =>
                          _buildCoverFallback(theme),
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
                    'by ${_book.authorName}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick stats row
                  _StatsRow(book: _book),
                  const SizedBox(height: 20),

                  // Action buttons
                  _ActionButtons(
                    book: _book,
                    onOpenLink: _openLink,
                  ),
                  const SizedBox(height: 24),

                  // Subgenres
                  if (_book.subgenres.isNotEmpty) ...[
                    _SectionLabel(label: 'Subgenres'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _book.subgenres
                          .map((s) => _Chip(
                                label: s,
                                color: SwfColors.spicinessPill,
                                textColor: SwfColors.color3,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Tropes
                  if (_book.tropes.isNotEmpty) ...[
                    _SectionLabel(label: 'Tropes'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _book.tropes
                          .map((t) => _Chip(
                                label: t,
                                color: SwfColors.tropePill,
                                textColor: SwfColors.color3,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Representations
                  if (_book.representations.isNotEmpty) ...[
                    _SectionLabel(label: 'Representation'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _book.representations
                          .map((r) => _Chip(
                                label: r,
                                color: SwfColors.representationPill,
                                textColor: SwfColors.color7,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Description
                  if (_book.description.isNotEmpty) ...[
                    _SectionLabel(label: 'About this book'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => setState(
                          () => _descriptionExpanded = !_descriptionExpanded),
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
                              'Read more',
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
                child: _SectionLabel(label: 'You might also like'),
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
    final colors =
        palettes[_book.id.hashCode.abs() % palettes.length];
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
          label: book.spiceLevel.label,
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
          label: book.languageLevel.label,
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
                'KU',
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
// Action buttons — Buy / Audiobook
// ─────────────────────────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.book, required this.onOpenLink});

  final Book book;
  final ValueChanged<String> onOpenLink;

  @override
  Widget build(BuildContext context) {
    final hasPrimary = book.purchaseLink.isNotEmpty;
    final hasAlt = book.alternatePurchaseLink.isNotEmpty;
    final hasAudio = book.audiobookLink.isNotEmpty;

    if (!hasPrimary && !hasAlt && !hasAudio) return const SizedBox.shrink();

    return Row(
      children: [
        if (hasPrimary)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => onOpenLink(book.purchaseLink),
              icon: const Icon(Icons.shopping_bag_outlined, size: 18),
              label: const Text('Get this Book'),
            ),
          ),
        if (hasPrimary && hasAudio) const SizedBox(width: 12),
        if (hasAudio)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => onOpenLink(book.audiobookLink),
              icon: const Icon(Icons.headphones_rounded, size: 18),
              label: const Text('Audiobook'),
            ),
          ),
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
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
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
                        errorBuilder: (_, _, _) =>
                            _miniGradient(book, theme),
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
