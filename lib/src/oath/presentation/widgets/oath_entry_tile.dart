import 'package:flutter/material.dart';
import 'package:swf_app/src/oath/models/book_oath.dart';

/// A single logged book entry in the oath — styled as a ledger line.
class OathEntryTile extends StatelessWidget {
  const OathEntryTile({
    super.key,
    required this.entry,
    required this.index,
    required this.accentColor,
    this.onRemove,
  });

  final OathEntry entry;
  final int index;
  final Color accentColor;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(8),
        border: Border(
          bottom: BorderSide(color: Colors.white.withAlpha(12)),
        ),
      ),
      child: Row(
        children: [
          // Rune number
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withAlpha(25),
              border: Border.all(
                color: accentColor.withAlpha(60),
              ),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Book title
          Expanded(
            child: Text(
              entry.bookTitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withAlpha(220),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Date
          Text(
            _formatDate(entry.completedAt),
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withAlpha(100),
            ),
          ),

          if (onRemove != null) ...[
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: 16,
                color: Colors.white.withAlpha(60),
              ),
              onPressed: onRemove,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 28,
                minHeight: 28,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
