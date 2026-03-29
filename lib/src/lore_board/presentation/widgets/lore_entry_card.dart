import 'package:flutter/material.dart';
import 'package:swf_app/src/lore_board/models/lore_entry.dart';
import 'package:swf_app/src/theme/swf_colors.dart';

/// A single activity entry card on the Lore Board.
class LoreEntryCard extends StatelessWidget {
  const LoreEntryCard({super.key, required this.entry});

  final LoreEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = entry.userName ?? 'An adventurer';
    final icon = _iconForType(entry.type);
    final accent = _accentForType(entry.type);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2235),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha(12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withAlpha(25),
              border: Border.all(color: accent.withAlpha(50)),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withAlpha(200),
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: displayName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: ' ${entry.message}'),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _timeAgo(entry.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withAlpha(80),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(LoreEntryType type) {
    return switch (type) {
      LoreEntryType.questSealed => Icons.verified_rounded,
      LoreEntryType.relicClaimed => Icons.diamond_rounded,
      LoreEntryType.oathSworn => Icons.auto_stories_rounded,
      LoreEntryType.oathProgress => Icons.edit_rounded,
      LoreEntryType.oathFulfilled => Icons.stars_rounded,
      LoreEntryType.guildFounded => Icons.shield_rounded,
      LoreEntryType.guildJoined => Icons.group_add_rounded,
      LoreEntryType.bookLogged => Icons.menu_book_rounded,
      LoreEntryType.unknown => Icons.circle_outlined,
    };
  }

  Color _accentForType(LoreEntryType type) {
    return switch (type) {
      LoreEntryType.questSealed ||
      LoreEntryType.relicClaimed => SwfColors.violet,
      LoreEntryType.oathSworn ||
      LoreEntryType.oathProgress => SwfColors.secondaryAccent,
      LoreEntryType.oathFulfilled => SwfColors.orange,
      LoreEntryType.guildFounded ||
      LoreEntryType.guildJoined => SwfColors.blueBright,
      LoreEntryType.bookLogged => SwfColors.blue,
      LoreEntryType.unknown => Colors.white54,
    };
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${diff.inDays ~/ 7}w ago';
    return '${diff.inDays ~/ 30}mo ago';
  }
}
