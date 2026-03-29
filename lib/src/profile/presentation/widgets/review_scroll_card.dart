import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/models/review.dart';
import 'package:swf_app/src/profile/presentation/widgets/quill_rating.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

const _parchment = Color(0xFFF4F0E8);
const _inkDark = Color(0xFF2A1F1A);
const _inkMedium = Color(0xFF5C4F42);

/// A parchment-styled card for displaying a user review.
///
/// Tap to expand/collapse the full body text. Provides an overflow menu
/// for edit and delete actions.
class ReviewScrollCard extends StatelessWidget {
  const ReviewScrollCard({
    super.key,
    required this.review,
    required this.accentColor,
    required this.isExpanded,
    required this.onToggleExpand,
    this.onEdit,
    this.onDelete,
  });

  final Review review;
  final Color accentColor;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      decoration: BoxDecoration(
        color: _parchment,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withAlpha(20),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onToggleExpand,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header: book info + overflow menu ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        width: 40,
                        height: 56,
                        child: review.bookImageUrl.isNotEmpty
                            ? Image.network(
                                review.bookImageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    _ThumbnailFallback(title: review.bookTitle),
                              )
                            : _ThumbnailFallback(title: review.bookTitle),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Book title + author + rating
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.bookTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: _inkDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          if (review.bookAuthor.isNotEmpty)
                            Text(
                              review.bookAuthor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _inkMedium.withAlpha(180),
                                fontSize: 11,
                              ),
                            ),
                          const SizedBox(height: 4),
                          QuillRating(
                            rating: review.rating,
                            size: 14,
                            accentColor: accentColor,
                          ),
                        ],
                      ),
                    ),

                    // Overflow menu
                    if (onEdit != null || onDelete != null)
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: _inkMedium.withAlpha(120),
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onSelected: (value) {
                          if (value == 'edit') onEdit?.call();
                          if (value == 'delete') onDelete?.call();
                        },
                        itemBuilder: (_) => [
                          if (onEdit != null)
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                          if (onDelete != null)
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                        ],
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                // ── Review title ──
                Text(
                  review.title,
                  maxLines: isExpanded ? null : 1,
                  overflow: isExpanded ? null : TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: _inkDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                // ── Review body (expand/collapse) ──
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 240),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: Text(
                    review.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _inkMedium,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  secondChild: Text(
                    review.body,
                    style: const TextStyle(
                      color: _inkMedium,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // ── Date ──
                Text(
                  _formatDate(review.createdAt),
                  style: TextStyle(
                    color: _inkMedium.withAlpha(100),
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _ThumbnailFallback extends StatelessWidget {
  const _ThumbnailFallback({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SwfColors.brandPurple.withAlpha(40),
      alignment: Alignment.center,
      child: Icon(
        Icons.menu_book_rounded,
        size: 16,
        color: SwfColors.brandPurple.withAlpha(100),
      ),
    );
  }
}
