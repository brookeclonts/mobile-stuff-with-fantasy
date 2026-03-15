import 'package:flutter/material.dart';
import 'package:swf_app/src/catalog/models/book.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

class BookTile extends StatelessWidget {
  const BookTile({super.key, required this.book, this.onTap});

  final Book book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cover image placeholder
            AspectRatio(
              aspectRatio: 2 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _coverGradient(book.id.hashCode),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          book.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // KU badge
                  if (book.kindleUnlimited)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: SwfColors.color6,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'KU',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  // Audiobook badge
                  if (book.hasAudiobook)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.headphones_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Book info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isDark ? SwfColors.color8 : SwfColors.gray,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    book.authorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? SwfColors.lightGray : SwfColors.mediumGray,
                    ),
                  ),
                ],
              ),
            ),

            // Spice + subgenre row
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                children: [
                  _SpiceIndicator(level: book.spiceLevel),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      book.subgenres.first,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _coverGradient(int hash) {
    const palettes = [
      [SwfColors.color2, SwfColors.color3],
      [SwfColors.color7, SwfColors.color3],
      [SwfColors.darkNavy, SwfColors.color4],
      [SwfColors.color3, SwfColors.violet],
      [SwfColors.color7, SwfColors.blue],
      [SwfColors.color2, SwfColors.color6],
    ];
    return palettes[hash.abs() % palettes.length];
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
