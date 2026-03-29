import 'package:flutter/material.dart';
import 'package:swf_app/src/profile/models/review.dart';
import 'package:swf_app/src/profile/presentation/widgets/review_scroll_card.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// Profile section that shows the user's book reviews as parchment scroll cards.
///
/// Displays up to 3 reviews with a "View All" link if more exist. Shows an
/// empty state when there are no reviews.
class ReviewScrollSection extends StatelessWidget {
  const ReviewScrollSection({
    super.key,
    required this.reviews,
    required this.accentColor,
    required this.expandedReviewIds,
    required this.onToggleExpand,
    required this.onInscribeNew,
    this.onEdit,
    this.onDelete,
    this.isLoading = false,
  });

  final List<Review> reviews;
  final Color accentColor;
  final Set<String> expandedReviewIds;
  final ValueChanged<String> onToggleExpand;
  final VoidCallback onInscribeNew;
  final ValueChanged<Review>? onEdit;
  final ValueChanged<Review>? onDelete;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(color: SwfColors.secondaryAccent),
        ),
      );
    }

    if (reviews.isEmpty) return _EmptyState(onInscribe: onInscribeNew);

    final displayCount = reviews.length > 3 ? 3 : reviews.length;

    return Column(
      children: [
        ...List.generate(displayCount, (i) {
          final review = reviews[i];
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: i < displayCount - 1 ? 10 : 0,
            ),
            child: ReviewScrollCard(
              review: review,
              accentColor: accentColor,
              isExpanded: expandedReviewIds.contains(review.id),
              onToggleExpand: () => onToggleExpand(review.id),
              onEdit: onEdit != null ? () => onEdit!(review) : null,
              onDelete: onDelete != null ? () => onDelete!(review) : null,
            ),
          );
        }),
        const SizedBox(height: 14),
        // ── Inscribe New + View All ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onInscribeNew,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Inscribe New Scroll'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: accentColor,
                    side: BorderSide(color: accentColor.withAlpha(120)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              if (reviews.length > 3) ...[
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    // TODO: navigate to full reviews list
                  },
                  child: Text(
                    'View All (${reviews.length})',
                    style: TextStyle(
                      color: SwfColors.secondaryAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onInscribe});

  final VoidCallback onInscribe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2235),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: SwfColors.secondaryAccent.withAlpha(60),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.edit_note_rounded,
              size: 36,
              color: SwfColors.secondaryAccent.withAlpha(180),
            ),
            const SizedBox(height: 12),
            Text(
              'YOUR SCROLL CASE IS EMPTY',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white.withAlpha(220),
                letterSpacing: 1.5,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Inscribe your first review to begin recording your judgments of the realm\'s literature.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withAlpha(140),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onInscribe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SwfColors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Inscribe First Review',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
