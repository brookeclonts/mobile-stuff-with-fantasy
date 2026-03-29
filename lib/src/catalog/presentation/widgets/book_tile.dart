import 'package:flutter/material.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

class BookTile extends StatelessWidget {
  const BookTile({
    super.key,
    required this.book,
    this.onTap,
    this.isSaved = false,
    this.onSaveTap,
  });

  final Book book;
  final VoidCallback? onTap;
  final bool isSaved;
  final VoidCallback? onSaveTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Cover image ──
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _CoverImage(book: book),
                  if (onSaveTap != null)
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onSaveTap,
                          borderRadius: BorderRadius.circular(999),
                          child: Ink(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isSaved
                                  ? SwfColors.color4
                                  : Colors.black.withAlpha(110),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withAlpha(120),
                              ),
                            ),
                            child: Icon(
                              isSaved
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Info section ──
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isDark ? SwfColors.color8 : SwfColors.gray,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Author
                  Text(
                    book.authorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? SwfColors.lightGray
                          : SwfColors.mediumGray,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Spice + primary subgenre
                  Row(
                    children: [
                      _SpiceIndicator(level: book.spiceLevel),
                      if (book.subgenres.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            book.subgenres.first,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Trope chips (show first 2)
                  if (book.tropes.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: book.tropes
                          .take(2)
                          .map((trope) => _TropeChip(label: trope))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Cover image with badges and gradient overlay
// ─────────────────────────────────────────────────────────────────────────────

class _CoverImage extends StatelessWidget {
  const _CoverImage({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        // Cover image or gradient fallback
        if (book.imageUrl.isNotEmpty)
          Image.network(
            book.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _GradientFallback(book: book),
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child; // fully loaded
              return Stack(
                fit: StackFit.expand,
                children: [
                  _GradientFallback(book: book),
                  Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                          : null,
                      color: Colors.white54,
                    ),
                  ),
                ],
              );
            },
          )
        else
          _GradientFallback(book: book),

        // Bottom gradient for readability
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 48,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withAlpha(90)],
              ),
            ),
          ),
        ),

        // Badges
        if (book.hasAudiobook)
          Positioned(
            top: 6,
            left: 6,
            child: _Badge(
              child: Icon(
                Icons.headphones_rounded,
                color: Colors.white,
                size: 13,
              ),
            ),
          ),
        if (book.kindleUnlimited)
          Positioned(
            top: 6,
            right: 6,
            child: _Badge(
              color: SwfColors.color6,
              child: Text(
                'KU',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small building-block widgets
// ─────────────────────────────────────────────────────────────────────────────

class _GradientFallback extends StatelessWidget {
  const _GradientFallback({required this.book});

  final Book book;

  static const _palettes = [
    [SwfColors.color2, SwfColors.color3],
    [SwfColors.color7, SwfColors.color3],
    [SwfColors.darkNavy, SwfColors.color4],
    [SwfColors.color3, SwfColors.violet],
    [SwfColors.color7, SwfColors.blue],
    [SwfColors.color2, SwfColors.color6],
  ];

  @override
  Widget build(BuildContext context) {
    final colors = _palettes[book.id.hashCode.abs() % _palettes.length];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            book.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: color ?? Colors.black45,
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    );
  }
}

class _TropeChip extends StatelessWidget {
  const _TropeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? SwfColors.tropePill.withAlpha(40) : SwfColors.tropePill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelSmall?.copyWith(
          fontSize: 10,
          color: isDark ? SwfColors.tropePill : SwfColors.color3,
        ),
      ),
    );
  }
}

class _SpiceIndicator extends StatelessWidget {
  const _SpiceIndicator({required this.level});

  final SpiceLevel level;

  @override
  Widget build(BuildContext context) {
    final count = level.index; // 0 = none, 4 = scorching
    if (count == 0) {
      return Icon(
        Icons.local_fire_department_outlined,
        size: 14,
        color: Theme.of(context).colorScheme.outline,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (_) {
        return const Padding(
          padding: EdgeInsets.only(right: 1),
          child: Icon(
            Icons.local_fire_department,
            size: 14,
            color: SwfColors.color4,
          ),
        );
      }),
    );
  }
}
